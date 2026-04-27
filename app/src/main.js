import App from './App.svelte';
import QRCode from 'qrcode';

const app = new App({
	target: document.body,
	props: {
		code: QRCode
	}
});

export default app;
