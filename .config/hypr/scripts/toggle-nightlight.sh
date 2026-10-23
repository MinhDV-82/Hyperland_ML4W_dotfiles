#!/usr/bin/env bash
# Bật/tắt chế độ Lọc ánh sáng xanh (Night Light) bằng hyprsunset

if pgrep -x hyprsunset >/dev/null; then
    killall hyprsunset
    notify-send "☀️ Night Light" "Đã TẮT chế độ lọc ánh sáng xanh" -i weather-clear -t 2000 2>/dev/null || true
else
    # 4000K là độ ấm lý tưởng bảo vệ mắt ban đêm (mặc định là 6000K - ánh sáng xanh trắng)
    nohup hyprsunset -t 4000 >/dev/null 2>&1 &
    notify-send "🌙 Night Light" "Đã BẬT lọc ánh sáng xanh (4000K ấm dịu)" -i weather-clear-night -t 2000 2>/dev/null || true
fi
