import type { Messages } from '../i18n';

export const en: Messages = {
	quizPanelAriaLabel: 'Quiz screen',
	introTitle: '10-question TypeScript quiz!',
	introLead:
		'A special edition of the TypeScript quiz made by our tech leads. How many can you get right?',
	statusAriaLabel: 'Answer status',
	startButtonAriaLabel: 'Start quiz',
	resumeButtonAriaLabel: 'Resume from unanswered question',
	choiceLegend: (index) => `Select answer for question ${index + 1}`,
	answerListAriaLabel: 'Answer list',
	unanswered: 'no answer',
	reviewItemLabel: (index, title, answer) =>
		`Question ${index + 1}: ${title}. Current answer: ${answer}. Edit answer`,
	boothTitle: 'Check your results at the booth',
	boothLead:
		'Scan the QR code shown by the staff with this device to check whether your answers are correct.',
	answerResultListAriaLabel: 'Answer results',
	scoreAriaLabel: (correct, total) => `Correct answers: ${correct} / ${total}`,
	resultMeta: (date) => `${date} / Explanations will be published later.`,
	codeExpandHint: 'Tap to expand code',
	codeCollapseHint: 'Tap to collapse code',
	shareLabel: 'Share your result',
	shareCta: 'Add your thoughts and post it on X!',
	sharePostButton: 'Post on X',
	shareCopyButton: 'Copy text',
	shareCopiedButton: 'Copied!',
	shareCopyFailedButton: 'Copy failed',
	buildShareText: (day, correctCount, total, isPerfect) => {
		const hashtags = '#TSKaigi #TSKaigi2026 #zozo_engineer';
		if (correctCount < 5) {
			return [
				'I gave the TypeScript quiz at the ZOZO booth at TSKaigi 2026 a shot!',
				'',
				hashtags,
			].join('\n');
		}
		const score = isPerfect ? `All ${total} correct! 🎉` : `${correctCount} correct! 🙌`;
		return [
			'I took the TypeScript quiz at the ZOZO booth at TSKaigi 2026!',
			`Day ${day} result: ${score}`,
			'',
			hashtags,
		].join('\n');
	},
	cameraStarting: 'Starting camera...',
	qrScanned: 'QR code scanned',
	qrReadFailed: 'Failed to read QR code',
	cameraUnavailable: 'Camera is not available in this browser',
	qrPrompt: 'Hold the staff QR code in front of the camera',
	cameraStartFailed: 'Failed to start camera',
	cameraError: 'Camera error',
	cameraAriaLabel: 'Camera preview for scanning staff QR code',
	invalidQrError: 'Could not read the answer QR. Please scan the QR from the staff screen.',
	wrongDayQrError: "This is not today's answer QR. Please ask the staff to show today's QR.",
	missingQuestionQrError:
		'The answer QR is missing required questions. Please ask the staff to check the QR.',
	unknownChoiceQrError:
		'The answer QR contains an unknown choice. Please ask the staff to check the QR.',
};
