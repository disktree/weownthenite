package weownthenite;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.VideoElement;
import js.lib.Promise;
import Hls.Events.*;

using om.ArrayTools;

class VideoPlayer {

    static var VIDEOS = weownthenite.Build.getVideoFiles('web/video/1920');

    public final video : VideoElement;

    public var live(default,null) : Bool;

    var index = 0;

    public function new( video : VideoElement ) {
        this.video = video;
    }

    public function playFallback() {
        live = false;
        VIDEOS.shuffle();
        /* function playNextVideo() {
            index = (index == VIDEOS.length-1) ? 0 : index+1;
	        var name = VIDEOS[index];
            trace(index,name);
            var size = switch window.innerWidth {
                case v if(v<480): "480";
                case v if(v<960): "960";
                default:  '1920';
            }
            video.src = 'video/$size/$name.mp4';
            video.load();
            video.play();
        } */
        video.autoplay = true;
        video.onended = playNextFallback;
        video.onclick = playNextFallback;
    }

    public function playNextFallback() {
        index = (index == VIDEOS.length-1) ? 0 : index+1;
        var name = VIDEOS[index];
        trace(index,name);
        var size = switch window.innerWidth {
            case v if(v<480): "480";
            case v if(v<960): "960";
            default:  '1920';
        }
        video.src = 'video/$size/$name.mp4';
        video.load();
        video.play();
    }

    // public function playVideo( url : String ) {

    public function playLive( url : String ) : Promise<Bool> {
        return window.fetch( url ).then( res -> {
            trace(res);
            if( res.status == 200 ) {
                _playLive( url );
                return true;
            } else {
                playFallback();
                return false;
            }
        }).catchError( e -> {
            trace(e);
            return false;
        });
    }

    function _playLive( url : String ) {
        live = true;
        if( video.canPlayType('application/vnd.apple.mpegurl') != "" ) {
            video.src = url;
        } else {
            var hls = new Hls();
            hls.on( MANIFEST_PARSED, (event,data) -> {
                trace('manifest loaded, found ' + data.levels.length + ' quality level');
                hls.attachMedia(video);
                //video.onclick = video.play;
                video.play();
            });
            //hls.on( FRAG_BUFFERED, (e) -> trace(e) );
            //hls.on( FRAG_LOADING, (e) -> trace(e) );
            //hls.on( FRAG_LOADED, (e) -> trace(e) );
            hls.on( ERROR, (e,d) -> {
                trace(e);
                /*
                live = false;
                hls.destroy();
                video.autoplay = true;
                //video.preload = "all";
                video.onclick = playNextVideo;
                video.onended = playNextVideo;
                ///playNextVideo(); */
            });
            hls.loadSource( url );
        }
    }

}