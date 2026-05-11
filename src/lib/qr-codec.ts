import * as v from 'valibot';

import type { AnswerEntry, AnswerSet, QrPayload } from './types';

const PREFIX = 'q3';
const USER_ID_PATTERN = /^[0-9A-Za-z]{8}$/;
const SHORT_ID_PATTERN = /^[0-9a-f]{4}$/i;

const shortIdSchema = v.pipe(v.string(), v.regex(SHORT_ID_PATTERN));
export const userIdSchema = v.pipe(v.string(), v.regex(USER_ID_PATTERN));
export const answerEntrySchema = v.object({
	questionId: shortIdSchema,
	answerId: v.nullable(shortIdSchema),
});
export const qrPayloadSchema = v.object({
	v: v.literal(3),
	u: userIdSchema,
	a: v.array(answerEntrySchema),
	t: v.pipe(v.number(), v.integer(), v.minValue(1)),
});

const wireAnswersSchema = v.array(v.tuple([shortIdSchema, v.nullable(shortIdSchema)]));

export class QrCodecError extends Error {
	constructor(message: string) {
		super(message);
		this.name = 'QrCodecError';
	}
}

export function encodeAnswerSet(answerSet: AnswerSet): string {
	return encodeQrPayload({
		v: 3,
		u: answerSet.userId,
		a: answerSet.answers,
		t: Math.floor(answerSet.submittedAt / 1000),
	});
}

export function encodeQrPayload(payload: QrPayload): string {
	const validPayload = validatePayload(payload);

	const encodedAnswers = base64UrlEncodeText(JSON.stringify(toWireAnswers(validPayload.a)));
	return [PREFIX, validPayload.u, encodedAnswers, validPayload.t.toString(36)].join('!');
}

export function decodeQrPayload(value: string): QrPayload {
	const parts = value.trim().split('!');
	if (parts.length !== 4 || parts[0] !== PREFIX) {
		throw new QrCodecError('Unsupported QR payload format.');
	}

	const [, userId, rawAnswers, rawTimestamp] = parts;

	const timestamp = Number.parseInt(rawTimestamp, 36);

	const answers = fromWireAnswers(parseAnswers(rawAnswers));

	return validatePayload({
		v: 3,
		u: userId,
		a: answers,
		t: timestamp,
	});
}

export function countAnswered(answers: AnswerEntry[]): number {
	return answers.filter((answer) => answer.answerId !== null).length;
}

function validatePayload(payload: unknown): QrPayload {
	const result = v.safeParse(qrPayloadSchema, payload);
	if (!result.success) {
		throw new QrCodecError('Invalid QR payload.');
	}
	return result.output;
}

function toWireAnswers(answers: AnswerEntry[]): Array<[string, string | null]> {
	return answers.map((answer) => [answer.questionId, answer.answerId]);
}

function fromWireAnswers(value: unknown): AnswerEntry[] {
	const result = v.safeParse(wireAnswersSchema, value);
	if (!result.success) {
		throw new QrCodecError('Invalid answers in QR payload.');
	}

	return result.output.map(([questionId, answerId]) => {
		return {
			questionId,
			answerId,
		};
	});
}

function parseAnswers(value: string): unknown {
	try {
		return JSON.parse(base64UrlDecodeText(value));
	} catch {
		throw new QrCodecError('Invalid answers in QR payload.');
	}
}

function base64UrlEncodeText(value: string): string {
	const bytes = new TextEncoder().encode(value);
	const binary = Array.from(bytes, (byte) => String.fromCharCode(byte)).join('');
	return btoa(binary).replaceAll('+', '-').replaceAll('/', '_').replace(/=+$/, '');
}

function base64UrlDecodeText(value: string): string {
	if (!/^[0-9A-Za-z_-]*$/.test(value)) {
		throw new QrCodecError('Invalid base64url segment in QR payload.');
	}

	const padded = value
		.replaceAll('-', '+')
		.replaceAll('_', '/')
		.padEnd(Math.ceil(value.length / 4) * 4, '=');
	const binary = atob(padded);
	const bytes = Uint8Array.from(binary, (char) => char.charCodeAt(0));
	return new TextDecoder().decode(bytes);
}
