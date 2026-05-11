import { mount } from 'ripple';
import { App } from './App.tsrx';

import '@fontsource-variable/intel-one-mono/wght.css';
import './index.css';

const target = document.getElementById('root');
if (!target) {
	throw new Error('Root element was not found.');
}

mount(App, {
	target,
});
