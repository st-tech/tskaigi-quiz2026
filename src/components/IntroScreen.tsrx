export component IntroScreen(&{
	day,
	total,
	answered,
	userId,
	hasSubmitted,
	onStart,
	onShowQr,
}: {
	day: 1 | 2;
	total: number;
	answered: number;
	userId: string;
	hasSubmitted: boolean;
	onStart: () => void;
	onShowQr: () => void;
}) {
	<section class="intro" aria-labelledby="intro-title">
		<p class="eyebrow">{`day ${day} / id ${userId}`}</p>
		<h2 id="intro-title">{'TSKaigi 2026 Booth Quiz'}</h2>
		<dl class="status" aria-label="回答状況">
			<div>
				<dt>{'Questions'}</dt>
				<dd>{String(total)}</dd>
			</div>
			<div>
				<dt>{'Answered'}</dt>
				<dd>{String(answered)}</dd>
			</div>
		</dl>
		<div class="actions">
			<button
				type="button"
				class="primary"
				aria-label={answered > 0 ? '未回答の問題から再開' : 'クイズを開始'}
				onClick={() => onStart()}
			>
				{answered > 0 ? 'Continue' : 'Start'}
			</button>
			if (hasSubmitted) {
				<button type="button" aria-label="提出済みQRを表示" onClick={() => onShowQr()}>
					{'Show QR'}
				</button>
			}
		</div>
	</section>

	<style>
		.intro {
			display: grid;
			gap: 0.9rem;
		}

		.eyebrow {
			margin: 0;
			color: #8bd49c;
			font-size: 0.78rem;
		}

		h2 {
			margin: 0;
			color: #f3f7f0;
			font-size: 1.35rem;
			line-height: 1.25;
		}

		.status {
			display: grid;
			grid-template-columns: repeat(2, minmax(0, 1fr));
			gap: 0.5rem;
			margin: 0;
		}

		.status div {
			border: 1px solid #34404d;
			background: #0f151c;
			padding: 0.65rem;
		}

		.status dt {
			margin: 0 0 0.15rem;
			color: #96a3af;
			font-size: 0.72rem;
		}

		.status dd {
			margin: 0;
			color: #d8e2ea;
			font-size: 0.86rem;
		}

		.actions {
			display: flex;
			gap: 0.5rem;
			flex-wrap: wrap;
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

		button.primary {
			border-color: #8bd49c;
			background: #8bd49c;
			color: #0b0f14;
		}
	</style>
}
