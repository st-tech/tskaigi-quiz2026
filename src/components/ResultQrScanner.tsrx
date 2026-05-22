import { BarcodeDetector } from 'barcode-detector/ponyfill';
import { track } from 'ripple';

import { t } from '../lib/i18n';

type VideoWithFrameCallback = HTMLVideoElement & {
	requestVideoFrameCallback?: (callback: (now: number, metadata: unknown) => void) => number;
	cancelVideoFrameCallback?: (handle: number) => void;
};

const ANSWER_KEY_PATTERN = /^(?:[0-9a-f]{4}:[0-9a-f]{4};)+$/i;

export component ResultQrScanner(&{
	onScan,
	onError,
	onCancel,
}: {
	onScan: (value: string) => void;
	onError: (message: string) => void;
	onCancel: () => void;
}) {
	let &[status] = track(t.cameraStarting);

	const startScanner = (video: HTMLVideoElement) => {
		let stopped = false;
		let stream: MediaStream | undefined;
		let timer: number | undefined;
		let frameHandle: number | undefined;
		const detector = new BarcodeDetector({ formats: ['qr_code'] });
		const videoWithCallback = video as VideoWithFrameCallback;

		const stop = () => {
			stopped = true;
			if (timer !== undefined) {
				window.clearTimeout(timer);
			}
			if (frameHandle !== undefined) {
				videoWithCallback.cancelVideoFrameCallback?.(frameHandle);
			}
			stream?.getTracks().forEach((track) => track.stop());
		};

		const schedule = () => {
			if (stopped) return;
			if (videoWithCallback.requestVideoFrameCallback) {
				frameHandle = videoWithCallback.requestVideoFrameCallback(() => void scan());
				return;
			}
			timer = window.setTimeout(() => void scan(), 250);
		};

		const scan = async () => {
			if (stopped) return;
			try {
				if (video.readyState >= HTMLMediaElement.HAVE_CURRENT_DATA) {
					const detected = await detector.detect(video);
					const qr = detected.find((item) => ANSWER_KEY_PATTERN.test(item.rawValue.trim()));
					if (qr) {
						status = t.qrScanned;
						stop();
						onScan(qr.rawValue);
						return;
					}
				}
			} catch (error) {
				const message =
					error instanceof Error ? error.message : t.qrReadFailed;
				onError(message);
			}
			schedule();
		};

		void (async () => {
			try {
				if (!navigator.mediaDevices?.getUserMedia) {
					throw new Error(t.cameraUnavailable);
				}

				stream = await navigator.mediaDevices.getUserMedia(
					{
						audio: false,
						video: {
							facingMode: { ideal: 'environment' },
							width: { ideal: 1280 },
							height: { ideal: 720 },
						},
					},
				);
				if (stopped) {
					stream.getTracks().forEach((track) => track.stop());
					return;
				}

				video.srcObject = stream;
				await video.play();
				status = t.qrPrompt;
				schedule();
			} catch (error) {
				const message =
					error instanceof Error ? error.message : t.cameraStartFailed;
				status = t.cameraError;
				onError(message);
			}
		})();

		return stop;
	};

	<section class="scanner" aria-labelledby="scanner-title">
		<div class="head">
			<h2 id="scanner-title">{'Scan staff QR'}</h2>
			<button type="button" onClick={() => onCancel()}>{'Back'}</button>
		</div>
		<video
			ref={(node: HTMLVideoElement) => startScanner(node)}
			playsInline
			muted
			aria-label={t.cameraAriaLabel}
			aria-describedby="scanner-status"
		/>
		<p id="scanner-status" class="status" role="status" aria-live="polite">{status}</p>
	</section>

	<style>
		.scanner {
			display: grid;
			gap: 0.75rem;
		}

		.head {
			display: flex;
			align-items: center;
			justify-content: space-between;
			gap: 0.75rem;
		}

		h2 {
			margin: 0;
			color: #f3f7f0;
			font-size: 1.2rem;
		}

		video {
			width: 100%;
			aspect-ratio: 4 / 3;
			object-fit: cover;
			background: #05070a;
			border: 1px solid #34404d;
		}

		.status {
			margin: 0;
			color: #f0c674;
			font-size: 0.9rem;
		}

		button {
			min-height: 2.3rem;
			border-radius: 4px;
			border: 1px solid #34404d;
			background: #121820;
			color: #d8e2ea;
			padding: 0.35rem 0.65rem;
			font: inherit;
			cursor: pointer;
		}
	</style>
}
