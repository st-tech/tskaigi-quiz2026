import { categoryLabel } from '../lib/category';
import { t } from '../lib/i18n';
import type { PublicQuestion } from '../lib/types';
import { CodeBlock } from './CodeBlock.tsrx';

interface QuestionScreenProps {
	question: PublicQuestion;
	index: number;
	total: number;
	selected: string | null;
	onSelect: (answerId: string) => void;
	onBack: () => void;
	onNext: () => void;
}

export component QuestionScreen(&{
	question,
	index,
	total,
	selected,
	onSelect,
	onBack,
	onNext,
}: QuestionScreenProps) {
	<section class="question" aria-labelledby={questionTitleId(question.id)}>
		<p id={questionProgressId(question.id)} class="progress" aria-live="polite">
			{`question ${index + 1} / ${total} / ${categoryLabel(question.category)}`}
		</p>
		<h2 id={questionTitleId(question.id)}>{question.title}</h2>
		if (question.code && question.lang) {
			<CodeBlock code={question.code} lang={question.lang} />
		}
		<fieldset class="choices" aria-describedby={questionProgressId(question.id)}>
			<legend class="visually-hidden">{t.choiceLegend(index)}</legend>
			for (const choice of question.choices; index choiceIndex) {
				<label class={selected === choice.id ? 'choice selected' : 'choice'}>
					<input
						type="radio"
						name={answerGroupName(question.id)}
						value={choice.id}
						checked={selected === choice.id}
						onInput={() => onSelect(choice.id)}
					/>
					<span aria-hidden="true">{String.fromCharCode(65 + choiceIndex)}</span>
					<strong>{choice.text}</strong>
				</label>
			}
		</fieldset>
		<div class="actions">
			<button type="button" onClick={() => onBack()}>
				{index === 0 ? 'Top' : 'Back'}
			</button>
			<button type="button" class="primary" disabled={selected === null} onClick={() => onNext()}>
				{index === total - 1 ? 'Review' : 'Next'}
			</button>
		</div>
	</section>

	<style>
		.question {
			display: grid;
			gap: 0.8rem;
		}

		.progress {
			margin: 0;
			color: #8bd49c;
			font-size: 0.78rem;
		}

		h2 {
			margin: 0;
			color: #f3f7f0;
			font-size: 1.13rem;
			line-height: 1.4;
			overflow-wrap: anywhere;
			word-break: break-word;
			min-width: 0;
		}

		.choices {
			display: grid;
			gap: 0.5rem;
			margin: 0;
			padding: 0;
			border: 0;
		}

		button,
		.choice {
			border-radius: 4px;
			border: 1px solid #34404d;
			background: #121820;
			color: #d8e2ea;
			padding: 0.6rem 0.7rem;
			font: inherit;
			cursor: pointer;
		}

		.choice {
			position: relative;
			display: grid;
			grid-template-columns: 2rem 1fr;
			gap: 0.55rem;
			text-align: left;
			align-items: center;
		}

		.choice input {
			position: absolute;
			width: 1px;
			height: 1px;
			margin: 0;
			opacity: 0;
		}

		.choice:focus-within {
			outline: 3px solid #f0c674;
			outline-offset: 3px;
		}

		.choice span {
			display: inline-grid;
			place-items: center;
			width: 1.7rem;
			height: 1.7rem;
			border: 1px solid #34404d;
			color: #f0c674;
			font-size: 0.78rem;
		}

		.choice.selected {
			border-color: #8bd49c;
			background: #18251c;
		}

		.choice.selected span {
			border-color: #8bd49c;
			background: #8bd49c;
			color: #0b0f14;
		}

		.actions {
			display: flex;
			justify-content: space-between;
			gap: 0.5rem;
		}

		.actions button {
			min-width: 6rem;
		}

		button:disabled {
			opacity: 0.5;
			cursor: not-allowed;
		}

		button.primary {
			border-color: #8bd49c;
			background: #8bd49c;
			color: #0b0f14;
		}
	</style>
}

function questionTitleId(questionId: string): string {
	return `question-${questionId}-title`;
}

function questionProgressId(questionId: string): string {
	return `question-${questionId}-progress`;
}

function answerGroupName(questionId: string): string {
	return `answer-${questionId}`;
}
