import type { AnswerEntry, AnswerKeyEntry, AnswerResultEntry, PublicQuestion } from '../lib/types';

const RAINBOW_THRESHOLD = 7;

export component AnswerResultScreen(&{
	questions,
	answers,
	answerKey,
	checkedAt,
}: {
	questions: PublicQuestion[];
	answers: AnswerEntry[];
	answerKey: AnswerKeyEntry[];
	checkedAt: number;
}) {
	const results = buildResults(questions, answers, answerKey);
	const correctCount = results.filter((result) => result.status === 'correct').length;
	const isRainbow = correctCount >= RAINBOW_THRESHOLD;
	const total = results.length;
	const isPerfect = total > 0 && correctCount === total;

	<section class="result" aria-labelledby="answer-result-title">
		<ol class="answers" aria-label="正誤結果">
			for (const question of questions; index index; key question.id) {
				const result = results.find((entry) => entry.questionId === question.id);
				const selectedId = result?.selectedAnswerId ?? null;
				const correctId = result?.correctAnswerId ?? null;
				const selectedText = choiceText(question, selectedId);
				const correctText = choiceText(question, correctId);
				const status = result?.status ?? 'unanswered';
				<li
					class={status === 'correct'
						? 'answer correct'
						: status === 'wrong'
							? 'answer wrong'
							: 'answer unanswered'}
				>
					<div class="answer-head">
						<span>{String(index + 1).padStart(2, '0')}</span>
						<strong>{statusLabel(status)}</strong>
					</div>
					<h3>{question.title}</h3>
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

		h3 {
			font-size: 0.98rem;
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
			padding: 0.75rem;
		}

		.answer.correct {
			border-left: 4px solid #8bd49c;
		}

		.answer.wrong {
			border-left: 4px solid #e06c75;
		}

		.answer.unanswered {
			border-left: 4px solid #f0c674;
		}

		.answer-head {
			display: flex;
			justify-content: space-between;
			gap: 0.75rem;
			color: #96a3af;
			font-size: 0.78rem;
		}

		.answer-head strong {
			color: #d8e2ea;
		}

		dl {
			display: grid;
			gap: 0.4rem;
			margin: 0.65rem 0 0;
		}

		dl div {
			display: grid;
			grid-template-columns: 7.5rem 1fr;
			gap: 0.5rem;
		}

		dt {
			color: #96a3af;
			font-size: 0.78rem;
		}

		dd {
			margin: 0;
			color: #d8e2ea;
			line-height: 1.5;
		}

		@media (max-width: 640px) {
			.score-text {
				font-size: 2rem;
			}

			dl div {
				grid-template-columns: 1fr;
				gap: 0.1rem;
			}
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

function statusLabel(status: AnswerResultEntry['status']): string {
	if (status === 'correct') return 'OK';
	if (status === 'wrong') return 'NG';
	return 'NO ANSWER';
}

function formatDate(value: number): string {
	return new Intl.DateTimeFormat('ja-JP', {
		month: '2-digit',
		day: '2-digit',
		hour: '2-digit',
		minute: '2-digit',
	}).format(value);
}

