import type { PublicQuestion } from '../lib/types';

export const QUESTIONS = [
	{
		id: 'bebc',
		day: 1,
		category: 'typescript',
		title: '次のコードはエラーになる？(tsconfig strict:true)',
		code: "const a = 1 + '1';",
		lang: 'ts',
		choices: [
			{
				id: '1adf',
				text: '実行時エラー',
			},
			{
				id: '2443',
				text: 'コンパイルエラー',
			},
			{
				id: '8d92',
				text: 'ならない',
			},
		],
	},
	{
		id: 'd3f3',
		day: 2,
		category: 'typescript',
		title: 'X の型は？',
		code: 'type X = 1 extends number ? true : false;',
		lang: 'ts',
		choices: [
			{
				id: 'c832',
				text: 'true',
			},
			{
				id: '4b75',
				text: 'false',
			},
			{
				id: 'c676',
				text: 'boolean',
			},
		],
	},
	{
		id: '610c',
		day: 1,
		category: 'typescript',
		title: 'X の型は？',
		code: 'type X = unknown extends number ? true : false;',
		lang: 'ts',
		choices: [
			{
				id: '30c1',
				text: 'true',
			},
			{
				id: 'e24c',
				text: 'false',
			},
			{
				id: '75ee',
				text: 'boolean',
			},
		],
	},
	{
		id: '5851',
		day: 2,
		category: 'typescript',
		title: 'satisfies の正しい挙動は？',
		code: 'const x = { a: 1, b: 2 } satisfies { a: number };',
		lang: 'ts',
		choices: [
			{
				id: 'd281',
				text: 'x の型は { a: number; b: number }',
			},
			{
				id: 'fd42',
				text: 'x の型は { a: number }',
			},
			{
				id: '61a7',
				text: 'コンパイルエラー',
			},
		],
	},
	{
		id: '849e',
		day: 1,
		category: 'typescript',
		title: 'TypeScript 7 はなんの言語で開発されている？',
		choices: [
			{
				id: '204c',
				text: 'TypeScript',
			},
			{
				id: '2e90',
				text: 'Rust',
			},
			{
				id: '5599',
				text: 'Go',
			},
		],
	},
	{
		id: 'b61b',
		day: 1,
		category: 'javascript',
		title: '次のコードの出力は？',
		code: 'console.log(typeof null);',
		lang: 'js',
		choices: [
			{
				id: 'c280',
				text: '"null"',
			},
			{
				id: 'd775',
				text: '"undefined"',
			},
			{
				id: '89fd',
				text: '"object"',
			},
		],
	},
	{
		id: '5b5c',
		day: 2,
		category: 'javascript',
		title: '次のコードの結果は？',
		code: '"use strict";\nlet str = "zozo";\nstr[0] = "s";\nconsole.log(str);',
		lang: 'js',
		choices: [
			{
				id: '2a74',
				text: '"sozo"',
			},
			{
				id: 'd0b1',
				text: '"zozo"',
			},
			{
				id: 'fe26',
				text: 'Error',
			},
		],
	},
	{
		id: '4940',
		day: 2,
		category: 'javascript',
		title: '次のうち JavaScript (ECMAScript) の予約語は？',
		choices: [
			{
				id: '7a2c',
				text: 'string',
			},
			{
				id: '4164',
				text: 'with',
			},
			{
				id: '5794',
				text: 'using',
			},
		],
	},
	{
		id: '57e0',
		day: 1,
		category: 'runtime',
		title: '次の JavaScript ファイルを実行するとエラーになるのは？',
		code: 'globalThis.alert("Hello, TSKaigi!");\n// node ./index.mjs\n// deno run ./index.mjs\n// bun run ./index.mjs',
		lang: 'js',
		choices: [
			{
				id: '6bce',
				text: 'Node.js',
			},
			{
				id: '6560',
				text: 'Deno',
			},
			{
				id: '6593',
				text: 'Bun',
			},
		],
	},
	{
		id: 'e20e',
		day: 1,
		category: 'runtime',
		title: '次の JavaScript ファイルを実行するとエラーになるのは？',
		code: 'const obj = {};\nobj.__proto__.a = 1;\nconsole.log(obj.a);\n// node ./index.mjs\n// deno run ./index.mjs\n// bun run ./index.mjs',
		lang: 'js',
		choices: [
			{
				id: '1e11',
				text: 'Node.js',
			},
			{
				id: '302f',
				text: 'Deno',
			},
			{
				id: '9dd7',
				text: 'Bun',
			},
		],
	},
	{
		id: '3867',
		day: 2,
		category: 'typescript',
		title: 'TypeScript 7 (tsgo) の開発コードネームは？',
		choices: [
			{
				id: 'da8b',
				text: 'Breeze',
			},
			{
				id: 'c2ee',
				text: 'Corsa',
			},
			{
				id: 'bac7',
				text: 'Strada',
			},
		],
	},
	{
		id: '2ff0',
		day: 1,
		category: 'typescript',
		title: 'enum を TypeScript コンパイラに渡すとどのような JavaScript コードが出力される？',
		code: 'enum Hoge {\n\ta, b\n}\nconst a: Hoge = Hoge.a;',
		lang: 'ts',
		choices: [
			{
				id: 'e643',
				text: 'IIFE で Hoge オブジェクトを構築する形に展開される',
			},
			{
				id: '3594',
				text: 'const enum と同等にインライン定数へ展開される',
			},
		],
	},
	{
		id: '664e',
		day: 1,
		category: 'typescript',
		title: 'erasableSyntaxOnly でエラーになるのは？',
		code: 'class Hoge {\n  private a?: number // A\n  private b() {} // B\n  constructor(private c: number) {} // C\n}',
		lang: 'ts',
		choices: [
			{
				id: '3142',
				text: 'A',
			},
			{
				id: '947d',
				text: 'B',
			},
			{
				id: '9a3b',
				text: 'C',
			},
		],
	},
	{
		id: 'd383',
		day: 2,
		category: 'typescript',
		title: '返り値の型が void で推論されるのは？',
		code: "const A = () => { throw 'Oops'; };\nfunction B() { throw 'Oops'; }\nconst C = function () { throw 'Oops'; };",
		lang: 'ts',
		choices: [
			{
				id: '5559',
				text: 'A',
			},
			{
				id: '3b1f',
				text: 'B',
			},
			{
				id: '4038',
				text: 'C',
			},
		],
	},
	{
		id: '8d76',
		day: 2,
		category: 'javascript',
		title: '次の式の結果は？',
		code: '(NaN == NaN) === (NaN === NaN)',
		lang: 'js',
		choices: [
			{
				id: '1f85',
				text: 'true',
			},
			{
				id: 'bc76',
				text: 'false',
			},
			{
				id: '45bb',
				text: 'Error',
			},
		],
	},
	{
		id: '1149',
		day: 1,
		category: 'javascript',
		title: '次の式の結果は？',
		code: 'JSON.stringify({ nan: NaN })',
		lang: 'js',
		choices: [
			{
				id: '6e63',
				text: '{"nan":NaN}',
			},
			{
				id: '8df9',
				text: '{"nan":null}',
			},
			{
				id: '523a',
				text: 'Error',
			},
		],
	},
	{
		id: '1baf',
		day: 2,
		category: 'runtime',
		title: '次の TypeScript ファイルを実行するとエラーになるのは？',
		code: 'const enum Hoge { a, b }\nconsole.log(Hoge.a);\n// node ./index.mts\n// deno run ./index.mts\n// bun run ./index.mts',
		lang: 'ts',
		choices: [
			{
				id: '3c1a',
				text: 'Node.js',
			},
			{
				id: '7d8f',
				text: 'Deno',
			},
			{
				id: '0061',
				text: 'Bun',
			},
		],
	},
	{
		id: 'a999',
		day: 2,
		category: 'runtime',
		title: 'globalThis.navigator.share() メソッドが使えるのは？',
		choices: [
			{
				id: '5c54',
				text: 'iOS WebView',
			},
			{
				id: 'a9b4',
				text: 'Android WebView',
			},
			{
				id: '70b0',
				text: 'Deno',
			},
		],
	},
	{
		id: '40d5',
		day: 1,
		category: 'runtime',
		title: 'URL クラスはどの組織・仕様グループで標準化されている？',
		choices: [
			{
				id: '8f57',
				text: 'WHATWG',
			},
			{
				id: '4aa3',
				text: 'ECMA-262',
			},
			{
				id: 'f13c',
				text: 'W3C',
			},
		],
	},
	{
		id: '2fa8',
		day: 2,
		category: 'runtime',
		title: 'fetch API はどの組織・仕様グループで標準化されている？',
		choices: [
			{
				id: '82a2',
				text: 'WHATWG',
			},
			{
				id: 'e635',
				text: 'ECMA-262',
			},
			{
				id: '4229',
				text: 'W3C',
			},
		],
	},
] satisfies PublicQuestion[];

export function getQuestionsForDay(day: 1 | 2, limit = 10): PublicQuestion[] {
	return QUESTIONS.filter((question) => question.day === day).slice(0, limit);
}
