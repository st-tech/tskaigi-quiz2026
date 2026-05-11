import { track } from 'ripple';

import { getQuestionsForDay } from './data/questions.public';
import { IntroScreen } from './components/IntroScreen.tsrx';
import { QrDisplay } from './components/QrDisplay.tsrx';
import { QuestionScreen } from './components/QuestionScreen.tsrx';
import { ReviewScreen } from './components/ReviewScreen.tsrx';
import { TerminalLayout } from './components/TerminalLayout.tsrx';
import { loadAnswerSet, saveAnswerSet } from './lib/storage';
import type { AnswerEntry, AnswerSet, Day } from './lib/types';
import { getOrCreateUserId } from './lib/userId';

type Screen = { kind: 'intro' } | { kind: 'quiz'; index: number } | { kind: 'review' } | {
	kind: 'qr';
};

const day = readDay();
const userId = getOrCreateUserId();
const questions = getQuestionsForDay(day);
const storedAnswerSet = loadAnswerSet(day);
const savedAnswerSet =
	storedAnswerSet && matchesQuestions(storedAnswerSet.answers) ? storedAnswerSet : null;
const initialAnswers =
	savedAnswerSet
		? savedAnswerSet.answers
		: questions.map(
				(question) => ({
					questionId: question.id,
					answerId: null,
				}),
			);

export component App() {
	let &[screen] = track<Screen>(savedAnswerSet ? { kind: 'qr' } : { kind: 'intro' });
	let &[answers] = track<AnswerEntry[]>(initialAnswers);
	let &[submitted] = track<AnswerSet | null>(savedAnswerSet);

	const setAnswer = (questionId: string, answerId: string) => {
		answers = answers.map(
			(answer) => (answer.questionId === questionId ? { ...answer, answerId } : answer),
		);
	};

	const submit = () => {
		if (countAnswered(answers) !== questions.length) return;

		const next: AnswerSet = {
			userId,
			answers,
			submittedAt: Date.now(),
		};
		saveAnswerSet(day, next);
		submitted = next;
		screen = { kind: 'qr' };
	};

	<TerminalLayout>
		switch (screen.kind) {
			case 'intro':
				<IntroScreen
					{day}
					total={questions.length}
					answered={countAnswered(answers)}
					{userId}
					hasSubmitted={submitted !== null}
					onStart={() => (screen = {
						kind: 'quiz',
						index: firstUnansweredIndex(answers),
					})}
					onShowQr={() => (screen = { kind: 'qr' })}
				/>
				break;
			case 'quiz':
				<QuestionScreen
					question={currentQuestion(screen)}
					index={currentQuizIndex(screen)}
					total={questions.length}
					selected={findAnswer(answers, currentQuestion(screen).id)}
					onSelect={(answer) => setAnswer(currentQuestion(screen).id, answer)}
					onBack={() => {
						const currentIndex = currentQuizIndex(screen);
						screen = currentIndex === 0
							? { kind: 'intro' }
							: { kind: 'quiz', index: currentIndex - 1 };
					}}
					onNext={() => {
						const currentIndex = currentQuizIndex(screen);
						screen = currentIndex === questions.length - 1
							? { kind: 'review' }
							: { kind: 'quiz', index: currentIndex + 1 };
					}}
				/>
				break;
			case 'review':
				<ReviewScreen
					{questions}
					{answers}
					onEdit={(index) => (screen = { kind: 'quiz', index })}
					onSubmit={submit}
					onBack={() => (screen = { kind: 'quiz', index: questions.length - 1 })}
				/>
				break;
			case 'qr':
				const answerSet = submitted;
				if (answerSet) {
					<QrDisplay {day} {answerSet} onRestart={() => (screen = { kind: 'quiz', index: 0 })} />
				} else {
					<IntroScreen
						{day}
						total={questions.length}
						answered={countAnswered(answers)}
						{userId}
						hasSubmitted={false}
						onStart={() => (screen = {
							kind: 'quiz',
							index: firstUnansweredIndex(answers),
						})}
						onShowQr={() => (screen = { kind: 'intro' })}
					/>
				}
				break;
		}
	</TerminalLayout>
}

function readDay(): Day {
	return getJstDayOfMonth() % 2 === 0 ? 1 : 2;
}

function getJstDayOfMonth(now = new Date()): number {
	return Number(
		new Intl.DateTimeFormat('en-US', {
			timeZone: 'Asia/Tokyo',
			day: 'numeric',
		}).format(now),
	);
}

function firstUnansweredIndex(answers: AnswerEntry[]): number {
	const index = questions.findIndex((question) => findAnswer(answers, question.id) === null);
	return index === -1 ? 0 : index;
}

function currentQuizIndex(screen: Screen): number {
	return screen.kind === 'quiz' ? screen.index : 0;
}

function currentQuestion(screen: Screen) {
	return questions[currentQuizIndex(screen)] ?? questions[0];
}

function findAnswer(answers: AnswerEntry[], questionId: string): string | null {
	return answers.find((answer) => answer.questionId === questionId)?.answerId ?? null;
}

function countAnswered(answers: AnswerEntry[]): number {
	return answers.filter((answer) => answer.answerId !== null).length;
}

function matchesQuestions(answers: AnswerEntry[]): boolean {
	const questionChoicesById = new Map<string, Set<string>>();
	for (const question of questions) {
		questionChoicesById.set(question.id, new Set(question.choices.map((choice) => choice.id)));
	}

	if (answers.length !== questions.length) return false;
	for (const answer of answers) {
		const choices = questionChoicesById.get(answer.questionId);
		if (choices === undefined) return false;
		if (answer.answerId !== null && !choices.has(answer.answerId)) return false;
	}
	return true;
}
