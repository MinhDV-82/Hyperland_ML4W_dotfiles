#!/usr/bin/env bash
SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

FILENAME="screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
FILEPATH="$SAVE_DIR/$FILENAME"

grim "$FILEPATH" || exit 1
wl-copy < "$FILEPATH"
notify-send "📸 Đã chụp toàn màn hình" "Đã lưu vào Pictures/Screenshots và copy vào bộ nhớ tạm!" -i "$FILEPATH" -t 2500 2>/dev/null || true
