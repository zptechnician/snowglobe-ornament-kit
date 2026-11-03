#!/usr/bin/env bash
# Encode a video for the 2.7" memory sphere lamp (480x480 round panel).
# Usage: ./encode-sphere.sh input.mp4 output.mp4 [mask.png]
set -euo pipefail
IN="${1:?input file required}"
OUT="${2:?output file required}"
MASK="${3:-mask.png}"

ffmpeg -y -i "$IN" -loop 1 -i "$MASK" -filter_complex \
"[0:v]scale=480:480:force_original_aspect_ratio=increase,crop=480:480,fps=30,format=rgba[src];\
[1:v]format=gray,scale=480:480[msk];\
[src][msk]alphamerge,format=rgba[fg];\
color=c=black:s=480x480:r=30[bg];\
[bg][fg]overlay=0:0:shortest=1,format=yuv420p[out]" \
-map "[out]" -an -frames:v 300 -c:v libx264 -profile:v baseline -level:v 3.1 \
-bf 0 -b:v 2800k -maxrate 3000k -bufsize 2800k -r 30 -movflags +faststart "$OUT"

ffprobe -v error -select_streams v:0 \
  -show_entries stream=profile,level,width,height,avg_frame_rate,has_b_frames,bit_rate \
  -of default=noprint_wrappers=1 "$OUT"
