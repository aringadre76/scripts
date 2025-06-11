#!/bin/bash

# Path to ASCII art file
ART_FILE="/home/arin/ascii_art/ascii-animation.txt"
OUTPUT_FILE="/tmp/neofetch_ascii.txt"

# Extract the first frame (up to the first blank line)
awk 'BEGIN{out=1} /^$/{out=0; exit} out{print}' "$ART_FILE" > "$OUTPUT_FILE"

# Make sure it's not too large for neofetch (truncate if needed)
head -n 100 "$OUTPUT_FILE" > "$OUTPUT_FILE.tmp" && mv "$OUTPUT_FILE.tmp" "$OUTPUT_FILE"

echo "$OUTPUT_FILE" 