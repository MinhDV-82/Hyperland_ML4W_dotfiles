#!/usr/bin/env bash
# Khởi động lại toàn bộ Quickshell (Statusbar trên & Dock dưới)
killall qs 2>/dev/null || true
sleep 0.5

# Khởi chạy lại Quickshell chính (Thanh status bar trên, sidebar, v.v.)
qs &
disown

# Khởi chạy lại Dock (Thanh dock dưới)
qs -n -p ~/.local/share/ml4w-dock &
disown

# Khởi chạy powermenu
qs -n -p ~/.local/share/ml4w-powermenu &
disown

# Khởi chạy overview
qs -p ~/.local/share/quickshell-overview &
disown

# Khởi chạy settings
qs -p ~/.local/share/ml4w-dotfiles-settings/quickshell &
disown
