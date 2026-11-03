#!/usr/bin/env python3
"""Generate mask.png: a 480x480 white circle on black, anti-aliased.

The sphere's panel is round; the encode recipe uses this mask to cut the
video to a circle on a pure black background.
"""
from PIL import Image, ImageDraw

S = 1920  # draw at 4x, downscale for a smooth edge
m = Image.new("L", (S, S), 0)
d = ImageDraw.Draw(m)
d.ellipse([8, 8, S - 8, S - 8], fill=255)
m = m.resize((480, 480), Image.LANCZOS)
m.save("mask.png")
print("wrote mask.png")
