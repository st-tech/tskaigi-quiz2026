import { effect, track } from 'ripple';

import { highlightCode } from '../lib/shiki';

type CodeLang = 'ts' | 'js';
type CodeBlockProps = { code: string; lang: CodeLang };

export component CodeBlock(&{ code, lang }: CodeBlockProps) {
	let &[content] = track(fallbackCodeBlock(code));
	let root = track<HTMLDivElement | null>(null);

	effect(() => {
		content = fallbackCodeBlock(code);

		let canceled = false;
		void highlightCode(code, lang).then((html) => {
			if (!canceled) content = html;
		});

		return () => {
			canceled = true;
		};
	});

	effect(() => {
		if (root.value && root.value.innerHTML !== content) {
			root.value.innerHTML = content;
		}
	});

	<div class="code-block" role="region" aria-label={codeLabel(lang)} {ref root} />

	<style>
		.code-block {
			margin: 0.75rem 0;
			overflow-x: auto;
			border: 1px solid #2f3945;
			background: #121820;
		}

		.code-block :global(.shiki) {
			margin: 0;
			padding: 0.85rem;
			background: #121820 !important;
			font-size: 0.83rem;
			line-height: 1.55;
		}
	</style>
}

function fallbackCodeBlock(code: string): string {
	return `<pre class="shiki fallback"><code>${escapeHtml(code)}</code></pre>`;
}

function escapeHtml(value: string): string {
	return value.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll(
		'"',
		'&quot;',
	).replaceAll('\'', '&#039;');
}

function codeLabel(lang: 'ts' | 'js'): string {
	return lang === 'ts' ? 'TypeScript コード例' : 'JavaScript コード例';
}
