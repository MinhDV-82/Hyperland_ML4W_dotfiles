#!/usr/bin/env bash
# Menu cài đặt hệ thống tích hợp
OPTIONS="1. 🎨 Đổi Màu Chủ Đạo Hệ Thống (Accent Color)\n2. 🌙 Bật/Tắt Lọc Ánh Sáng Xanh (Night Light)\n3. 🎭 Đổi Kiểu Giao Diện ML4W (Glass / Modern / Transparent)\n4. 🖼️ Đổi Hình Nền (Wallpaper)\n5. 🖥️ Màn hình & Tần số quét (Displays / Hz)\n6. 🖌️ Chỉnh Icon, Cursor chuột & Font (Nwg-Look)\n7. ⚙️ Bật/Tắt Tự động ẩn thanh Dock dưới\n8. 📊 Bật/Tắt Tự động ẩn thanh Statusbar trên\n9. ⌨️ Xem danh sách phím tắt hệ thống\n10. 🔄 Khởi động lại thanh điều khiển (Reload Bars)"

CHOSEN=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "⚙️ Cài đặt hệ thống (Settings):" -lines 10 2>/dev/null || \
         echo -e "$OPTIONS" | wofi --dmenu --prompt "⚙️ Cài đặt hệ thống:")

case "$CHOSEN" in
    *Màu\ Chủ\ Đạo*)
        ~/.config/hypr/scripts/set-accent-color.sh &
        ;;
    *Ánh\ Sáng\ Xanh*|*Night\ Light*)
        ~/.config/hypr/scripts/toggle-nightlight.sh &
        ;;
    *Kiểu\ Giao\ Diện*)
        ~/.config/ml4w/themes/themes.sh &
        ;;
    *Hình\ Nền*)
        ~/.config/ml4w/scripts/ml4w-wallpaper-app &
        ;;
    *Màn\ hình*|*Displays*|*Hz*)
        ~/.local/bin/nwg-displays &
        ;;
    *Icon*|*Cursor*)
        nwg-look &
        ;;
    *Dock*)
        ~/.config/ml4w/scripts/ml4w-toggle-dock-autohide
        ;;
    *Statusbar*)
        ~/.config/ml4w/scripts/ml4w-toggle-statusbar-autohide
        ;;
    *phím\ tắt*)
        ~/.config/hypr/scripts/keybindings.sh &
        ;;
    *Khởi\ động*)
        ~/.config/hypr/scripts/reload-bars.sh
        ;;
esac
