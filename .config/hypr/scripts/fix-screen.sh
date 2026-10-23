#!/usr/bin/env bash
export PATH="$HOME/.local/bin:$PATH"

# 1. Bật hiển thị màn hình
hyprctl monitors all

# 2. Khởi chạy hình nền bằng awww
killall awww-daemon 2>/dev/null || true
rm -f /run/user/1000/*awww* 2>/dev/null || true
awww-daemon &
sleep 0.5
WALLPAPER=$(cat ~/.cache/ml4w/hyprland-dotfiles/current_wallpaper 2>/dev/null || echo ~/.config/ml4w/wallpapers/default.jpg)
awww load "$WALLPAPER" 2>/dev/null || true

# 3. Chạy Statusbar & Dock luôn hiển thị (tắt autohide tạm thời để bạn thấy ngay)
mkdir -p ~/.config/ml4w-statusbar ~/.config/ml4w-dock
echo '{"bar":{"autohide":false,"enabled":true}}' > ~/.config/ml4w-statusbar/config.json
echo '{"dock":{"autohide":false}}' > ~/.config/ml4w-dock/config.json

# 4. Khởi động lại toàn bộ Quickshell UI
killall qs 2>/dev/null || true
sleep 0.3
qs >/tmp/qs.log 2>&1 &
ml4w-dock start >/tmp/dock.log 2>&1 &
ml4w-powermenu start >/tmp/pm.log 2>&1 &

