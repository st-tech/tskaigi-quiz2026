import { defineConfig } from 'vite';
import { ripple } from '@ripple-ts/vite-plugin';

export default defineConfig({
	base: '/tskaigi-quiz2026/',
	plugins: [ripple()],
	server: {
		port: 3001,
	},
	optimizeDeps: {
		include: ['qrcode'],
	},
	build: {
		target: 'esnext',
	},
});
