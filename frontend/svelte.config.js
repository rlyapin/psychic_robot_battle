// https://kit.svelte.dev/docs/adapters#supported-environments-node-js
import adapter from '@sveltejs/adapter-node';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		adapter: adapter({ out: 'build' })
	}
};

export default config;
