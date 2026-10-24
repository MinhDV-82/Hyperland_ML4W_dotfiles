hl.on("hyprland.start", function ()
    local HOME = os.getenv("HOME")

    -- Read wallpaper app setting
    local wallpaper_app = "quickshell"
    local f = io.open(HOME .. "/.config/ml4w/settings/wallpaper-app", "r")
    if f then
        wallpaper_app = f:read("*l"):match("^%s*(.-)%s*$")
        f:close()
    end

    -- Export variables to systemd
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Restart portals so they catch the environment
    hl.exec_cmd("systemctl --user stop xdg-desktop-portal xdg-desktop-portal-hyprland")
    hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland xdg-desktop-portal")

    -- awww daemon
    hl.exec_cmd("awww-daemon")

    -- Load cursor
    hl.exec_cmd("hyprctl setcursor WhiteSur-cursors 24")

    -- Start listeners
    hl.exec_cmd("~/.config/ml4w/listeners.sh --startall")

    -- Start waybar (disabled: replaced by MacShell)
    -- hl.exec_cmd(HOME .. "/.config/waybar/launch.sh")

    -- Start polkit agent
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service 2>/dev/null || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || true")

    -- Restore wallpaper
    hl.exec_cmd("awww restore 2>/dev/null || true")

    -- ML4W default autostart (disabled: replaced by MacShell)
    -- hl.exec_cmd("~/.config/ml4w/scripts/ml4w-autostart > /dev/null 2>&1")

    -- Load GTK settings
    hl.exec_cmd("~/.config/hypr/scripts/gtk.sh")

    -- Start swaync (disabled: replaced by MacShell notification center)
    -- hl.exec_cmd("[ -f ~/.config/ml4w/.swaync-dbus-activated ] || swaync")

    -- Start hypridle
    hl.exec_cmd("hypridle")

    -- Load cliphist history
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- Start autostart cleanup
    hl.exec_cmd("~/.config/hypr/scripts/cleanup.sh")

    -- Vietnamese input method (fcitx5 + Unikey)
    hl.exec_cmd("pkill fcitx5; sleep 0.5 && fcitx5 -d --replace")

    -- Load Night Light preference
    hl.exec_cmd("~/.config/hypr/scripts/load-nightlight.sh")
end)
