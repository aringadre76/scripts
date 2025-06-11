#!/bin/bash

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
if [ -f ~/.cache/wal/colors-hyprland.conf ]; then
    cp ~/.cache/wal/colors-hyprland.conf ~/.config/hypr/colors.conf
    echo ":: Updated Hyprland colors"
else
    echo ":: Warning: Hyprland colors file not found"
fi

# Update kitty colors
if [ -f ~/.cache/wal/colors-kitty.conf ]; then
    cp ~/.cache/wal/colors-kitty.conf ~/.config/kitty/colors.conf
    echo ":: Updated Kitty colors"
    
    # Reload kitty colors for all instances
    if command -v kitty >/dev/null 2>&1; then
        kitty @ set-colors -a ~/.config/kitty/colors.conf 2>/dev/null || echo ":: Note: Could not reload existing kitty instances"
    fi
else
    echo ":: Warning: Kitty colors file not found"
fi

# Update taskbar (nwg-dock) colors
if [ -f ~/.cache/wal/colors-nwg-dock.css ]; then
    cp ~/.cache/wal/colors-nwg-dock.css ~/.config/nwg-dock-hyprland/colors.css
    echo ":: Updated taskbar (nwg-dock) colors"
    
    # Restart nwg-dock to apply new colors
    echo ":: Restarting taskbar..."
    pkill -f nwg-dock-hyprland
    sleep 0.5
    nohup ~/.config/nwg-dock-hyprland/launch.sh >/dev/null 2>&1 &
    echo ":: Taskbar restarted with new colors"
else
    echo ":: Warning: Taskbar colors file not found"
fi

# Update file manager (Thunar) colors
if [ -f ~/.cache/wal/colors-gtk3.css ]; then
    # Create gtk-3.0 directory if it doesn't exist
    mkdir -p ~/.config/gtk-3.0
    
    # Copy GTK3 colors
    cp ~/.cache/wal/colors-gtk3.css ~/.config/gtk-3.0/gtk.css
    echo ":: Updated file manager (Thunar) colors"
    
    # Restart Thunar if it's running to apply new colors
    if pgrep -f "thunar" >/dev/null 2>&1; then
        echo ":: Restarting file manager..."
        thunar -q 2>/dev/null || pkill -f thunar
        sleep 0.5
        nohup thunar --daemon >/dev/null 2>&1 &
        echo ":: File manager restarted with new colors"
    else
        echo ":: File manager colors will apply when Thunar is next opened"
    fi
else
    echo ":: Warning: File manager colors file not found"
fi

# Update Oh My Posh prompt colors
if [ -f ~/.cache/wal/EDM115-newline.omp.json ]; then
    cp ~/.cache/wal/EDM115-newline.omp.json ~/.config/ohmyposh/EDM115-newline.omp.json
    echo ":: Updated Oh My Posh prompt colors"
    
    # Reload prompt for current session (if possible)
    if [ -n "$BASH_VERSION" ]; then
        # For bash sessions, we can try to reload the prompt
        eval "$(oh-my-posh init bash --config $HOME/.config/ohmyposh/EDM115-newline.omp.json)" 2>/dev/null || echo ":: Note: Prompt colors will apply to new terminal sessions"
    fi
else
    echo ":: Warning: Oh My Posh colors file not found"
fi

# Update Cursor IDE colors
if [ -f ~/.cache/wal/cursor-settings.json ]; then
    # Backup original settings if it exists and backup doesn't exist
    if [ -f ~/.config/Cursor/User/settings.json ] && [ ! -f ~/.config/Cursor/User/settings.json.backup ]; then
        cp ~/.config/Cursor/User/settings.json ~/.config/Cursor/User/settings.json.backup
        echo ":: Backed up original Cursor settings"
    fi
    
    # Copy new settings
    cp ~/.cache/wal/cursor-settings.json ~/.config/Cursor/User/settings.json
    echo ":: Updated Cursor IDE colors"
    
    # Try to reload Cursor if it's running (this may not work for all cases)
    if pgrep -f "cursor" >/dev/null 2>&1; then
        echo ":: Note: Cursor is running - restart Cursor to see the new theme"
    fi
else
    echo ":: Warning: Cursor settings file not found"
fi

# Update Spotify colors
if command -v spicetify >/dev/null 2>&1 || [ -f ~/.spicetify/spicetify ]; then
    # Add spicetify to PATH if it exists
    export PATH="$PATH:/home/arin/.spicetify"
    
    # Copy generated color scheme and CSS
    if [ -f ~/.cache/wal/spotify-color.ini ]; then
        mkdir -p ~/.config/spicetify/Themes/Pywal
        cp ~/.cache/wal/spotify-color.ini ~/.config/spicetify/Themes/Pywal/color.ini
        echo ":: Updated Spotify color scheme"
    fi
    
    if [ -f ~/.cache/wal/spotify-user.css ]; then
        cp ~/.cache/wal/spotify-user.css ~/.config/spicetify/Themes/Pywal/user.css
        echo ":: Updated Spotify CSS theme"
    fi
    
    # Apply the theme
    if [ -f ~/.config/spicetify/Themes/Pywal/color.ini ] && [ -f ~/.config/spicetify/Themes/Pywal/user.css ]; then
        echo ":: Applying Spotify theme..."
        spicetify config current_theme Pywal 2>/dev/null
        spicetify apply 2>/dev/null && echo ":: Spotify theme applied successfully" || echo ":: Note: Could not apply Spotify theme (Spotify may need to be restarted)"
    fi
else
    echo ":: Note: Spicetify not found - skipping Spotify theming"
fi

# Update terminal sequences for fish and other shells
if [ -f ~/.cache/wal/sequences ]; then
    echo ":: Updated terminal sequences"
fi

# Ensure Wayland environment for waybar
export GDK_BACKEND=wayland
export QT_QPA_PLATFORM=wayland

# Reload waybar
echo ":: Reloading waybar..."
pkill waybar
sleep 1

# Start waybar in background
nohup ~/.config/waybar/launch.sh >/dev/null 2>&1 &

# Wait a moment for waybar to start
sleep 0.5

# Reload hyprland config to apply new colors
hyprctl reload >/dev/null 2>&1
echo ":: Reloaded Hyprland configuration"

# Notify user
notify-send "Wallpaper & Theme Changed" "Colors updated for wallpaper, waybar, taskbar, file manager, prompt, Cursor IDE, Spotify, borders, and terminal!" -i "$wallpaper" 2>/dev/null

echo ":: Theme update complete!" 