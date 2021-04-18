package weownthenite;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.SourceElement;
import js.html.URLSearchParams;
import js.html.VideoElement;
import js.lib.Promise;
import Hls.Events.*;

using om.ArrayTools;

final RTMP_HOST = "vvv.disktree.net";
final RTMP_PORT = 1935;
final RTMP_APP = "weownthenite";
final HSL_HOST = "vvv.disktree.net";
final STREAM = "live";

var VIDEOS = weownthenite.Build.getVideoFiles('web/video/1920');

var video : VideoElement;
var index : Int;
var live = true;
var hls : Hls;

function playNextVideo() {
	if( live ) return;
	var i = (index == VIDEOS.length-1) ? 0 : index+1;
	playVideo(i);
}

function playVideo( i : Int ) {
	if( live ) return;
	index = i;
	//video.pause();
	//video.innerHTML = '';
	/*
	function addSource( name : String ) {
		for( type in VIDEO_TYPES ) {
			var source = document.createSourceElement();
			source.src = 'video/$name.$type';
			source.type = 'video/$type';
			video.append( source ); 
		}
		for( i in 0...VIDEO_MEDIA.length ) {
			var source = document.createSourceElement();
			//source.src = 'video/$name'+VIDEO_POSTFIX[i]+'.mp4';
			source.src = 'video/'+VIDEO_PATH[i]+'/'+name+'.mp4';
			source.type = 'video/mp4';
			source.media = VIDEO_MEDIA[i];
			video.append( source ); 
		}
	}
	*/
	var name = VIDEOS[index];
	var size = switch window.innerWidth {
	case v if(v<480): "480";
	case v if(v<960): "960";
	default:  '1920';
	}
	//addSource( name );
	//video.src = 'video/$name.'+VIDEO_TYPES[0];
	//video.src = 'video/${VIDEO_PATH[1]}/$name.mp4';
	video.src = 'video/$size/$name.mp4';
	video.load();
	video.play();
}

function initLivePlayback() : Promise<Dynamic> {
	
	if( !Hls.isSupported() )
		return Promise.reject( "hls not supported" );
	
	return new Promise((resolve,reject)-> {
		var src = 'https://$HSL_HOST/$RTMP_APP/$STREAM.m3u8';
		hls = new Hls();
		hls.on("hlsMediaAttached", () -> {
			trace('video and hls.js bound together');
		});
		hls.on( MANIFEST_PARSED, (event,data) -> {
			trace('manifest loaded, found ' + data.levels.length + ' quality level');
			resolve( null );
		});
		hls.on( ERROR, (e,data) -> {
			trace(e);
			if( data.fatal ) {
				trace("FATAL!");
				hls.destroy();
				reject(e);
				hls = null;
			}
		});
		hls.on( MEDIA_ATTACHED, (e,data) -> {
			trace(e);
			hls.loadSource(src);
		});
		hls.on( DESTROYING, (e,data) -> {
			trace(e);
		});
		hls.attachMedia(video);
	});
}

function initStaticPlayback() {
	VIDEOS.shuffle();
	index = -1;
	video.autoplay = true;
	video.onended = playNextVideo;
	video.onclick = playNextVideo;
}

function main() {
	
	window.addEventListener( 'load', e -> {
		
		console.info( 'WE⸸OWN⸸THE⸸NITE' );
		
		final header = document.body.querySelector('header');
		final footer = document.body.querySelector('footer');
	
		video = cast document.getElementById('video');
		
		window.oncontextmenu = e -> {
			e.preventDefault();
			return false;
		}
		
		var liveLink = document.createAnchorElement();
		liveLink.textContent = 'LIVE';
		liveLink.classList.add( 'live' );
		footer.append( liveLink );
		
		var mailLink = document.createAnchorElement();
		mailLink.textContent = 'MAIL';
		mailLink.href = "mailto:hello@weownthenite.org";
		mailLink.title = "⸸";
		footer.append( mailLink );
		
		initLivePlayback().then( r  -> {
			console.info( 'WE⸸ARE⸸LIVE' );
			live = true;
			document.body.classList.add('live');
			liveLink.href = 'rtmp://$RTMP_HOST:$RTMP_PORT/$RTMP_APP/$STREAM';
			liveLink.title = '';
			video.onended = e -> trace(e);
			video.onclick = e -> {
				video.play();
			}
		}).catchError( e -> {
			
			console.info("No live stream");
			live = false;
			liveLink.classList.add( 'unavailable' );
			liveLink.title = 'BROADCAST OFFLINE';
	
			initStaticPlayback();
		});
	
		window.onkeydown = e -> switch e.key {
			case " ":
				if( !live ) playNextVideo();
			case _:
				trace(e);
		}
	});
}