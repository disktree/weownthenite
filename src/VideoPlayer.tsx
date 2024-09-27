import { useEffect, useRef, useState } from 'react'
import { shuffleArray } from './utils'

const VIDEO_RES = 1920;

const PLAYLIST = [
  "bikeball-15.mp4",
  "cant.mp4",
  "haarp-2.mp4",
  "harga.mp4",
  "maybetomorrow.mp4",
  "nottoday-4.mp4",
  "nottoday.mp4",
  "panzerpalme.mp4",
  "panzerschokolade-12.mp4",
  "panzerschokolade-19.mp4",
  "panzerschokolade-20.2.mp4",
  "panzerschokolade-20.3.mp4",
  "panzerschokolade-20.4.mp4",
  "panzerschokolade-20.5.mp4",
  "panzerschokolade-20.6.mp4",
  "panzerschokolade-20.7.mp4",
  "panzerschokolade-20.mp4",
  "panzerschokolade-4.mp4",
  "panzerschokolade-5.mp4",
  "panzerschokolade-tropicana-1.mp4",
  "panzerschokolade-tropicana-2.mp4",
  "panzerschokolade-tropicana-3.mp4",
  "sierpinski.mp4",
  "tekktonic.mp4",
  "wkr-1.mp4",
];

// TODO: hls live streaming

export default function VideoPlayer() {

  const [videoIndex, setVideoIndex] = useState(0);
  const [playlist, _setPlaylist] = useState(() => shuffleArray(PLAYLIST));
  const videoRef = useRef<HTMLVideoElement>(null)
  const videoPreloadRef = useRef<HTMLVideoElement>(null)
  //let videoRes = 1920;

  function getNextVideoIndex(currentIndex?: number) {
    if (currentIndex === undefined) currentIndex = videoIndex;
    let id = currentIndex + 1;
    if (id == PLAYLIST.length) id = 0;
    return id
  }

  function getVideoUrl(index: number): string {
    let res = VIDEO_RES;
    if (window.innerWidth < 480) res = 480;
    else if (window.innerWidth < 960) res = 960;
    return `video/${res}/${playlist[index]}`
  }

  function playNext() {
    const nextIndex = getNextVideoIndex();
    setVideoIndex(nextIndex)
    if (videoRef.current !== null) {
      videoRef.current.muted = false;
      videoRef.current.src = getVideoUrl(nextIndex);
    }
    if (videoPreloadRef.current !== null) {
      const i = getNextVideoIndex(nextIndex);
      videoPreloadRef.current.src = getVideoUrl(i);
    }
  }

  function handleVideoEnd() {
    //console.log('video ended')
    playNext();
  }

  function handleMouseDown() {
    playNext()
  }

  function handleKeyDown(e: KeyboardEvent) {
    switch (e.code) {
      case "Space":
      case "Enter":
        playNext()
    }
  }

  useEffect(() => {
    if (videoRef.current !== null) {
      videoRef.current.addEventListener("ended", handleVideoEnd);
    }
    document.body.oncontextmenu = e => { e.preventDefault() }
    document.body.addEventListener("click", handleMouseDown, false)
    window.addEventListener('keypress', handleKeyDown, false);
    const vref = videoRef.current;
    return () => {
      if (vref !== null) {
        vref.removeEventListener("ended", handleVideoEnd);
      }
      document.body.oncontextmenu = null;
      document.body.removeEventListener("click", handleMouseDown, false)
      window.removeEventListener('keypress', handleKeyDown);
    }
  })

  return (
    <div>
      <video id="video-player" autoPlay muted ref={videoRef}></video>
      <video id="video-preload" autoPlay muted ref={videoPreloadRef}></video>
    </div>
  )
}

