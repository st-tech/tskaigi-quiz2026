import { en } from './locales/en';
import { ja } from './locales/ja';

export type Locale = 'ja' | 'en';

export interface Messages {
	// TerminalLayout
	quizPanelAriaLabel: string;
	// IntroScreen
	introTitle: string;
	introLead: string;
	statusAriaLabel: string;
	startButtonAriaLabel: string;
	resumeButtonAriaLabel: string;
	// QuestionScreen
	choiceLegend: (index: number) => string;
	// ReviewScreen
	answerListAriaLabel: string;
	unanswered: string;
	reviewItemLabel: (index: number, title: string, answer: string) => string;
	// BoothGuide
	boothTitle: string;
	boothLead: string;
	// AnswerResultScreen
	answerResultListAriaLabel: string;
	scoreAriaLabel: (correct: number, total: number) => string;
	resultMeta: (date: string) => string;
	codeExpandHint: string;
	codeCollapseHint: string;
	shareLabel: string;
	buildShareText: (day: number, correctCount: number, total: number, isPerfect: boolean) => string;
	// ResultQrScanner
	cameraStarting: string;
	qrScanned: string;
	qrReadFailed: string;
	cameraUnavailable: string;
	qrPrompt: string;
	cameraStartFailed: string;
	cameraError: string;
	cameraAriaLabel: string;
	// App error messages
	invalidQrError: string;
	wrongDayQrError: string;
	missingQuestionQrError: string;
	unknownChoiceQrError: string;
}

function detectLocale(): Locale {
	const lang = navigator.languages?.[0] ?? navigator.language ?? '';
	return lang.startsWith('ja') ? 'ja' : 'en';
}

export const locale: Locale = detectLocale();
export const t: Messages = locale === 'ja' ? ja : en;

export function formatDate(value: number): string {
	return new Intl.DateTimeFormat(locale === 'ja' ? 'ja-JP' : 'en-US', {
		month: '2-digit',
		day: '2-digit',
		hour: '2-digit',
		minute: '2-digit',
	}).format(value);
}
