package weownthenite;

import js.html.AnchorElement;
import js.html.Notification;
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

	static var player : VideoPlayer;

	static function main() {
		
		window.addEventListener( 'load', e -> {
			
			player = new VideoPlayer( cast document.getElementById("video") );
			
			var liveLink : AnchorElement = cast document.body.querySelector('nav a.live');
			
			var playlistUrl = 'https://$HSL_HOST/$RTMP_APP/$STREAM.m3u8';
			player.playLive( playlistUrl ).then( live -> {
				if( live ) {
					liveLink.href = RTMP_URL;
				}
			});
		
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

			window.onkeydown = e -> switch e.key {
				case " ":
					//if( !live ) playNextVideo();
				case _:
					trace(e);
			}

			window.oncontextmenu = e -> {
				e.preventDefault();
				return false;
			}
		});
	}
}