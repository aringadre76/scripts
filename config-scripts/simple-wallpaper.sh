#!/bin/bash
# Simple wallpaper setter with pywal

# Kill any existing swaybg instances
pkill -f swaybg

# Check if a wallpaper was provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/wallpaper.jpg"
    exit 1
fi

# Set wallpaper with swaybg and generate colors with wal
wal -i "$1" --saturate 0.5
swaybg -i "$1" -m fill &

echo "Wallpaper set to: $1"
echo "Colors generated with pywal" 