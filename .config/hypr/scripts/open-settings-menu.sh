#!/usr/bin/env bash
# ====================================================================
# HYPRLAND CONTROL CENTER (BẢNG ĐIỀU KHIỂN & CÀI ĐẶT TẬP TRUNG GIỐNG KDE)
# Mở bằng: Win + I
# ====================================================================

# Kiểm tra trạng thái Night Light
NL_STATUS="Tắt"
if pgrep -x hyprsunset >/dev/null; then
    NL_STATUS="Đang bật"
fi

# Kiểm tra trạng thái Dock Autohide
DOCK_HIDE="Tắt"
if grep -q '"autohide": true' ~/.config/ml4w-dock/config.json 2>/dev/null; then
    DOCK_HIDE="Bật"
fi

# Kiểm tra trạng thái Statusbar Autohide
BAR_HIDE="Tắt"
if grep -q '"autohide": true' ~/.config/ml4w-statusbar/config.json 2>/dev/null; then
    BAR_HIDE="Bật"
fi

OPTIONS="1. 🎨 Màu chủ đạo hệ thống (Accent Color: Trắng, Xanh, Tím, Đỏ...)
2. 🌙 Ánh sáng xanh / Đêm (Night Light: 4500K / Tùy chỉnh) [${NL_STATUS}]
3. 🖥️ Màn hình, Tần số quét & Bố cục đa màn (Displays / Hz / Position)
4. 🎭 Kiểu giao diện & Hiệu ứng (Themes: Glass / Modern / Transparent)
5. 🖼️ Hình nền máy tính (Wallpaper Selector)
6. 🖌️ Font chữ, Icon & Con trỏ chuột (Nwg-Look / GTK Settings)
7. ⚙️ Tự động ẩn thanh Dock dưới [${DOCK_HIDE}]
8. 📊 Tự động ẩn thanh Statusbar trên [${BAR_HIDE}]
9. ⌨️ Danh sách toàn bộ phím tắt hệ thống (Keybindings Cheat Sheet)
10. 🔄 Khởi động lại thanh điều khiển (Restart Bars)"

CHOSEN=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "⚙️ Cài đặt hệ thống (KDE-Style Control Center):" -lines 10 2>/dev/null || \
         echo -e "$OPTIONS" | wofi --dmenu --prompt "⚙️ Cài đặt hệ thống:")

[ -z "$CHOSEN" ] && exit 0

case "$CHOSEN" in
    *Màu\ chủ\ đạo*)
        ~/.config/hypr/scripts/set-accent-color.sh &
        ;;
    *Ánh\ sáng\ xanh*)
        ~/.config/hypr/scripts/set-nightlight.sh &
        ;;
    *Màn\ hình*)
        ~/.local/bin/nwg-displays &
        ;;
    *Kiểu\ giao\ diện*)
        ~/.config/ml4w/themes/themes.sh &
        ;;
    *Hình\ nền*)
        ~/.config/ml4w/scripts/ml4w-wallpaper-app &
        ;;
    *Font\ chữ*)
        nwg-look &
        ;;
    *Dock\ dưới*)
        ~/.config/ml4w/scripts/ml4w-toggle-dock-autohide
        notify-send "⚙️ Dock" "Đã chuyển đổi trạng thái tự động ẩn Dock" -t 1500 2>/dev/null || true
        ;;
    *Statusbar\ trên*)
        ~/.config/ml4w/scripts/ml4w-toggle-statusbar-autohide
        notify-send "📊 Statusbar" "Đã chuyển đổi trạng thái tự động ẩn Statusbar" -t 1500 2>/dev/null || true
        ;;
    *phím\ tắt*)
        ~/.config/hypr/scripts/keybindings.sh &
        ;;
    *Khởi\ động\ lại*)
        ~/.config/hypr/scripts/restart-bars.sh
        notify-send "🔄 Quickshell" "Đã khởi động lại toàn bộ giao diện thanh trên và dưới" -t 1500 2>/dev/null || true
        ;;
esac
