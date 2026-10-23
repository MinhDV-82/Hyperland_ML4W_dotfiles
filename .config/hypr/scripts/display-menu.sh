#!/usr/bin/env bash
# Menu chọn chế độ màn hình trực quan (Toggle chống trùng lặp, chống đè)

PID_FILE="/tmp/display-menu.pid"

# Nếu menu đang mở -> Tắt ngay lập tức khi bấm lại Win+P
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE" 2>/dev/null)
    if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
        kill "$PID" 2>/dev/null || true
        pkill -x rofi 2>/dev/null || true
        pkill -x wofi 2>/dev/null || true
        rm -f "$PID_FILE"
        exit 0
    fi
fi

# Đảm bảo không có rofi/wofi menu cũ chạy ngầm
pkill -x rofi 2>/dev/null || true
pkill -x wofi 2>/dev/null || true

# Ghi PID của tiến trình hiện tại
echo $$ > "$PID_FILE"
trap 'rm -f "$PID_FILE"' EXIT

OPTIONS="1. 🖥️➕💻 Extend (Dùng cả 2 màn hình)\n2. 💻 PC Screen Only (Chỉ màn Laptop)\n3. 🖥️ Second Screen Only (Chỉ màn Ngoài LG)\n4. 👥 Duplicate / Mirror (Nhân đôi màn hình)"

CHOSEN=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Chọn chế độ hiển thị (Project):" -lines 4 2>/dev/null || \
         echo -e "$OPTIONS" | wofi --dmenu --prompt "Chọn chế độ hiển thị:")

rm -f "$PID_FILE"

case "$CHOSEN" in
    *Extend*)
        ~/.config/hypr/scripts/display-switch.sh extend
        ;;
    *PC\ Screen\ Only*|*Laptop*)
        ~/.config/hypr/scripts/display-switch.sh laptop
        ;;
    *Second\ Screen\ Only*|*Ngoài*)
        ~/.config/hypr/scripts/display-switch.sh hdmi
        ;;
    *Duplicate*|*Mirror*)
        ~/.config/hypr/scripts/display-switch.sh mirror
        ;;
esac
