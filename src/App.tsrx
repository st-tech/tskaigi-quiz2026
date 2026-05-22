import { track } from 'ripple';

import { getQuestionsForDay } from './data/questions.public';
import { AnswerResultScreen } from './components/AnswerResultScreen.tsrx';
import { BoothGuide } from './components/BoothGuide.tsrx';
import { IntroScreen } from './components/IntroScreen.tsrx';
import { QuestionScreen } from './components/QuestionScreen.tsrx';
import { ReviewScreen } from './components/ReviewScreen.tsrx';
import { ResultQrScanner } from './components/ResultQrScanner.tsrx';
import { TerminalLayout } from './components/TerminalLayout.tsrx';
import { AnswerKeyCodecError, decodeAnswerKey } from './lib/answer-key-codec';
import { loadAnswerCheck, loadAnswerSet, saveAnswerCheck, saveAnswerSet } from './lib/storage';
import type {
	AnswerCheck,
	AnswerEntry,
	AnswerKeyEntry,
	AnswerSet,
	Day,
	PublicQuestion,
} from './lib/types';
import { t } from './lib/i18n';
import { getOrCreateUserId } from './lib/userId';

type Screen = { kind: 'intro' } | { kind: 'quiz'; index: number } | { kind: 'review' } | {
	kind: 'booth';
} | { kind: 'scan-result-qr' } | { kind: 'result' };

const day = readDay();
const userId = getOrCreateUserId();
const questions = getQuestionsForDay(day);
const storedAnswerSet = loadAnswerSet(day);
const savedAnswerSet =
	storedAnswerSet && matchesQuestions(storedAnswerSet.answers) ? storedAnswerSet : null;
const storedAnswerCheck = loadAnswerCheck(day);
const savedAnswerCheck =
	savedAnswerSet && storedAnswerCheck && matchesAnswerKey(storedAnswerCheck.answerKey)
		? storedAnswerCheck
		: null;
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
	let &[screen] = track<Screen>(
		savedAnswerSet
			? savedAnswerCheck
				? { kind: 'result' }
				: { kind: 'booth' }
			: { kind: 'intro' },
	);
	let &[answers] = track<AnswerEntry[]>(initialAnswers);
	let &[submitted] = track<AnswerSet | null>(savedAnswerSet);
	let &[answerCheck] = track<AnswerCheck | null>(savedAnswerCheck);
	let &[error] = track<string | null>(null);

	const setAnswer = (questionId: string, answerId: string) => {
		if (answerCheck !== null) return;
		answers = answers.map(
			(answer) => (answer.questionId === questionId ? { ...answer, answerId } : answer),
		);
	};

	const submit = () => {
		if (answerCheck !== null) return;
		if (countAnswered(answers) !== questions.length) return;

		const next: AnswerSet = {
			userId,
			answers,
			submittedAt: Date.now(),
		};
		saveAnswerSet(day, next);
		submitted = next;
		error = null;
		screen = { kind: 'booth' };
	};

	const handleAnswerKeyScan = (rawValue: string) => {
		if (answerCheck !== null) {
			error = null;
			screen = { kind: 'result' };
			return;
		}

		try {
			const answerKey = decodeAnswerKey(rawValue);
			validateAnswerKeyForQuestions(answerKey, questions);
			const nextAnswerCheck = {
				answerKey,
				checkedAt: Date.now(),
			};
			saveAnswerCheck(day, nextAnswerCheck);
			answerCheck = nextAnswerCheck;
			error = null;
			screen = { kind: 'result' };
		} catch (scanError) {
			error = scanError instanceof AnswerKeyCodecError
				? t.invalidQrError
				: scanError instanceof Error
					? scanError.message
					: t.invalidQrError;
			screen = { kind: 'booth' };
		}
	};

	<TerminalLayout>
		if (error) {
			<p class="error">{error}</p>
		}

		switch (screen.kind) {
			case 'intro':
				<IntroScreen
					{day}
					total={questions.length}
					answered={countAnswered(answers)}
					{userId}
					hasSubmitted={submitted !== null}
					hasChecked={answerCheck !== null}
					onStart={() => (screen = {
						kind: 'quiz',
						index: firstUnansweredIndex(answers),
					})}
					onShowBoothGuide={() => {
						error = null;
						screen = answerCheck ? { kind: 'result' } : { kind: 'booth' };
					}}
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
			case 'booth':
				const answerSet = submitted;
				if (answerSet) {
					<BoothGuide
						{day}
						total={questions.length}
						answered={countAnswered(answerSet.answers)}
						{userId}
						onStartScan={() => {
							error = null;
							screen = { kind: 'scan-result-qr' };
						}}
						onEdit={() => {
							error = null;
							screen = { kind: 'quiz', index: 0 };
						}}
					/>
				} else {
					<IntroScreen
						{day}
						total={questions.length}
						answered={countAnswered(answers)}
						{userId}
						hasChecked={false}
						hasSubmitted={false}
						onStart={() => (screen = {
							kind: 'quiz',
							index: firstUnansweredIndex(answers),
						})}
						onShowBoothGuide={() => (screen = { kind: 'intro' })}
					/>
				}
				break;
			case 'scan-result-qr':
				<ResultQrScanner
					onScan={handleAnswerKeyScan}
					onError={(message) => (error = message)}
					onCancel={() => {
						error = null;
						screen = { kind: 'booth' };
					}}
				/>
				break;
			case 'result':
				const currentAnswerCheck = answerCheck;
				if (currentAnswerCheck) {
					<AnswerResultScreen
						{questions}
						answers={submitted?.answers ?? answers}
						answerKey={currentAnswerCheck.answerKey}
						checkedAt={currentAnswerCheck.checkedAt}
						{day}
					/>
				} else {
					<BoothGuide
						{day}
						total={questions.length}
						answered={countAnswered(submitted?.answers ?? answers)}
						{userId}
						onStartScan={() => {
							error = null;
							screen = { kind: 'scan-result-qr' };
						}}
						onEdit={() => {
							error = null;
							screen = { kind: 'quiz', index: 0 };
						}}
					/>
				}
				break;
		}
	</TerminalLayout>

	<style>
		.error {
			margin: 0 0 0.75rem;
			padding: 0.65rem;
			border: 1px solid #e06c75;
			background: #2b171a;
			color: #ffb4b4;
			font-size: 0.86rem;
			line-height: 1.5;
		}
	</style>
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

function matchesAnswerKey(answerKey: AnswerKeyEntry[]): boolean {
	try {
		validateAnswerKeyForQuestions(answerKey, questions);
		return true;
	} catch {
		return false;
	}
}

function validateAnswerKeyForQuestions(
	answerKey: AnswerKeyEntry[],
	questionsForDay: PublicQuestion[],
): void {
	const questionsById = new Map(questionsForDay.map((question) => [question.id, question]));
	const answerKeyByQuestionId = new Map(answerKey.map(
		(entry) => [entry.questionId, entry.answerId],
	));

	const unknownEntry = answerKey.find((entry) => !questionsById.has(entry.questionId));
	if (unknownEntry) {
		throw new Error(t.wrongDayQrError);
	}

	const missingQuestion = questionsForDay.find(
		(question) => !answerKeyByQuestionId.has(question.id),
	);
	if (missingQuestion) {
		throw new Error(t.missingQuestionQrError);
	}

	for (const question of questionsForDay) {
		const answerId = answerKeyByQuestionId.get(question.id);
		if (answerId === undefined || !question.choices.some((choice) => choice.id === answerId)) {
			throw new Error(t.unknownChoiceQrError);
		}
	}
}
