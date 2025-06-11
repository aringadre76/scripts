#!/bin/bash
#  _      __     ____                      
# | | /| / /__ _/ / /__  ___ ____  ___ ____
# | |/ |/ / _ `/ / / _ \/ _ `/ _ \/ -_) __/
# |__/|__/\_,_/_/_/ .__/\_,_/ .__/\__/_/   
#                /_/       /_/             
# -----------------------------------------------------
# Simplified wallpaper script without ML4W dependencies
# -----------------------------------------------------

# -----------------------------------------------------
# Set defaults
# -----------------------------------------------------

# Create necessary directories
mkdir -p "$HOME/.cache/wallpaper-cache"
mkdir -p "$HOME/.config/hypr/wallpaper-data"

force_generate=0
generatedversions="$HOME/.cache/wallpaper-cache"
waypaperrunning="$HOME/.cache/waypaper-running"
cachefile="$HOME/.cache/current_wallpaper"
persistentcachefile="$HOME/.config/hypr/wallpaper-data/persistent_wallpaper"
blurredwallpaper="$HOME/.cache/blurred_wallpaper.png"
squarewallpaper="$HOME/.cache/square_wallpaper.png"
defaultwallpaper="$HOME/wallpaper/default.jpg"
blur="50x30"

# Ensures that the script only runs once if called multiple times
if [ -f $waypaperrunning ]; then
    rm $waypaperrunning
    exit
fi

# -----------------------------------------------------
# Get selected wallpaper
# -----------------------------------------------------

if [ -z $1 ]; then
    if [ -f $cachefile ]; then
        wallpaper=$(cat $cachefile)
    else
        # Default to a wallpaper that exists
        wallpaper=$(find $HOME/wallpaper -type f -name "*.jpg" | head -1)
    fi
else
    wallpaper=$1
fi
used_wallpaper=$wallpaper
echo ":: Setting wallpaper with source image $wallpaper"

# -----------------------------------------------------
# Copy path of current wallpaper to cache files
# -----------------------------------------------------

echo "$wallpaper" > $cachefile
echo ":: Path of current wallpaper copied to $cachefile"

# Also save to persistent cache file to survive reboots
echo "$wallpaper" > $persistentcachefile
echo ":: Path of current wallpaper saved to persistent cache $persistentcachefile"

# -----------------------------------------------------
# Get wallpaper filename
# -----------------------------------------------------
wallpaperfilename=$(basename $wallpaper)
echo ":: Wallpaper Filename: $wallpaperfilename"

# -----------------------------------------------------
# Execute matugen
# -----------------------------------------------------

echo ":: Execute matugen with $used_wallpaper"
$HOME/.cargo/bin/matugen image $used_wallpaper -m "dark"

# -----------------------------------------------------
# Update Pywalfox
# -----------------------------------------------------

if type pywalfox >/dev/null 2>&1; then
    pywalfox update
fi

# -----------------------------------------------------
# Update VSCode Theme
# -----------------------------------------------------

if [ -f "$HOME/.config/hypr/scripts/update-vscode-theme.sh" ]; then
    echo ":: Updating VSCode theme"
    $HOME/.config/hypr/scripts/update-vscode-theme.sh
fi

# -----------------------------------------------------
# Reload Waybar
# -----------------------------------------------------

killall -SIGUSR2 waybar

# -----------------------------------------------------
# Reload nwg-dock-hyprland
# -----------------------------------------------------

if [ -f "$HOME/.config/nwg-dock-hyprland/launch.sh" ]; then
    $HOME/.config/nwg-dock-hyprland/launch.sh &
fi

# -----------------------------------------------------
# Update SwayNC
# -----------------------------------------------------
sleep 0.1
if type swaync-client >/dev/null 2>&1; then
    swaync-client -rs
fi

# -----------------------------------------------------
# Create blurred wallpaper
# -----------------------------------------------------

echo ":: Generate new blurred wallpaper with blur $blur"
if type magick >/dev/null 2>&1; then
    magick $used_wallpaper -resize 75% $blurredwallpaper
    echo ":: Resized to 75%"
    magick $blurredwallpaper -blur $blur $blurredwallpaper
    echo ":: Blurred"
else
    echo ":: ImageMagick not found. Using original wallpaper."
    cp $used_wallpaper $blurredwallpaper
fi

# -----------------------------------------------------
# Create square wallpaper
# -----------------------------------------------------

echo ":: Generate square wallpaper"
if type magick >/dev/null 2>&1; then
    magick $used_wallpaper -gravity Center -extent 1:1 $squarewallpaper
    echo ":: Created square wallpaper"
else
    echo ":: ImageMagick not found. Using original wallpaper."
    cp $used_wallpaper $squarewallpaper
fi 

# This script is called by waypaper after setting a new wallpaper
# It regenerates the color scheme and reloads waybar

wallpaper="$1"

if [ -z "$wallpaper" ]; then
    echo "No wallpaper provided"
    exit 1
fi

echo "Generating color scheme from $wallpaper"

# Generate pywal colors
wal -i "$wallpaper" --saturate 0.5 -n

# Copy colors to hyprland
cp ~/.cache/wal/colors-hyprland.conf ~/.config/hypr/colors.conf

# Reload waybar
pkill waybar
sleep 0.5
~/.config/waybar/launch.sh &

# Reload hyprland config to apply new colors
hyprctl reload

# Notify user
notify-send "Wallpaper Changed" "Theme updated to match new wallpaper!" -i "$wallpaper" 