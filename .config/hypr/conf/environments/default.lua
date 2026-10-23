-- -----------------------------------------------------
-- Environment Variables for Hyprland (ML4W)
-- Vietnamese input (fcitx5 + Unikey) + Wayland compat
-- -----------------------------------------------------

-- GTK apps use fcitx5
hl.env("GTK_IM_MODULE", "fcitx")
-- Qt apps use fcitx5
hl.env("QT_IM_MODULE", "fcitx")
-- X11 apps (XWayland) use fcitx5
hl.env("XMODIFIERS", "@im=fcitx")
-- SDL2 games
hl.env("SDL_IM_MODULE", "fcitx")
-- Wayland input method
hl.env("INPUT_METHOD", "fcitx")
-- Clutter (older GTK apps)
hl.env("CLUTTER_IM_MODULE", "fcitx")

-- Qt Wayland platform
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Firefox Wayland native
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Electron apps Wayland (VS Code, etc.)
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

