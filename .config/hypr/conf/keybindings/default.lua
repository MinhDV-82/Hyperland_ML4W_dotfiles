-- -----------------------------------------------------
-- Keybindings Config (KDE Plasma & Windows Friendly)
-- -----------------------------------------------------

local mainMod = "SUPER" -- Phím Windows / Super

-- =====================================================
-- 1. MỞ ỨNG DỤNG (KDE Style)
-- =====================================================
-- Mở Dolphin (File Manager chuẩn KDE)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin || ~/.config/ml4w/settings/filemanager"), { description = "Open File Manager (Dolphin)" })
-- Mở Settings (Win + I: Mở ML4W Settings / Cài đặt giao diện)
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("~/.config/hypr/scripts/open-settings.sh"), { description = "Open Settings (Win + I)" })
-- Mở Terminal (Super + Enter hoặc Ctrl + Alt + T giống thông lệ)
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("~/.config/ml4w/settings/terminal.sh"), { description = "Open Terminal" })
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd("~/.config/ml4w/settings/terminal.sh"), { description = "Open Terminal (Linux Standard)" })
-- Mở Browser
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("~/.config/ml4w/settings/browser.sh"), { description = "Open Browser" })
-- Mở Máy tính (Calculator)
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("~/.config/ml4w/settings/calculator.sh"), { description = "Open Calculator" })
-- App Launcher (Super riêng / Super + Space / Alt + F2 giống KRunner)
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-launcher"), { description = "Open App Launcher" })
hl.bind("ALT + F2", hl.dsp.exec_cmd("krunner || ~/.config/ml4w/scripts/ml4w-launcher"), { description = "KRunner / App Launcher" })
hl.bind(mainMod .. " + CTRL + RETURN", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-launcher"), { description = "Open App Launcher" })
-- Task Manager / System Monitor (Ctrl + Shift + Esc giống Windows/KDE)
hl.bind("CTRL + SHIFT + ESCAPE", hl.dsp.exec_cmd("plasma-systemmonitor || btop || ~/.config/ml4w/settings/system-monitor.sh"), { description = "Task Manager / System Monitor" })

-- =====================================================
-- 2. QUẢN LÝ CỬA SỔ (KDE & Windows Shortcuts)
-- =====================================================
-- Đóng cửa sổ: Alt + F4 hoặc Super + Q
hl.bind("ALT + F4", hl.dsp.exec_cmd("~/.config/hypr/scripts/killactive.sh"), { description = "Close active window (Alt+F4)" })
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("~/.config/hypr/scripts/killactive.sh"), { description = "Close active window (Super+Q)" })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"), { description = "Force kill active window" })

-- Phóng to / Cực đại hóa (Maximize): Super + M hoặc Super + Mũi tên lên (Windows snap style)
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), { description = "Toggle Maximize" })
hl.bind(mainMod .. " + up", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), { description = "Maximize Window (Win + Up)" })

-- Toàn màn hình (Fullscreen F11): F11 hoặc Super + F
hl.bind("F11", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Fullscreen (F11)" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Fullscreen (Super+F)" })

-- Ẩn / Minimize cửa sổ: Super + Mũi tên xuống (giống Windows/KDE)
hl.bind(mainMod .. " + down", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-minimize.sh"), { description = "Minimize Window (Win + Down)" })
-- Mở lại danh sách cửa sổ đã minimize / scratchpad: Super + Shift + Down
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.workspace.toggle_special("minimized"), { description = "Show Minimized Windows" })
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-desktop.sh"), { description = "Show/Hide Minimized (Win + D)" })
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.workspace.toggle_special("minimized"), { description = "Restore Minimized Windows (Win + Shift + M)" })

-- Cửa sổ nổi (Floating toggle): Super + T
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle Floating Window" })
hl.bind(mainMod .. " + ALT + T", function() hl.dispatch(hl.dsp.window.float({ action = "toggle" })); hl.dispatch(hl.dsp.window.pin()) end, { description = "Toggle Float + Pin on top" })

-- Chuyển qua lại giữa các cửa sổ: Alt + Tab (chuẩn) & Super + Tab
hl.bind("ALT + Tab", hl.dsp.focus({ direction = "right" }), { description = "Switch window (Alt+Tab)" })
hl.bind("ALT + SHIFT + Tab", hl.dsp.focus({ direction = "left" }), { description = "Switch window back (Alt+Shift+Tab)" })
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("qs -p ~/.local/share/quickshell-overview ipc call overview toggle"), { description = "Overview / Task Switcher" })
-- Lôi 1 cửa sổ đang mở ở workspace khác về đặt cạnh cửa sổ hiện tại (Win + A)
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("~/.config/hypr/scripts/bring-window.sh"), { description = "Bring/Attach open window here (Win + A)" })

-- Di chuyển con trỏ focus: Super + Left / Right
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }), { description = "Move focus left" })
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Move focus right" })

-- =====================================================
-- 3. HỆ THỐNG, KHÓA MÁN HÌNH, CLIPBOARD
-- =====================================================
-- Khóa màn hình: Super + L (Chuẩn Windows & KDE)
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-power -l"), { description = "Lock Screen (Win + L)" })
-- Clipboard History: Super + V (Chuẩn Windows 10/11 & KDE Klipper)
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-cliphist"), { description = "Clipboard History (Win + V)" })
-- Emoji Picker: Super + . hoặc Super + ; (Chuẩn Windows/KDE)
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("~/.config/ml4w/settings/emojipicker.sh"), { description = "Emoji Picker (Win + .)" })
hl.bind(mainMod .. " + semicolon", hl.dsp.exec_cmd("~/.config/ml4w/settings/emojipicker.sh"), { description = "Emoji Picker (Win + ;)" })

-- Chụp màn hình (Screenshot): Chụp 1 chạm siêu nhanh, lưu & copy vào Clipboard
hl.bind("PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/quick-screenshot.sh"), { description = "Quick Screenshot Area (PrintScreen)" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/quick-screenshot.sh"), { description = "Quick Screenshot Snipping (Win + Shift + S)" })
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/quick-screenshot.sh"), { description = "Quick Screenshot Area (Shift + PrintScreen)" })
hl.bind("ALT + PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/quick-fullscreen.sh"), { description = "Quick Fullscreen Screenshot (Alt + PrintScreen)" })
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("~/.config/hypr/scripts/quick-fullscreen.sh"), { description = "Quick Fullscreen Screenshot (Win + PrintScreen)" })

-- =====================================================
-- 4. ĐIỀU KHIỂN MÀN HÌNH (Multi-monitor)
-- =====================================================
-- Win + P: Hiện Menu chọn màn hình trực quan (hoặc Super+Shift+P để xoay vòng)
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/display-menu.sh"), { description = "Display Project Menu (Win + P)" })
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/display-switch.sh"), { description = "Cycle Display Mode (Win + Shift + P)" })

-- =====================================================
-- 5. WORKSPACE (DESKTOP ẢO)
-- =====================================================
-- Chuyển workspace: Super + 1 -> 9, 0
for i = 1, 10 do
    local key = (i % 10)
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Focus workspace " .. i })
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
end

-- Chuyển Desktop ảo qua lại: Ctrl + Super + Left / Right (KDE standard)
hl.bind("CTRL + " .. mainMod .. " + left", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous Virtual Desktop" })
hl.bind("CTRL + " .. mainMod .. " + right", hl.dsp.focus({ workspace = "e+1" }), { description = "Next Virtual Desktop" })
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace (Wheel)" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace (Wheel)" })

-- =====================================================
-- 6. RESIZE VÀ DI CHUYỂN BẰNG CHUỘT / BÀN PHÍM
-- =====================================================
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window with mouse" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window with right click" })

-- Chế độ Resize bằng bàn phím (Super + R)
hl.define_submap("resize", function()
    hl.bind("right",  hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }), { repeating = true, description = "Tăng ngang" })
    hl.bind("left",   hl.dsp.window.resize({ x = -50, y = 0,   relative = true }), { repeating = true, description = "Giảm ngang" })
    hl.bind("up",     hl.dsp.window.resize({ x = 0,   y = -50, relative = true }), { repeating = true, description = "Giảm dọc" })
    hl.bind("down",   hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }), { repeating = true, description = "Tăng dọc" })
    hl.bind("escape", hl.dsp.submap("reset"), { description = "Thoát" })
    hl.bind("return", hl.dsp.submap("reset"), { description = "Thoát" })
end)
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"), { description = "Vào chế độ Resize" })

-- =====================================================
-- 7. TIỆN ÍCH ML4W, STATUSBAR & MULTIMEDIA
-- =====================================================
hl.bind(mainMod .. " + CTRL + K", hl.dsp.exec_cmd("~/.config/hypr/scripts/keybindings.sh"), { description = "Show keybindings list" })
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/loadconfig.sh"), { description = "Reload Hyprland Config" })
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-app --random"), { description = "Random Wallpaper" })
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-app"), { description = "Wallpaper Selector" })
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-toggle-theme"), { description = "Toggle Dark/Light Mode" })
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-toggle-statusbar"), { description = "Toggle Status Bar" })
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd("ml4w-powermenu toggle"), { description = "Power Menu" })
-- Logout / Thoát nhanh ra màn hình đăng nhập (Super + Shift + E hoặc Ctrl + Alt + Del)
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("hyprctl dispatch exit"), { description = "Logout Hyprland" })
hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd("ml4w-powermenu toggle"), { description = "Power Menu / Logout" })

-- Phím Volume & Brightness trên bàn phím Laptop
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true, description = "Volume Up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true, description = "Volume Down" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true, description = "Mute Audio" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true, description = "Mute Mic" })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true, description = "Brightness Up" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true, description = "Brightness Down" })

-- Phím Media
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true, description = "Next" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Pause" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Play" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true, description = "Prev" })

-- Bắt phím SUPER riêng lẻ khi bấm nhả (release) để mở/tắt Launcher
hl.bind("SUPER_L", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-launcher.sh"), {
    release = true,
    description = "Toggle App Launcher on Super tap"
})
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-launcher.sh"), {
    release = true,
    description = "Toggle App Launcher on Super tap"
})

-- Phím tắt Start Menu nhanh giống KDE: Super + Space hoặc Alt + F1
hl.bind("ALT + F1", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-launcher.sh"), { description = "Start Menu (Alt+F1 KDE)" })