import { t } from '../lib/i18n';
import type { AnswerEntry, PublicQuestion } from '../lib/types';

export component ReviewScreen(&{
	questions,
	answers,
	onEdit,
	onSubmit,
	onBack,
}: {
	questions: PublicQuestion[];
	answers: AnswerEntry[];
	onEdit: (index: number) => void;
	onSubmit: () => void;
	onBack: () => void;
}) {
	const allAnswered = countAnswered(answers) === questions.length;

	<section class="review" aria-labelledby="review-title">
		<div class="head">
			<p>{'review'}</p>
			<h2 id="review-title">{`${countAnswered(answers)} / ${questions.length} answered`}</h2>
		</div>
		<ol class="list" aria-label={t.answerListAriaLabel}>
			for (const question of questions; index index; key question.id) {
				const answer = answers.find((entry) => entry.questionId === question.id)?.answerId ?? null;
				const answerText =
					question.choices.find((choice) => choice.id === answer)?.text ?? 'unknown answer';
				const displayAnswer =
					answer === null ? 'no answer' : answerText;
				const accessibleAnswer =
					answer === null ? t.unanswered : answerText;
				<li>
					<button
						type="button"
						class="item"
						aria-label={reviewItemLabel(index, question.title, accessibleAnswer)}
						onClick={() => onEdit(index)}
					>
						<span aria-hidden="true">{String(index + 1).padStart(2, '0')}</span>
						<strong>{question.title}</strong>
						<small>{displayAnswer}</small>
					</button>
				</li>
			}
		</ol>
		<div class="actions">
			<button type="button" onClick={() => onBack()}>{'Back'}</button>
			<button type="button" class="primary" disabled={!allAnswered} onClick={() => onSubmit()}>
				{'Submit'}
			</button>
		</div>
	</section>

	<style>
		.review {
			display: grid;
			gap: 0.8rem;
		}

		.head {
			border-bottom: 1px solid #34404d;
			padding-bottom: 0.7rem;
		}

		p,
		h2 {
			margin: 0;
		}

		.head p,
		small,
		.item span {
			color: #96a3af;
			font-size: 0.78rem;
		}

		h2 {
			margin-top: 0.2rem;
			color: #f3f7f0;
		}

		.list {
			display: grid;
			gap: 0.45rem;
			margin: 0;
			padding: 0;
			list-style: none;
		}

		.list li {
			margin: 0;
		}

		button {
			border-radius: 4px;
			border: 1px solid #34404d;
			background: #121820;
			color: #d8e2ea;
			padding: 0.6rem 0.7rem;
			font: inherit;
			cursor: pointer;
		}

		.item {
			display: grid;
			grid-template-columns: 2.2rem 1fr;
			gap: 0.25rem 0.55rem;
			text-align: left;
			align-items: start;
			width: 100%;
		}

		.item strong {
			grid-column: 2;
			overflow-wrap: anywhere;
			word-break: break-word;
			min-width: 0;
		}

		.item small {
			grid-column: 2;
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
			min-width: 0;
		}

		.actions {
			display: flex;
			justify-content: space-between;
			gap: 0.5rem;
		}

		.actions button {
			min-width: 6rem;
		}

		button.primary {
			border-color: #8bd49c;
			background: #8bd49c;
			color: #0b0f14;
		}

		button:disabled {
			opacity: 0.5;
			cursor: not-allowed;
		}
	</style>
}

function reviewItemLabel(index: number, title: string, answer: string): string {
	return t.reviewItemLabel(index, title, answer);
}

function countAnswered(answers: AnswerEntry[]): number {
	return answers.filter((answer) => answer.answerId !== null).length;
}
