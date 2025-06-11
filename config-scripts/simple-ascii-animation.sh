#!/bin/bash

# Path to ASCII art file
ART_FILE="/home/arin/ascii_art/ascii-animation.txt"

# Display system info
display_system_info() {
    echo -e "\033[1;36m"  # Cyan color
    echo "OS: $(lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om)"
    echo "Host: $(hostname)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p | sed 's/up //')"
    echo "Packages: $(pacman -Q | wc -l)"
    echo "Shell: $SHELL"
    echo "Terminal: $TERM"
    echo -e "\033[0m"  # Reset color
}

# Function to extract frames based on blank lines
extract_frames() {
    # Create a temporary directory for the frames
    TEMP_DIR=$(mktemp -d)
    
    # Split the file into frames using blank lines as delimiters
    frame_count=0
    frame_content=""
    
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ -z "$line" && -n "$frame_content" ]]; then
            # End of a frame, save it
            frame_count=$((frame_count + 1))
            echo "$frame_content" > "$TEMP_DIR/frame_$frame_count"
            frame_content=""
        elif [[ -n "$line" ]]; then
            # Add line to current frame
            frame_content+="$line"$'\n'
        fi
    done < "$ART_FILE"
    
    # Save the last frame if it exists
    if [[ -n "$frame_content" ]]; then
        frame_count=$((frame_count + 1))
        echo "$frame_content" > "$TEMP_DIR/frame_$frame_count"
    fi
    
    echo "$TEMP_DIR $frame_count"
}

# Main animation loop
main() {
    # Extract the frames
    read TEMP_DIR frame_count < <(extract_frames)
    
    if [[ $frame_count -eq 0 ]]; then
        echo "No frames found in the ASCII art file."
        rm -rf "$TEMP_DIR"
        exit 1
    fi
    
    # Get terminal size
    term_rows=$(tput lines)
    term_cols=$(tput cols)
    
    # Loop through frames
    frame=1
    while true; do
        clear
        
        # Display current frame with nice colors using lolcat if available
        if command -v lolcat >/dev/null 2>&1; then
            cat "$TEMP_DIR/frame_$frame" | lolcat -a -s 150
        else
            cat "$TEMP_DIR/frame_$frame"
        fi
        
        # Display system info below the animation
        display_system_info
        
        # Move to next frame
        frame=$(( (frame % frame_count) + 1 ))
        
        # Pause between frames
        sleep 0.15
        
        # Break after one full cycle if not in loop mode
        if [[ $frame -eq 1 && "$1" != "--loop" ]]; then
            break
        fi
    done
    
    # Clean up temporary files
    rm -rf "$TEMP_DIR"
}

# Run the main function
main "$@" 