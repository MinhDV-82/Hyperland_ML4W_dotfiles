#!/usr/bin/env bash
# Load Night Light setting from ~/.config/hypr/nightlight.json
CONFIG_FILE="$HOME/.config/hypr/nightlight.json"

if [ -f "$CONFIG_FILE" ]; then
    ENABLED=$(python3 -c "import json; d=json.load(open('$CONFIG_FILE')); print(d.get('enabled', False))" 2>/dev/null)
    TEMP=$(python3 -c "import json; d=json.load(open('$CONFIG_FILE')); print(d.get('temperature', 4500))" 2>/dev/null)
else
    ENABLED="True"
    TEMP="4500"
fi

pkill -9 -x hyprsunset 2>/dev/null || true

if [ "$ENABLED" = "True" ]; then
    sleep 0.2
    hyprsunset -t "$TEMP" >/dev/null 2>&1 &
fi
