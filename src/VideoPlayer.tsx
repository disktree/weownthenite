import Hls from 'hls.js';
import { useCallback, useEffect, useRef, useState } from 'react';

type VideoPlayerProps = {
  liveUrl: string;
  resolution: number
  playlist: string[]
}

export default function VideoPlayer(props: VideoPlayerProps) {

  const { liveUrl, resolution, playlist } = props;

  const videoRef = useRef<HTMLVideoElement>(null)
  const videoPreloadRef = useRef<HTMLVideoElement>(null)
  const liveStatusRef = useRef<HTMLAnchorElement>(null)

  const [liveMode, setLiveMode] = useState(true);
  const [liveStatus, setLiveStatus] = useState("off");
  const [playlistIndexdex, setPlaylistIndex] = useState(0);

  const getNextVideoIndex = useCallback((currentIndex: number = playlistIndexdex) =>
    (currentIndex + 1) % playlist.length
    , [playlistIndexdex, playlist])

  const getVideoUrl = useCallback((index: number): string => {
    let res = resolution;
    if (window.innerWidth < 480) res = 480;
    else if (window.innerWidth < 960) res = 960;
    return `video/${res}/${playlist[index]}`
  }, [resolution, playlist])

  const playNext = useCallback(() => {
    const nextIndex = getNextVideoIndex();
    setPlaylistIndex(nextIndex)
    if (videoRef.current !== null) {
      videoRef.current.muted = false;
      videoRef.current.src = getVideoUrl(nextIndex);
    }
    if (videoPreloadRef.current)
      videoPreloadRef.current.src = getVideoUrl(getNextVideoIndex(nextIndex));
  }, [getNextVideoIndex, getVideoUrl])

  useEffect(() => {
    const handleVideoEnd = () => playNext()
    const handleMouseDown = () => {
      if (liveMode && liveStatus === "off") {
        setLiveStatus("connecting")
        const hls = new Hls()
        hls.attachMedia(videoRef.current as HTMLMediaElement)
        hls.loadSource(liveUrl);
        hls.on(Hls.Events.ERROR, () => {
          liveStatusRef.current?.setAttribute("href", "")
          setLiveStatus("off")
          setLiveMode(false)
          playNext()
        })
      } else {
        playNext()
      }
    }
    const handleKeyDown = (e: KeyboardEvent) => {
      if (liveMode && e.code === "Space" || e.code === "Enter") playNext()
    }
    const videoElement = videoRef.current;
    if (videoElement) {
      videoElement.onended = handleVideoEnd
      videoElement.onplay = () => {
        if (liveMode) {
          setLiveStatus("live")
          liveStatusRef.current?.setAttribute("href", liveUrl)
        }
      }
      videoElement.onended = e => {
        console.log(e)
        playNext()
      }
    }

    document.body.oncontextmenu = e => e.preventDefault()
    document.body.addEventListener("click", handleMouseDown)
    window.addEventListener("keypress", handleKeyDown)
    return () => {
      videoElement?.removeEventListener("ended", handleVideoEnd)
      document.body.oncontextmenu = null;
      document.body.removeEventListener("click", handleMouseDown)
      window.removeEventListener("keypress", handleKeyDown)
    }
  }, [playNext, liveMode, liveUrl, liveStatusRef, liveStatus])

  return (
    <>
      <video id="video-player" autoPlay muted ref={videoRef}></video>
      <video id="video-preload" autoPlay muted ref={videoPreloadRef}></video>
      <a id="live-status" className={liveStatus} ref={liveStatusRef}>{liveStatus}</a>
    </>
  )
}
