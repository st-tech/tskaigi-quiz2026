import * as v from 'valibot';

import type { AnswerKeyEntry } from './types';

const SHORT_ID_PATTERN = /^[0-9a-f]{4}$/i;

const shortIdSchema = v.pipe(v.string(), v.regex(SHORT_ID_PATTERN));
export const answerKeyEntrySchema = v.object({
	questionId: shortIdSchema,
	answerId: shortIdSchema,
});
const answerKeySchema = v.pipe(v.array(answerKeyEntrySchema), v.minLength(1));

export class AnswerKeyCodecError extends Error {
	constructor(message: string) {
		super(message);
		this.name = 'AnswerKeyCodecError';
	}
}

export function encodeAnswerKey(entries: AnswerKeyEntry[]): string {
	const validEntries = validateAnswerKey(entries);
	return validEntries.map((entry) => `${entry.questionId}:${entry.answerId};`).join('');
}

export function decodeAnswerKey(value: string): AnswerKeyEntry[] {
	const trimmed = value.trim();
	if (trimmed.length === 0) {
		throw new AnswerKeyCodecError('Empty answer key QR payload.');
	}

	const segments = trimmed.split(';');
	if (segments.at(-1) === '') {
		segments.pop();
	}

	if (segments.length === 0) {
		throw new AnswerKeyCodecError('Empty answer key QR payload.');
	}

	const entries = segments.map((segment) => {
		const parts = segment.split(':');
		if (parts.length !== 2) {
			throw new AnswerKeyCodecError('Invalid answer key QR payload.');
		}

		return {
			questionId: parts[0],
			answerId: parts[1],
		};
	});

	return validateAnswerKey(entries);
}

function validateAnswerKey(entries: AnswerKeyEntry[]): AnswerKeyEntry[] {
	const result = v.safeParse(answerKeySchema, entries);
	if (!result.success) {
		throw new AnswerKeyCodecError('Invalid answer key QR payload.');
	}

	const questionIds = new Set<string>();
	for (const entry of result.output) {
		if (questionIds.has(entry.questionId)) {
			throw new AnswerKeyCodecError('Duplicate question id in answer key QR payload.');
		}
		questionIds.add(entry.questionId);
	}

	return result.output;
}
