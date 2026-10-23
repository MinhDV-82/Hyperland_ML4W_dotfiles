#!/usr/bin/env bash
export PATH="$HOME/.local/bin:$PATH"
killall -9 qs 2>/dev/null || true
sleep 0.5
qs >/tmp/qs_out.log 2>&1 &
ml4w-dock start >/tmp/dock_out.log 2>&1 &
ml4w-powermenu start >/tmp/pm_out.log 2>&1 &
PROFILE="com.ml4w.dotfiles" qs -p "$HOME/.local/share/ml4w-dotfiles-settings/quickshell" >/dev/null 2>&1 &
qs -p "$HOME/.local/share/quickshell-overview" >/dev/null 2>&1 &
