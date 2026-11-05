#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Add to Inbox
# @raycast.mode silent
# @raycast.argument1 { "type": "text", "placeholder": "What's on your mind?" }

# Optional parameters:
# @raycast.icon 🧠
# @raycast.packageName hq
# @raycast.description Append a line to Working Memory in the hq Obsidian vault

file="$HOME/Documents/Obsidian/hq/Working Memory.md"

[ -f "$file" ] || { echo "No Working Memory.md at $file"; exit 1; }
[ -n "$(tail -c 1 "$file")" ] && echo >> "$file"
printf -- '- %s · %s\n' "$(date +%F)" "$1" >> "$file"

echo "Added to Working Memory"
