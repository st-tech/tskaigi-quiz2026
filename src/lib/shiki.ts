import { createHighlighterCore } from 'shiki/core';
import type { HighlighterCore } from 'shiki/core';

type CodeLang = 'ts' | 'js';

let highlighterPromise: Promise<HighlighterCore> | undefined;

export async function highlightCode(code: string, lang: CodeLang): Promise<string> {
	const highlighter = await getHighlighter();

	return highlighter.codeToHtml(code, {
		lang,
		theme: 'vitesse-dark',
	});
}

function getHighlighter(): Promise<HighlighterCore> {
	highlighterPromise ??= createHighlighterCore({
		themes: [import('@shikijs/themes/vitesse-dark')],
		langs: [import('@shikijs/langs/javascript'), import('@shikijs/langs/typescript')],
		engine: import('shiki/engine/javascript').then(({ createJavaScriptRegexEngine }) =>
			createJavaScriptRegexEngine()
		),
	});

	return highlighterPromise;
}
