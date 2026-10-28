#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Keybindings
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon ⌨️
# @raycast.packageName AeroSpace
# @raycast.description Show AeroSpace keybindings (Omarchy-style Super+K)

export PATH="/opt/homebrew/bin:$PATH"

aerospace config --get mode.main.binding --json | /usr/bin/python3 -c '
import json, re, sys

b = json.load(sys.stdin)
names = {"left": "←", "right": "→", "up": "↑", "down": "↓", "enter": "Enter",
         "tab": "Tab", "minus": "-", "equal": "=", "backtick": "`", "semicolon": ";"}

def pretty(k):
    k = k.replace("cmd-alt-ctrl-shift-", "Super+Shift+").replace("cmd-alt-ctrl-", "Super+")
    head, _, key = k.rpartition("+")
    return f"{head}+{names.get(key, key.upper())}"

def describe(cmd):
    cmd = " ; ".join(cmd) if isinstance(cmd, list) else cmd
    cmd = re.sub(r"exec-and-forget\s+open -na ", "open ", cmd)
    return cmd.replace("move-node-to-workspace --focus-follows-window", "move window to workspace")

rows, ws, mv = [], False, False
for k, v in sorted(b.items(), key=lambda kv: describe(kv[1])):
    d = describe(v)
    if re.fullmatch(r"workspace \d+", d):
        if not ws: rows.append(("Super+1…0", "workspace 1…10")); ws = True
        continue
    if re.fullmatch(r"move window to workspace \d+", d):
        if not mv: rows.append(("Super+Shift+1…0", "move window to workspace 1…10 (follow)")); mv = True
        continue
    rows.append((pretty(k), d))

w = max(len(r[0]) for r in rows)
for k, d in rows:
    print(f"{k:<{w}}   {d}")
'
