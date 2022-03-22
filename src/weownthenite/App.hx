package weownthenite;

import js.html.AnchorElement;
import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.SourceElement;
import js.html.URLSearchParams;
import js.html.VideoElement;
import js.lib.Promise;
import Hls.Events.*;

using om.ArrayTools;

class App {
	static inline var STREAM = "live";

	static inline var RTMP_HOST = "vvv.disktree.net";
	static inline var RTMP_PORT = 1935;
	static inline var RTMP_APP = "weownthenite";
	static final RTMP_URL = 'rtmp://$RTMP_HOST:$RTMP_PORT/$RTMP_APP/$STREAM';

	static inline var HSL_HOST = "vvv.disktree.net";
	static final HSL_PLAYLIST_URL = 'https://$HSL_HOST/$RTMP_APP/$STREAM.m3u8';

	static var player:VideoPlayer;

	static function playLive(url:String):Promise<Bool> {
		return player.playLive(url).then(live -> {
			if (live) {
				var liveLink:AnchorElement = cast document.body.querySelector('nav a.live');
				liveLink.href = RTMP_URL;
				document.body.querySelector('header').style.display = 'none';
				return Promise.resolve(true);
			} else {
				return Promise.resolve(false);
			}
		});
	}

	static function main() {
		console.log('%cWE⸸OWN⸸THE⸸NITE⁶⁶', 'color:#fff;background:#000;padding:1rem 2rem;');

		window.addEventListener('load', e -> {
			player = new VideoPlayer(cast document.getElementById("video"));

			var playlistUrl = 'https://$HSL_HOST/$RTMP_APP/$STREAM.m3u8';
			var isFallback = true;

			window.onwheel = e -> {
				/*
					console.debug(e);
					if( e.deltaY > 0 ) {
						var v = video.volume - 0.1; 
						if( v < 0 ) v = 0;
						//video.volume = v; 
					} else {
						var v = video.volume + 0.1; 
						if( v > 1.0 ) v = 1;
						//video.volume = v; 
					}
				 */
			}

			document.body.onclick = e -> {
				// temp disable since there is no live stream server atm
				/*
					if (isFallback) {
						player.playNextFallback();
						return;
					}
					if (player.live) {
						return;
					}
					playLive(playlistUrl).then(live -> {
						if (!live) {
							isFallback = true;
							player.playFallback();
						}
					});
				 */
				player.playFallback();
			}

			document.body.ondblclick = e -> {
				document.documentElement.requestFullscreen();
				if (document.fullscreenElement == null) {
					document.documentElement.requestFullscreen();
				} else {
					document.exitFullscreen();
				}
			}

			window.onkeydown = e -> {
				switch e.key {
					case " ":
					// if( !live ) playNextVideo();
					// case _:
					// 	trace(e);
					case 'p':
					default:
						playLive(playlistUrl);
				}
			}

			window.oncontextmenu = e -> {
				e.preventDefault();
				return false;
			}

			// var cursor = document.getElementById('cursor');
			// window.onmousemove = e -> {
			// cursor.style.left = e.clientX + 'px';
			// cursor.style.top = e.clientY + 'px';
			// }
		});
	}
}
