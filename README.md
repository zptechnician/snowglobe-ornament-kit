# snowglob-ornament-kit

Content kit for the 2.7" Christmas Memory Sphere Lamp — the glass ball with a
round 480×480 LCD inside (Etsy listing NMK1, USB model). Everything needed to
make videos that actually play on it, get them onto it, and re-do it later
without re-deriving the recipe.

## The device

- 2.7" / 7 cm glass sphere, round **480×480** display
- 4 GB internal storage, 800 mAh battery (~2–4 h playback)
- Controls: one center button + control dial. **Hold the center button ~3 s**
  for power. Dial switches files; on this dial-control family, short presses
  step prev/next and long presses ride the volume.
- Transfer is **Windows PC only** (per the seller) over the included USB
  cable. There is a separate Wi-Fi/app variant of this product (iHanfo app,
  device name MEB-XXXX) — this kit documents the USB one.

## Getting back into it (loading / re-loading content)

1. Charge the ball first; a flat battery makes the USB connection flaky.
2. Plug it into a **Windows** PC with a **data-capable** USB-C cable.
3. **Hold the center button ~3 s** to power it on while plugged in — it shows
   up as a removable USB drive.
4. Open the drive and keep its folders as they are. MP4 videos go in the
   **VIDEO** folder, JPG photos in the **picture** folder. Don't delete the
   system folders.
5. Copy files in, **eject safely**, unplug. The ball starts playing on its own.
6. If the drive never appears: different cable (charge-only cables are the
   usual culprit), different USB port, and hold the power button while
   plugging in.
7. If the storage is scrambled: format the drive from Windows, recreate a
   folder named **VIDEO** in the root, and copy the videos back in.

## Video spec (the part that matters)

The embedded player chokes on fancy encoding. Every working file here is:

| Setting | Value |
|---|---|
| Canvas | 480×480, content inside a **circular mask** on pure black `#000000` |
| Codec | H.264, **Baseline Profile, Level 3.1** |
| Frame rate | 30 fps |
| B-frames | **None** (`-bf 0`) |
| Bitrate | 2500–3000 kbps (files here ≈ 2.7–2.85 Mbps) |
| Audio | None — stripped; nothing for the SoC to trip on |
| Length | 10 s loops (keep clips short; the player loops them) |

## Encode recipe

`encode-sphere.sh <input.mp4> <output.mp4>` runs the exact command:

```bash
ffmpeg -i input.mp4 -loop 1 -i mask.png -filter_complex \
"[0:v]scale=480:480:force_original_aspect_ratio=increase,crop=480:480,fps=30,format=rgba[src];\
[1:v]format=gray,scale=480:480[msk];\
[src][msk]alphamerge,format=rgba[fg];\
color=c=black:s=480x480:r=30[bg];\
[bg][fg]overlay=0:0:shortest=1,format=yuv420p[out]" \
-map "[out]" -an -frames:v 300 -c:v libx264 -profile:v baseline -level:v 3.1 \
-bf 0 -b:v 2800k -maxrate 3000k -bufsize 2800k -r 30 -movflags +faststart output.mp4
```

`mask.png` is a 480×480 white circle on black — generate it once with
`python3 make_mask.py` (included in this repo). Notes from the first
production run:

- `overlay ... shortest=1` plus `-frames:v 300` are **not optional** — without
  them the infinite black-background source can keep the encode running
  forever and balloon the output file.
- Verify every output before loading it onto the ball:

```bash
ffprobe -v error -select_streams v:0 \
  -show_entries stream=profile,level,width,height,avg_frame_rate,has_b_frames,bit_rate \
  file.mp4
# expect: Constrained Baseline, level 31, 480x480, 30/1, has_b_frames=0, ~2.8M
```

## Content made for this ball

The MP4s and preview stills are stored with the project files, not in git
(the MP4s are ~3.5 MB each and regenerable from the recipe above; this repo
carries the docs, the encode script, and the mask generator).

| File | Vibe |
|---|---|
| `christmas-snowglobe.mp4` | Cozy cabin in falling snow, warm windows — the original favorite |
| `nebula.mp4` | Violet/blue nebula swirl with a small planet |
| `jellyfish.mp4` | Bioluminescent teal jellyfish in black water |
| `jolly-snowglobe.mp4` | Jolly (cream plush, cowboy hat) waving beside the cabin in the snow |
| `winter-village.mp4` | Miniature Christmas village, tiny red train circling |
| `aurora-fox.mp4` | Fox on a frozen pond under aurora ribbons |

JPG stills for all six exist with the project files if the ball ever needs
pictures for the picture folder instead.

## Troubleshooting quick hits

- **Plays on PC, black/frozen on the ball** — wrong profile/bitrate. Re-check
  with the ffprobe command above; High Profile and B-frames are the usual
  offenders.
- **Video plays but corners show** — the circular mask step was skipped; the
  panel is round behind the glass, square corners get clipped/distorted.
- **Drive won't mount on a Mac** — expected; the seller lists this model as
  Windows-only for transfer. Use a Windows PC.
