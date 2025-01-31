import { useCallback, useEffect, useRef, useState } from 'react';

type VideoPlayerProps = {
  videoResolution: number
  videoPlaylist: string[]
}

export default function VideoPlayer(props: VideoPlayerProps) {

  const { videoResolution, videoPlaylist } = props;
  const [videoIndex, setVideoIndex] = useState(0);
  const videoRef = useRef<HTMLVideoElement>(null)
  const videoPreloadRef = useRef<HTMLVideoElement>(null)

  const getNextVideoIndex = useCallback((currentIndex: number = videoIndex) =>
    (currentIndex + 1) % videoPlaylist.length
    , [videoIndex, videoPlaylist])

  const getVideoUrl = useCallback((index: number): string => {
    let res = videoResolution;
    if (window.innerWidth < 480) res = 480;
    else if (window.innerWidth < 960) res = 960;
    return `video/${res}/${videoPlaylist[index]}`
  }, [videoResolution, videoPlaylist])

  const playNext = useCallback(() => {
    const nextIndex = getNextVideoIndex();
    setVideoIndex(nextIndex)
    if (videoRef.current !== null) {
      videoRef.current.muted = false;
      videoRef.current.src = getVideoUrl(nextIndex);
    }
    if (videoPreloadRef.current)
      videoPreloadRef.current.src = getVideoUrl(getNextVideoIndex(nextIndex));
  }, [getNextVideoIndex, getVideoUrl])

  useEffect(() => {
    const handleVideoEnd = () => playNext()
    const handleMouseDown = () => playNext()
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.code === "Space" || e.code === "Enter") playNext()
    }
    const videoElement = videoRef.current;
    if (videoElement) {
      videoElement.addEventListener('ended', handleVideoEnd)
    }
    document.body.oncontextmenu = e => e.preventDefault()
    document.body.addEventListener("click", handleMouseDown)
    window.addEventListener("keypress", handleKeyDown)
    return () => {
      if (videoElement)
        videoElement.removeEventListener("ended", handleVideoEnd)
      document.body.oncontextmenu = null;
      document.body.removeEventListener("click", handleMouseDown)
      window.removeEventListener("keypress", handleKeyDown)
    }
  }, [playNext])

  return (
    <div>
      <video id="video-player" autoPlay muted ref={videoRef}></video>
      <video id="video-preload" autoPlay muted ref={videoPreloadRef}></video>
    </div>
  )
}

