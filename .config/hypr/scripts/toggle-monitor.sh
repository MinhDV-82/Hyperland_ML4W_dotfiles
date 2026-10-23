#!/usr/bin/env bash
# Toggle tắt/bật màn hình phụ (HDMI-A-1 = LG UltraGear)
# Dùng: toggle-monitor.sh [tên_monitor]

MONITOR="${1:-HDMI-A-1}"

STATUS=$(hyprctl monitors all -j | python3 -c "
import json, sys
monitors = json.load(sys.stdin)
for m in monitors:
    if m['name'] == '$MONITOR':
        print('disabled' if m['disabled'] else 'enabled')
        break
" 2>/dev/null)

if [ "$STATUS" = "enabled" ]; then
    hyprctl keyword monitor "$MONITOR,disable"
    notify-send "🖥️ Monitor" "Đã tắt $MONITOR" --expire-time=2000 2>/dev/null || true
else
    # Bật lại với cấu hình preferred
    hyprctl keyword monitor "$MONITOR,preferred,auto,1"
    notify-send "🖥️ Monitor" "Đã bật $MONITOR" --expire-time=2000 2>/dev/null || true
fi

