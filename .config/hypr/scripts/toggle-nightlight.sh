#!/usr/bin/env bash
# Bật/tắt chế độ Lọc ánh sáng xanh (Night Light) bằng hyprsunset

if pgrep -x hyprsunset >/dev/null; then
    killall hyprsunset
    notify-send "☀️ Night Light" "Đã TẮT chế độ lọc ánh sáng xanh (6000K)" -i weather-clear -t 2000 2>/dev/null || true
else
    # 4500K là độ ấm dịu lý tưởng theo yêu cầu của bạn
    nohup hyprsunset -t 4500 >/dev/null 2>&1 &
    notify-send "🌙 Night Light" "Đã BẬT lọc ánh sáng xanh (4500K ấm dịu)" -i weather-clear-night -t 2000 2>/dev/null || true
fi
