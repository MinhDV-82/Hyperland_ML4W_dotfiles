#!/usr/bin/env bash
# Chọn mức nhiệt độ màu ánh sáng xanh (K) hoặc tắt

CURRENT=""
if pgrep -x hyprsunset >/dev/null; then
    CURRENT=" (Đang bật)"
fi

OPTIONS="1. ☀️ Tắt chế độ lọc (6000K - Trắng chuẩn)
2. 🌤️ 5000K - Dịu mắt nhẹ nhàng
3. 🌅 4500K - Ấm dịu lý tưởng (Khuyên dùng)
4. 🌙 4000K - Ban đêm chống mỏi mắt
5. 🕯️ 3500K - Vàng ấm thư giãn tối đa
6. ✏️ Tự nhập số độ K tùy ý (2500 - 6000)..."

CHOSEN=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "🌙 Chỉnh ánh sáng xanh${CURRENT}:" -lines 6 2>/dev/null || \
         echo -e "$OPTIONS" | wofi --dmenu --prompt "🌙 Chỉnh ánh sáng xanh:")

[ -z "$CHOSEN" ] && exit 0

TEMP=""
case "$CHOSEN" in
    *Tắt*|*6000K*)
        killall hyprsunset 2>/dev/null || true
        notify-send "☀️ Night Light" "Đã TẮT lọc ánh sáng xanh (Trắng tự nhiên)" -i weather-clear -t 2000 2>/dev/null || true
        exit 0
        ;;
    *5000K*) TEMP="5000" ;;
    *4500K*) TEMP="4500" ;;
    *4000K*) TEMP="4000" ;;
    *3500K*) TEMP="3500" ;;
    *Tự\ nhập*)
        TEMP=$(rofi -dmenu -p "Nhập độ K (ví dụ 4500):" -lines 0 2>/dev/null || \
               wofi --dmenu --prompt "Nhập độ K:")
        ;;
esac

if [[ "$TEMP" =~ ^[0-9]+$ ]]; then
    killall hyprsunset 2>/dev/null || true
    sleep 0.1
    nohup hyprsunset -t "$TEMP" >/dev/null 2>&1 &
    notify-send "🌙 Night Light" "Đã áp dụng nhiệt độ màu: ${TEMP}K" -i weather-clear-night -t 2000 2>/dev/null || true
fi
