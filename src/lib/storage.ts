import * as v from 'valibot';

import { answerKeyEntrySchema } from './answer-key-codec';
import { answerEntrySchema, userIdSchema } from './qr-codec';
import type { AnswerCheck, AnswerEntry, AnswerSet, Day } from './types';

const STORAGE_PREFIX = 'tskaigi-quiz2026:answers:';
const CHECK_STORAGE_PREFIX = 'tskaigi-quiz2026:answer-check:';
const timestampSchema = v.pipe(v.number(), v.integer(), v.minValue(1));
const answerSetSchema = v.object({
	userId: userIdSchema,
	answers: v.array(answerEntrySchema),
	submittedAt: timestampSchema,
});
const answerCheckSchema = v.object({
	answerKey: v.array(answerKeyEntrySchema),
	checkedAt: timestampSchema,
});

export function loadAnswerSet(day: Day): AnswerSet | null {
	try {
		if (typeof localStorage === 'undefined') return null;
		const raw = localStorage.getItem(keyFor(day));
		if (!raw) return null;
		const parsed = JSON.parse(raw);
		const result = v.safeParse(answerSetSchema, parsed);
		return result.success ? result.output : null;
	} catch {
		return null;
	}
}

export function saveAnswerSet(day: Day, answerSet: AnswerSet): void {
	try {
		if (typeof localStorage === 'undefined') return;
		localStorage.setItem(keyFor(day), JSON.stringify(answerSet));
	} catch {
		// Persisting answers is optional; the submitted QR stays available in memory.
	}
}

export function loadAnswerCheck(day: Day): AnswerCheck | null {
	try {
		if (typeof localStorage === 'undefined') return null;
		const raw = localStorage.getItem(checkKeyFor(day));
		if (!raw) return null;
		const parsed = JSON.parse(raw);
		const result = v.safeParse(answerCheckSchema, parsed);
		return result.success ? result.output : null;
	} catch {
		return null;
	}
}

export function saveAnswerCheck(day: Day, answerCheck: AnswerCheck): void {
	try {
		if (typeof localStorage === 'undefined') return;
		localStorage.setItem(checkKeyFor(day), JSON.stringify(answerCheck));
	} catch {
		// Persisting a check result is optional; the in-memory result is still shown.
	}
}

function keyFor(day: Day): string {
	return STORAGE_PREFIX + day;
}

function checkKeyFor(day: Day): string {
	return CHECK_STORAGE_PREFIX + day;
}
