hl.on("hyprland.start", function ()
    local HOME = os.getenv("HOME")

    -- Export variables to systemd
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Restart portals so they catch the environment
    hl.exec_cmd("systemctl --user stop xdg-desktop-portal xdg-desktop-portal-hyprland")
    hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland xdg-desktop-portal")

    -- awww daemon
    hl.exec_cmd("awww-daemon")

    -- Load cursor
    hl.exec_cmd("hyprctl setcursor WhiteSur-cursors 24")

    -- Start polkit authentication agent
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service 2>/dev/null || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || true")

    -- Restore wallpaper or set default
    hl.exec_cmd("awww restore 2>/dev/null || awww img ~/Pictures/Wallpapers/default.jpg 2>/dev/null || true")

    -- Load GTK settings
    hl.exec_cmd("~/.config/hypr/scripts/gtk.sh")

    -- Start hypridle
    hl.exec_cmd("hypridle")

    -- Load cliphist history
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- Start autostart cleanup
    hl.exec_cmd("~/.config/hypr/scripts/cleanup.sh")

    -- Vietnamese input method (fcitx5 + Unikey)
    hl.exec_cmd("pkill fcitx5; sleep 0.5 && fcitx5 -d --replace")

    -- Load Night Light preference (hyprsunset 4500K)
    hl.exec_cmd("~/.config/hypr/scripts/load-nightlight.sh")
end)
