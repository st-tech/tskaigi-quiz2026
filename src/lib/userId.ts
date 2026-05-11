import * as v from 'valibot';

import { userIdSchema } from './qr-codec';

const STORAGE_KEY = 'tskaigi-quiz2026:user-id';
const ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
const USER_ID_LENGTH = 8;

let fallbackUserId: string | null = null;

export function getOrCreateUserId(): string {
	const stored = loadStoredUserId();
	if (stored) return stored;

	const userId = fallbackUserId ?? createUserId();
	fallbackUserId = userId;
	saveStoredUserId(userId);
	return userId;
}

function loadStoredUserId(): string | null {
	try {
		if (typeof localStorage === 'undefined') return null;
		const stored = localStorage.getItem(STORAGE_KEY);
		const result = v.safeParse(userIdSchema, stored);
		return result.success ? result.output : null;
	} catch {
		return null;
	}
}

function saveStoredUserId(userId: string): void {
	try {
		if (typeof localStorage === 'undefined') return;
		localStorage.setItem(STORAGE_KEY, userId);
	} catch {
		// Persisting the id is optional; fallbackUserId keeps this session stable.
	}
}

function createUserId(): string {
	const bytes = new Uint8Array(USER_ID_LENGTH);
	crypto.getRandomValues(bytes);

	return Array.from(bytes, (byte) => ALPHABET[byte % ALPHABET.length]).join('');
}
