#!/usr/bin/env bash
# Đổi màu chủ đạo (Accent Color) của hệ thống bằng Matugen
HEX="$1"

if [ -z "$HEX" ]; then
    COLORS="1. 💎 Trắng Tuyết / Bạch Kim (Pure White / Platinum): #ffffff\n2. ⚪ Trắng Bạc (Silver / Light Gray): #d1d5db\n3. 🔵 Xanh Dương (Blue): #3b82f6\n4. 🟣 Tím (Purple): #8b5cf6\n5. 🟢 Xanh Lá (Emerald): #10b981\n6. 🔴 Đỏ Hồng (Rose): #f43f5e\n7. 🟠 Cam (Orange): #f97316\n8. 🟡 Vàng (Amber): #f59e0b\n9. 🌊 Cyan / Xanh Biển: #06b6d4\n10. 🎨 Nhập mã màu HEX tùy ý..."

    CHOSEN=$(echo -e "$COLORS" | rofi -dmenu -i -p "Chọn màu chủ đạo (Accent Color):" -lines 10 2>/dev/null || \
             echo -e "$COLORS" | wofi --dmenu --prompt "Chọn màu chủ đạo:")

    [ -z "$CHOSEN" ] && exit 0

    case "$CHOSEN" in
        *Pure\ White*|*ffffff*) HEX="#ffffff" ;;
        *Silver*|*d1d5db*) HEX="#d1d5db" ;;
        *Blue*) HEX="#3b82f6" ;;
        *Purple*) HEX="#8b5cf6" ;;
        *Emerald*) HEX="#10b981" ;;
        *Rose*) HEX="#f43f5e" ;;
        *Orange*) HEX="#f97316" ;;
        *Amber*) HEX="#f59e0b" ;;
        *Cyan*) HEX="#06b6d4" ;;
        *Nhập*)
            HEX=$(rofi -dmenu -p "Nhập mã màu (ví dụ #ffffff):" -lines 0 2>/dev/null || \
                  wofi --dmenu --prompt "Nhập mã màu:")
            ;;
    esac
fi

[ -z "$HEX" ] && exit 0

# Kiểm tra nếu người dùng chọn màu Trắng / Bạc
LOWER_HEX=$(echo "$HEX" | tr '[:upper:]' '[:lower:]')
if [[ "$LOWER_HEX" =~ ^#(fff(fff)?|e5e7eb|d1d5db|f8fafc|f1f5f9)$ ]]; then
    # Dùng thuật toán scheme-monochrome để tạo màu Trắng Tuyết chuẩn #FFFFFF, chữ đen tương phản cao
    matugen -t scheme-monochrome color hex "$HEX" -m dark 2>/dev/null || true
else
    # Các màu sắc khác dùng scheme-fidelity để giữ nguyên tông màu người dùng chọn
    matugen -t scheme-fidelity color hex "$HEX" -m dark 2>/dev/null || true
fi

# Đồng bộ nhanh màu KDE
R=$(printf "%d" 0x${HEX:1:2} 2>/dev/null || echo 255)
G=$(printf "%d" 0x${HEX:3:2} 2>/dev/null || echo 255)
B=$(printf "%d" 0x${HEX:5:2} 2>/dev/null || echo 255)
RGB="$R,$G,$B"

if command -v kwriteconfig6 >/dev/null 2>&1; then
    kwriteconfig6 --file kdeglobals --group General --key AccentColor "$RGB"
    kwriteconfig6 --file kdeglobals --group General --key LastUsedCustomAccentColor "$RGB"
fi
sed -i "s/DecorationFocus=.*/DecorationFocus=$RGB/g" ~/.config/kdeglobals 2>/dev/null || true

# Reload Hyprland & các thanh công cụ
hyprctl reload 2>/dev/null || true
~/.config/hypr/scripts/restart-bars.sh >/dev/null 2>&1 &
notify-send "🎨 Accent Color" "Đã áp dụng màu chủ đạo: $HEX" -t 2000 2>/dev/null || true
