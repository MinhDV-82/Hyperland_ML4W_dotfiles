#!/usr/bin/env bash
# Win+P display switcher cho Hyprland Lua Config
# 1. Menu chọn trực tiếp nếu dùng Rofi / Wofi
# 2. Hoặc xoay vòng nếu bấm phím tắt

LAPTOP="eDP-1"
HDMI="HDMI-A-1"
STATE_FILE="/tmp/hypr-display-mode"

apply_mode() {
    local mode="$1"
    case "$mode" in
        "laptop")
            # Chỉ màn Laptop
            hyprctl eval "hl.monitor({ output = '$HDMI', disabled = true })"
            hyprctl eval "hl.monitor({ output = '$LAPTOP', mode = 'preferred', position = '0x0', scale = 1, disabled = false })"
            echo "laptop" > "$STATE_FILE"
            notify-send "🖥️ Display Mode" "💻 Chỉ màn hình Laptop ($LAPTOP)" -i video-display -t 2500 2>/dev/null || true
            ;;
        "hdmi")
            # Chỉ màn HDMI (LG UltraGear)
            hyprctl eval "hl.monitor({ output = '$LAPTOP', disabled = true })"
            hyprctl eval "hl.monitor({ output = '$HDMI', mode = 'preferred', position = '0x0', scale = 1, disabled = false })"
            echo "hdmi" > "$STATE_FILE"
            notify-send "🖥️ Display Mode" "🖥️ Chỉ màn hình Ngoài ($HDMI)" -i video-display -t 2500 2>/dev/null || true
            ;;
        "mirror")
            # Nhân đôi (Mirror)
            hyprctl eval "hl.monitor({ output = '$LAPTOP', mode = '1920x1080@144', position = '0x0', scale = 1, disabled = false })"
            hyprctl eval "hl.monitor({ output = '$HDMI', mode = '1920x1080@144', position = '0x0', scale = 1, mirror = '$LAPTOP', disabled = false })"
            echo "mirror" > "$STATE_FILE"
            notify-send "🖥️ Display Mode" "👥 Nhân đôi màn hình (Mirror)" -i video-display -t 2500 2>/dev/null || true
            ;;
        "extend"|*)
            # Mở rộng (Cả 2 màn hình)
            hyprctl eval "hl.monitor({ output = '$LAPTOP', mode = 'preferred', position = '0x0', scale = 1, disabled = false })"
            hyprctl eval "hl.monitor({ output = '$HDMI', mode = 'preferred', position = '1920x0', scale = 1, disabled = false })"
            echo "extend" > "$STATE_FILE"
            notify-send "🖥️ Display Mode" "🖥️➕💻 Mở rộng cả 2 màn hình (Extend)" -i video-display -t 2500 2>/dev/null || true
            ;;
    esac

    # Tự động reload lại Quickshell (thanh Navbar trên & Dock dưới) để dính sang màn hình mới
    (sleep 0.8 && ~/.config/hypr/scripts/reload-bars.sh) &
}

# Nếu có tham số dòng lệnh truyền vào (ví dụ: display-switch.sh laptop)
if [ -n "$1" ]; then
    apply_mode "$1"
    exit 0
fi

# Nếu bấm Win + P: xoay vòng trạng thái
CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "extend")

case "$CURRENT" in
    "extend")
        apply_mode "laptop"
        ;;
    "laptop")
        apply_mode "hdmi"
        ;;
    "hdmi")
        apply_mode "mirror"
        ;;
    "mirror"|*)
        apply_mode "extend"
        ;;
esac
