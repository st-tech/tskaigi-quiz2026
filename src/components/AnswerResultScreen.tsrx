import { track } from 'ripple';

import type { AnswerEntry, AnswerKeyEntry, AnswerResultEntry, Day, PublicQuestion } from '../lib/types';

const RAINBOW_THRESHOLD = 7;

export component AnswerResultScreen(&{
	questions,
	answers,
	answerKey,
	checkedAt,
	day,
}: {
	questions: PublicQuestion[];
	answers: AnswerEntry[];
	answerKey: AnswerKeyEntry[];
	checkedAt: number;
	day: Day;
}) {
	const results = buildResults(questions, answers, answerKey);
	const correctCount = results.filter((result) => result.status === 'correct').length;
	const isRainbow = correctCount >= RAINBOW_THRESHOLD;
	const total = results.length;
	const isPerfect = total > 0 && correctCount === total;
	const shareText = buildShareText(day, correctCount, total, isPerfect);
	let &[copyStatus] = track<'idle' | 'copied' | 'error'>('idle');

	const copyShare = async () => {
		const payload = shareText;
		try {
			await navigator.clipboard.writeText(payload);
			copyStatus = 'copied';
		} catch (_) {
			copyStatus = 'error';
		}
		window.setTimeout(() => {
			copyStatus = 'idle';
		}, 2000);
	};

	<section class="result" aria-labelledby="answer-result-title">
		<ol class="answers" aria-label="正誤結果">
			for (const question of questions; index index; key question.id) {
				const result = results.find((entry) => entry.questionId === question.id);
				const selectedId = result?.selectedAnswerId ?? null;
				const correctId = result?.correctAnswerId ?? null;
				const selectedText = choiceText(question, selectedId);
				const correctText = choiceText(question, correctId);
				const status = result?.status ?? 'unanswered';
				<li class={status === 'correct' ? 'answer correct' : 'answer incorrect'}>
					<details open={status !== 'correct'}>
						<summary>
							<span class="marker" aria-hidden="true" />
							<span class="num">{String(index + 1).padStart(2, '0')}</span>
							<strong class="status">{status === 'correct' ? 'correct' : 'incorrect'}</strong>
							<span class="title">{question.title}</span>
						</summary>
						<dl>
							<div>
								<dt>{'Your answer'}</dt>
								<dd>{selectedText}</dd>
							</div>
							<div>
								<dt>{'Correct answer'}</dt>
								<dd>{correctText}</dd>
							</div>
						</dl>
					</details>
				</li>
			}
		</ol>

		<div class="summary">
			<div class="summary-head">
				<h1>{'answer result'}</h1>
				<h2
					id="answer-result-title"
					class={isRainbow ? 'score-text rainbow' : 'score-text'}
					aria-label={`正解数 ${correctCount} / ${total}`}
				>
					{`${correctCount} / ${total} correct${isPerfect ? '!!' : ''}`}
				</h2>
				<p class="meta">{`${formatDate(checkedAt)} / 詳しい説明は後日公開予定です。`}</p>
			</div>

		</div>

		<div class="share" aria-label="結果をシェア">
			<p class="share-eyebrow">{'share your score'}</p>
			<div class="share-buttons">
				<a
					class="share-btn x"
					href={buildXUrl(shareText)}
					target="_blank"
					rel="noopener noreferrer"
				>
					{'Post on X'}
				</a>
				<button type="button" class="share-btn copy" onClick={() => copyShare()}>
					{copyStatus === 'copied' ? 'Copied!' : copyStatus === 'error' ? 'Copy failed' : 'Copy text'}
				</button>
			</div>
		</div>
	</section>

	<style>
		.result {
			display: grid;
			gap: 0.9rem;
		}

		.summary {
			display: grid;
			gap: 0.85rem;
			border-top: 1px solid #34404d;
			padding-top: 1rem;
		}

		.summary-head {
			display: grid;
			gap: 0.2rem;
			text-align: center;
		}

		.eyebrow,
		.meta {
			margin: 0;
			color: #96a3af;
			font-size: 0.78rem;
		}

		.meta {
			margin-bottom: 2rem;
		}

		h2,
		h3 {
			margin: 0.2rem;
			color: #f3f7f0;
			line-height: 1.2;
		}

		.score-text {
			font-size: 2.4rem;
			font-weight: 700;
			letter-spacing: 0.02em;
			color: #8bd49c;
			margin-bottom: 2rem;
		}

		.score-text.rainbow {
			background: linear-gradient(
				90deg,
				#ff6ec7 0%,
				#ff8c42 14%,
				#ffd166 28%,
				#8be78b 42%,
				#4fc3f7 56%,
				#9b8cff 70%,
				#ff6ec7 84%,
				#ff8c42 100%
			);
			background-size: 300% auto;
			-webkit-background-clip: text;
			background-clip: text;
			color: transparent;
			-webkit-text-fill-color: transparent;
			animation: rainbow-shift 6s linear infinite;
			filter: drop-shadow(0 0 0.45rem rgba(255, 110, 199, 0.25));
		}

		@keyframes rainbow-shift {
			0% {
				background-position: 0% 50%;
			}
			100% {
				background-position: 300% 50%;
			}
		}

		.answers {
			display: grid;
			gap: 0.65rem;
			margin: 0;
			padding: 0;
			list-style: none;
		}

		.answer {
			border: 1px solid #34404d;
			background: #0f151c;
		}

		.answer.correct {
			border-left: 4px solid #8bd49c;
		}

		.answer.incorrect {
			border-left: 4px solid #e06c75;
		}

		.answer details summary {
			display: grid;
			grid-template-columns: 1.1rem 2rem auto 1fr;
			gap: 0.55rem;
			align-items: baseline;
			padding: 0.7rem 0.75rem;
			cursor: pointer;
			list-style: none;
		}

		.answer details summary::-webkit-details-marker {
			display: none;
		}

		.answer details summary::marker {
			content: '';
		}

		.answer details summary:focus-visible {
			outline: 2px solid #f0c674;
			outline-offset: -2px;
		}

		.answer .marker::before {
			content: '▸';
			color: #96a3af;
		}

		.answer details[open] .marker::before {
			content: '▾';
		}

		.answer .num {
			color: #96a3af;
			font-size: 0.78rem;
			font-variant-numeric: tabular-nums;
		}

		.answer .status {
			font-size: 0.78rem;
			letter-spacing: 0.06em;
		}

		.answer.correct .status {
			color: #8bd49c;
		}

		.answer.incorrect .status {
			color: #e06c75;
		}

		.answer .title {
			color: #f3f7f0;
			font-size: 0.95rem;
			line-height: 1.35;
		}

		.answer details[open] summary {
			border-bottom: 1px solid #1f2731;
		}

		.answer dl {
			margin: 0;
			padding: 0.6rem 0.75rem 0.85rem;
			display: grid;
			gap: 0.4rem;
		}

		.answer dl div {
			display: grid;
			grid-template-columns: 7.5rem 1fr;
			gap: 0.5rem;
		}

		.answer dt {
			color: #96a3af;
			font-size: 0.78rem;
		}

		.answer dd {
			margin: 0;
			color: #d8e2ea;
			line-height: 1.5;
		}

		@media (max-width: 640px) {
			.score-text {
				font-size: 2rem;
			}

			.answer dl div {
				grid-template-columns: 1fr;
				gap: 0.1rem;
			}

			.answer details summary {
				grid-template-columns: 1rem 1.7rem auto 1fr;
				gap: 0.4rem;
				padding: 0.6rem;
			}

			.answer .title {
				font-size: 0.88rem;
			}
		}
		.share {
			display: grid;
			gap: 0.55rem;
			margin-top: 1.2rem;
			padding-top: 1rem;
			border-top: 1px solid #34404d;
		}

		.share-eyebrow {
			margin: 0;
			color: #8bd49c;
			font-size: 0.78rem;
			letter-spacing: 0.18em;
			text-transform: uppercase;
			text-align: center;
		}

		.share-buttons {
			display: flex;
			flex-wrap: wrap;
			gap: 0.55rem;
			justify-content: center;
		}

		.share-btn {
			display: inline-flex;
			align-items: center;
			justify-content: center;
			min-height: 2.4rem;
			padding: 0.45rem 0.95rem;
			border-radius: 4px;
			border: 1px solid #34404d;
			background: #121820;
			color: #d8e2ea;
			font: inherit;
			font-size: 0.85rem;
			text-decoration: none;
			cursor: pointer;
			transition: background 0.15s ease, color 0.15s ease, border-color 0.15s ease;
		}

		.share-btn:hover {
			background: #1a2330;
		}

		.share-btn.x:hover {
			border-color: #f3f7f0;
			color: #f3f7f0;
		}

		.share-btn.copy {
			font-variant-numeric: tabular-nums;
			min-width: 7rem;
		}
	</style>
}

function buildResults(
	questions: PublicQuestion[],
	answers: AnswerEntry[],
	answerKey: AnswerKeyEntry[],
): AnswerResultEntry[] {
	const selectedByQuestion = new Map(answers.map((answer) => [answer.questionId, answer.answerId]));
	const correctByQuestion = new Map(answerKey.map((entry) => [entry.questionId, entry.answerId]));

	return questions.map((question) => {
		const selectedAnswerId = selectedByQuestion.get(question.id) ?? null;
		const correctAnswerId = correctByQuestion.get(question.id) ?? '';
		const status =
			selectedAnswerId === null
				? 'unanswered'
				: selectedAnswerId === correctAnswerId
					? 'correct'
					: 'wrong';

		return {
			questionId: question.id,
			selectedAnswerId,
			correctAnswerId,
			status,
		};
	});
}

function choiceText(question: PublicQuestion, answerId: string | null): string {
	if (answerId === null || answerId === '') return 'no answer';
	return question.choices.find((choice) => choice.id === answerId)?.text ?? 'unknown answer';
}

function formatDate(value: number): string {
	return new Intl.DateTimeFormat('ja-JP', {
		month: '2-digit',
		day: '2-digit',
		hour: '2-digit',
		minute: '2-digit',
	}).format(value);
}


function buildShareText(day: Day, correctCount: number, total: number, isPerfect: boolean): string {
	const score = isPerfect ? `${total}問全問正解！🎉` : `${correctCount}問正解！🙌`;
	return [
		'TSKaigi 2026のZOZOブースでTypeScriptクイズに挑戦しました！',
		`Day${day}の結果は...${score}`,
		'',
		'#TSKaigi #TSKaigi2026 #ZOZO',
	].join('\n');
}

function buildXUrl(text: string): string {
	const params = new URLSearchParams({ text });
	return `https://twitter.com/intent/tweet?${params.toString()}`;
}
