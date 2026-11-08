'use strict';
import { stat } from 'fs';

// e5-infoscreen-lvgl's install leaves its program and its switch-ui script here.
const DIR = '/usr/libexec/e5-infoscreen';

return function(ctx) {
	function installed() {
		return stat(`${DIR}/ui`) != null && stat(`${DIR}/switch-ui`) != null;
	}

	return {
		'GET /status': function() {
			return { installed: installed() };
		},
		// The switch restarts the screen's service, this request's server with it:
		// it waits a moment for the reply to leave.
		'POST /switch': function() {
			ctx.run(`setsid sh -c 'sleep 1; ${DIR}/switch-ui lvgl' >/dev/null 2>&1 &`);
			return { ok: true };
		}
	};
};
