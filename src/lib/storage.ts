import * as v from 'valibot';

import { answerEntrySchema, userIdSchema } from './qr-codec';
import type { AnswerEntry, AnswerSet, Day } from './types';

const STORAGE_PREFIX = 'tskaigi-quiz2026:answers:';
const answerSetSchema = v.object({
	userId: userIdSchema,
	answers: v.array(answerEntrySchema),
	submittedAt: v.pipe(v.number(), v.integer(), v.minValue(1)),
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

function keyFor(day: Day): string {
	return STORAGE_PREFIX + day;
}
