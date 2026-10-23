#!/usr/bin/env bash
# Script chụp màn hình nhanh 1 chạm:
# Kéo chuột chọn vùng -> Lưu file vào ~/Pictures/Screenshots + Copy luôn vào Clipboard

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

FILENAME="screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
FILEPATH="$SAVE_DIR/$FILENAME"

# 1. Chọn vùng màn hình bằng slurp
REGION=$(slurp -b "#00000066" -c "#5294e2ff" -w 2) || exit 0
[[ -z "$REGION" ]] && exit 0

# 2. Chụp bằng grim
grim -g "$REGION" "$FILEPATH" || exit 1

# 3. Copy ngay lập tức vào clipboard
wl-copy < "$FILEPATH"

# 4. Gửi thông báo
notify-send "📸 Đã chụp màn hình" "Đã lưu vào Pictures/Screenshots và copy vào bộ nhớ tạm!" -i "$FILEPATH" -t 2500 2>/dev/null || true
