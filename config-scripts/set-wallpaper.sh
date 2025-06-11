#!/bin/bash
# Simple wallpaper setter script using waypaper with hyprpaper backend

# Check if a wallpaper path is provided
if [ -z "$1" ]; then
    echo "Error: Please provide the path to a wallpaper image."
    echo "Usage: $0 /path/to/wallpaper.jpg"
    exit 1
fi

wallpaper="$1"

# Check if the wallpaper file exists
if [ ! -f "$wallpaper" ]; then
    echo "Error: The file '$wallpaper' does not exist."
    exit 1
fi

# Generate pywal16 colors first
echo "Generating color scheme from $wallpaper..."
wal -i "$wallpaper" --saturate 0.5

# Set the wallpaper using waypaper with hyprpaper backend
echo "Setting wallpaper to $wallpaper..."
waypaper --backend hyprpaper --wallpaper "$wallpaper"

echo "Wallpaper set to: $wallpaper"
echo "Colors generated with pywal16" 