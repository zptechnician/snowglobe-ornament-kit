# Snow Globe Ornament Kit

Notes for the little glass ball that plays videos (the 2.7 inch Christmas
memory sphere). How to turn it on, how to put your own videos and photos on
it, and the extra stuff for when it's plugged into a computer.

## Turn it on

1. Charge it first. Plug it in and let it fill up.
2. Hold the middle button for about 3 seconds. The screen lights up. It's on.
3. Hold the same button again to turn it off.
4. Tap the middle button to pause or play.
5. Turn the dial to jump to the next or last video.

## Put your own videos and photos on it

This is the normal way. No special tools.

1. Plug the ball into a computer with the USB cable.
   (The seller page says Windows only, but a Mac worked fine for mine.)
2. Turn the ball on while it's plugged in (hold the middle button,
   3 seconds). A new drive pops up on the computer, like a USB stick.
3. Open the drive. There are folders on it. **Do not delete the folders.**
4. Put videos in the **VIDEO** folder. Put photos in the **picture** folder.
5. Eject the drive the safe way, then unplug the ball.
6. Done. The ball plays your stuff by itself.

File rules, simple version:

- Videos must be **MP4**. Photos must be **JPG**.
- Keep videos short. A few minutes at most. The ball has 4 GB of space.
- The battery lasts about 2 to 4 hours per charge.

## [Advanced] When it's wired to the PC

Only read this part if something is wrong, or if you make your own video
files and want them to always play.

### The drive won't show up

- Try a different cable. Some USB cables only charge. They can't move files.
- Try a different USB port.
- Hold the middle button while you plug it in.
- Make sure the ball is charged.

### The folders, in plain words

- **VIDEO** = the videos. The ball plays these first.
- **picture** = the photos.
- If the ball acts weird or the drive looks empty and broken: format the
  drive in Windows, then make one new folder in the top level named exactly
  **VIDEO**, and copy your videos back into it.

### The strict video recipe (for files you make yourself)

The ball is picky. A video that plays fine on a computer can still fail on
the ball. Files that always work look like this:

- Size: **480 x 480**
- Picture sits inside a **circle**, on a **black** background
  (the screen behind the glass is round)
- Type: H.264 video, **Baseline** profile, level **3.1**
- Speed: **30 fps** (frames per second)
- **No B-frames** (a nerdy setting that cheap players choke on)
- Bitrate: about **2,800 kbps** (stay between 2,500 and 3,000)
- Sound: not needed. The files below have none.

The script in this repo does all of that in one command:

```bash
python3 make_mask.py                  # one time: makes the circle mask
./encode-sphere.sh myvideo.mp4 out.mp4
```

### Videos already made for this ball

Made with the recipe above. All are 10 seconds and loop fine:

- `winter-village.mp4` — tiny Christmas village with a little red train.
- `aurora-fox.mp4` — a fox on a frozen pond under northern lights.

The video files themselves are not stored in this repo. This repo is the
instructions, the script, and the mask maker.
