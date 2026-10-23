#!/usr/bin/env bash
# Giấu cửa sổ đang focus vào special workspace "minimized"
hyprctl eval "hl.dispatch(hl.dsp.window.move({workspace = 'special:minimized', silent = true}))"
notify-send "🔽 Minimized" "Đã ẩn cửa sổ. Bấm Win+Shift+M hoặc Win+D để xem lại!" -i window-minimize -t 1500 2>/dev/null || true
