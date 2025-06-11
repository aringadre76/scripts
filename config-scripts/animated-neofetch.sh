#!/bin/bash

# Path to your ASCII art file with frames
ART_FILE="/home/arin/ascii_art/ascii-animation.txt"

# Create a temporary directory for frame files
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Function to display a frame
display_frame() {
    clear
    cat "$1"
    echo ""
    # Display system info manually
    echo "OS: $(lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om)"
    echo "Host: $(hostname)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p | sed 's/up //')"
    echo "Packages: $(pacman -Q | wc -l)"
    echo "Shell: $SHELL"
    echo "Terminal: $TERM"
    if command -v xprop >/dev/null 2>&1; then
        echo "DE/WM: $(xprop -id $(xprop -root -notype | grep "_NET_SUPPORTING_WM_CHECK" | awk '{print $5}') -notype -f _NET_WM_NAME 8t | grep "_NET_WM_NAME" | cut -d\" -f2)"
    else
        echo "DE/WM: Unknown"
    fi
}

# Function to split the file into frames
split_frames() {
    # Check if the file has FRAME: markers
    if grep -q "FRAME:" "$ART_FILE"; then
        echo "Found FRAME markers in file"
        # Process file with existing FRAME: markers
        frame_num=1
        in_frame=0
        current_frame=""
        
        while IFS= read -r line || [ -n "$line" ]; do
            if [[ "$line" == "FRAME:"* ]]; then
                if [[ $in_frame -eq 1 ]]; then
                    # Save previous frame
                    echo "$current_frame" > "$TEMP_DIR/frame_$frame_num"
                    frame_num=$((frame_num + 1))
                fi
                in_frame=1
                current_frame=""
            elif [[ $in_frame -eq 1 ]]; then
                current_frame+="$line"$'\n'
            fi
        done < "$ART_FILE"
        
        # Save the last frame
        if [[ $in_frame -eq 1 ]]; then
            echo "$current_frame" > "$TEMP_DIR/frame_$frame_num"
        fi
        
        return $frame_num
    else
        # Treat the file as a single frame
        cp "$ART_FILE" "$TEMP_DIR/frame_1"
        return 1
    fi
}

# Split the frames
split_frames
NUM_FRAMES=$?

# Check if splitting succeeded
if [ "$NUM_FRAMES" -eq 0 ]; then
    echo "No frames found in the ASCII art file."
    exit 1
fi

# Display animation
frame=1
while true; do
    # Display the current frame with system info
    display_frame "$TEMP_DIR/frame_$frame"
    
    # Move to next frame
    frame=$(( (frame % NUM_FRAMES) + 1 ))
    
    # Pause between frames
    sleep 0.2
    
    # Break after one full cycle 
    if [ "$frame" -eq 1 ] && [ "$1" != "--loop" ]; then
        break
    fi
done 