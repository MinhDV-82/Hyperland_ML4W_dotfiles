#!/usr/bin/env bash
# Đóng nếu đang mở, mở nếu đang đóng
if pgrep -x rofi >/dev/null; then
    pkill -x rofi
    exit 0
fi

# Mở trực tiếp Rofi drun
rofi -show drun -theme ~/.config/rofi/config.rasi &
