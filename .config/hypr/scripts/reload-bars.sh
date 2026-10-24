#!/usr/bin/env bash
# Khởi động lại toàn bộ giao diện MacShell
killall -9 qs 2>/dev/null || true
pkill -f macshell-start 2>/dev/null || true
sleep 0.5
nohup sh ~/.local/bin/macshell-start >/dev/null 2>&1 &
