#!/usr/bin/env bash
export PATH="$HOME/.local/bin:$PATH"

# 1. Giữ chuẩn 1 màn hình duy nhất (HDMI-A-1 active, eDP-1 disabled)
hyprctl keyword monitor "HDMI-A-1,1920x1080@144,0x0,1" 2>/dev/null || true
hyprctl keyword monitor "eDP-1,disable" 2>/dev/null || true

# 2. Khởi chạy hình nền bằng awww
killall awww-daemon 2>/dev/null || true
rm -f /run/user/1000/*awww* 2>/dev/null || true
awww-daemon &
sleep 0.5
awww restore 2>/dev/null || true

# 3. Khởi động lại giao diện MacShell
killall -9 qs 2>/dev/null || true
pkill -f macshell-start 2>/dev/null || true
sleep 0.3
nohup sh ~/.local/bin/macshell-start >/dev/null 2>&1 &
