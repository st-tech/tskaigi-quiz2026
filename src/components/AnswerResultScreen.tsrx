import type { AnswerEntry, AnswerKeyEntry, AnswerResultEntry, PublicQuestion } from '../lib/types';

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
	const percent =
		results.length === 0 ? 0 : Math.round((correctCount / results.length) * 100);

	<section class="result" aria-labelledby="answer-result-title">
		<div class="summary">
			<div>
				<p class="eyebrow">{'answer result'}</p>
				<h2 id="answer-result-title">{`${correctCount} / ${results.length} correct`}</h2>
				<p class="meta">{`${formatDate(checkedAt)} / 詳しい説明は後日公開予定です。`}</p>
			</div>
			<strong class="score" aria-label={`正答率 ${percent}%`}>{`${percent}%`}</strong>
		</div>

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
	</section>

	<style>
		.result {
			display: grid;
			gap: 0.9rem;
		}

		.summary {
			display: flex;
			justify-content: space-between;
			align-items: center;
			gap: 1rem;
			border-bottom: 1px solid #34404d;
			padding-bottom: 0.75rem;
		}

		.eyebrow,
		.meta {
			margin: 0;
			color: #96a3af;
			font-size: 0.78rem;
		}

		.eyebrow {
			color: #8bd49c;
		}

		h2,
		h3 {
			margin: 0.2rem 0;
			color: #f3f7f0;
			line-height: 1.3;
		}

		h2 {
			font-size: 1.2rem;
		}

		h3 {
			font-size: 0.98rem;
		}

		.score {
			font-size: 2rem;
			color: #8bd49c;
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
			.summary {
				align-items: flex-start;
			}

			.score {
				font-size: 1.5rem;
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
