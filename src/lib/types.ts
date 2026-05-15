export type Day = 1 | 2;

export type Category = 'typescript' | 'javascript' | 'runtime';

export interface AnswerChoice {
	id: string;
	text: string;
}

export interface PublicQuestion {
	id: string;
	day: Day;
	category: Category;
	title: string;
	code?: string;
	lang?: 'ts' | 'js';
	choices: AnswerChoice[];
}

export interface AnswerEntry {
	questionId: string;
	answerId: string | null;
}

export interface AnswerSet {
	userId: string;
	answers: AnswerEntry[];
	submittedAt: number;
}

export interface QrPayload {
	v: 3;
	u: string;
	a: AnswerEntry[];
	t: number;
}

export interface AnswerKeyEntry {
	questionId: string;
	answerId: string;
}

export interface AnswerCheck {
	answerKey: AnswerKeyEntry[];
	checkedAt: number;
}

export interface AnswerResultEntry {
	questionId: string;
	selectedAnswerId: string | null;
	correctAnswerId: string;
	status: 'correct' | 'wrong' | 'unanswered';
}
