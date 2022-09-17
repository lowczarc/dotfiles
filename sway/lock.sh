#!/usr/bin/env bash

original_dir="$(pwd)"

cd "$(dirname "$0")" || exit

#get logo path, if none random
image="$HOME/Pictures/wallpaper/current-lock.png"

#import pywal colors

swaylock \
  --indicator-radius 160 \
  --indicator-thickness 20 \
  --inside-color 00000000 \
  --inside-clear-color 00000000 \
  --inside-ver-color 00000000 \
  --inside-wrong-color 00000000 \
  --line-uses-ring \
  --line-color 00000000 \
  --font 'NotoSans Nerd Font Mono:style=Thin,Regular 40' \
  --text-color 00000000 \
  --text-clear-color 00000000 \
  --text-wrong-color 00000000 \
  --text-ver-color 00000000 \
  --separator-color 00000000 \
  --key-hl-color ffffffff \
  --bs-hl-color aaaa0088 \
  --ring-color ffffff66 \
  --ring-clear-color 55555588 \
  --ring-wrong-color ff000088 \
  --ring-ver-color ff880088 \
  --image $image
