import type { Category } from './types';

export function categoryLabel(category: Category): string {
	switch (category) {
		case 'typescript':
			return 'TypeScript';
		case 'javascript':
			return 'JavaScript';
		case 'runtime':
			return 'Runtime';
	}
}
