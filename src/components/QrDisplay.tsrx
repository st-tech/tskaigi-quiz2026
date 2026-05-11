import QRCode from 'qrcode';
import { effect, track } from 'ripple';

import { encodeAnswerSet } from '../lib/qr-codec';
import type { AnswerSet } from '../lib/types';

export component QrDisplay(&{
	day,
	answerSet,
	onRestart,
}: {
	day: 1 | 2;
	answerSet: AnswerSet;
	onRestart: () => void;
}) {
	const svg = track('Generating QR code...');
	let root = track<HTMLDivElement | null>(null);

	effect(() => {
		let cancelled = false;
		const encoded = encodeAnswerSet(answerSet);
		svg.value = 'Generating QR code...';
		void QRCode.toString(encoded, {
			type: 'svg',
			margin: 1,
			errorCorrectionLevel: 'M',
			color: {
				dark: '#0b0f14',
				light: '#f3f7f0',
			},
		}).then((value) => {
			if (!cancelled) svg.value = value;
		});

		return () => {
			cancelled = true;
		};
	});

	effect(() => {
		if (root.value && root.value.innerHTML !== svg.value) {
			root.value.innerHTML = svg.value;
		}
	});

	<section class="qr" aria-labelledby="qr-title">
		<p class="eyebrow">{`submitted / ${answerSet.userId} / day ${day}`}</p>
		<h2 id="qr-title">{'Submission QR'}</h2>
		<p id="qr-hint" class="hint">{'ブースでスタッフにこのQRを提示してください。'}</p>
		<div
			class="qrbox"
			role="img"
			aria-label={`提出用QR。ユーザーID ${answerSet.userId}、day ${day}`}
			aria-describedby="qr-hint"
			aria-busy={svg.value === 'Generating QR code...'}
			{ref root}
		/>
		<button type="button" onClick={() => onRestart()}>{'Edit answers'}</button>
	</section>

	<style>
		.qr {
			display: grid;
			gap: 0.8rem;
			justify-items: center;
			text-align: center;
		}

		.eyebrow {
			justify-self: stretch;
			margin: 0;
			color: #8bd49c;
			font-size: 0.78rem;
			text-align: left;
		}

		h2 {
			margin: 0;
			color: #f3f7f0;
			font-size: 1.2rem;
		}

		.hint {
			margin: 0;
			color: #d8e2ea;
			font-size: 0.86rem;
		}

		.qrbox {
			width: min(100%, 19rem);
			aspect-ratio: 1;
			display: grid;
			place-items: center;
			background: #f3f7f0;
			border: 1px solid #34404d;
			padding: 0.5rem;
			box-sizing: border-box;
		}

		.qrbox :global(svg) {
			display: block;
			width: 100%;
			height: 100%;
		}

		code {
			justify-self: stretch;
			display: block;
			padding: 0.55rem;
			background: #0f151c;
			border: 1px solid #34404d;
			color: #f0c674;
			font-size: 0.75rem;
			overflow-wrap: anywhere;
			text-align: left;
		}

		button {
			min-height: 2.55rem;
			border-radius: 4px;
			border: 1px solid #34404d;
			background: #121820;
			color: #d8e2ea;
			padding: 0.45rem 0.75rem;
			font: inherit;
			cursor: pointer;
		}
	</style>
}
