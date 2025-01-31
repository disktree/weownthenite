import { shuffleArray } from './utils';
import VideoPlayer from './VideoPlayer';

// const rtmp = {
//   host: "rrr.disktree.net",
//   port: 1935,
//   app: "weownthenite"
// }

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

export default function App() {
  return <VideoPlayer
    videoResolution={1920}
    videoPlaylist={shuffleArray(PLAYLIST)}
  />
}

