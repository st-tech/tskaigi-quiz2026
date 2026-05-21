import type { PropsWithChildren } from 'ripple';

export component TerminalLayout(&{ children }: PropsWithChildren<{}>) {
	<div class="shell">
		<header class="topbar">
			<p>{'Welcome to ZOZO booth @TSKaigi 2026 !!'}</p>
			<h1>{'TypeScript Quiz'}</h1>
		</header>
		<main class="panel" aria-label="クイズ画面">{children}</main>
	</div>

	<style>
		.shell {
			min-height: 100vh;
			background: #0b0f14;
			color: #d8e2ea;
			padding: 0.85rem;
			box-sizing: border-box;
		}

		.topbar {
			max-width: 760px;
			margin: 0 auto 0.75rem;
			padding: 0.25rem 0;
		}

		.topbar p {
			margin: 0 0 0.15rem;
			color: #8bd49c;
			font-size: 0.74rem;
		}

		h1 {
			margin: 0;
			font-size: 1.45rem;
			line-height: 1.1;
			color: #f3f7f0;
		}

		.panel {
			max-width: 760px;
			margin: 0 auto;
			border: 1px solid #34404d;
			background: #11161d;
			padding: 0.85rem;
			box-sizing: border-box;
		}
	</style>
}
