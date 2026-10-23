-- -----------------------------------------------------
-- Window Rules
-- -----------------------------------------------------

-- Tự động đưa các ứng dụng máy ảo (VirtualBox, QEMU/Virt-manager, VMware) về dạng Floating cửa sổ nổi tự do
hl.window_rule({
    name = "vm-floating-vbox",
    match = { class = "VirtualBox.*" },
    float = true,
})

hl.window_rule({
    name = "vm-floating-virtmgr",
    match = { class = "virt-manager" },
    float = true,
})

hl.window_rule({
    name = "vm-floating-qemu",
    match = { class = "qemu.*" },
    float = true,
})

hl.window_rule({
    name = "vm-floating-vmware",
    match = { class = "vmware.*" },
    float = true,
})

-- Mặc định mở một số ứng dụng tiện ích dạng nổi
hl.window_rule({
    name = "utility-floating",
    match = { class = "org.kde.kcalc|pavucontrol|blueman-manager|nwg-look" },
    float = true,
})

-- Luật cửa sổ nổi riêng cho tất cả máy ảo Android (Android Studio Emulator, Waydroid, Genymotion, Scrcpy)
hl.window_rule({
    name = "android-emulator-floating",
    match = { class = ".*(emulator|Emulator|qemu-system-x86_64|Genymotion|scrcpy|Waydroid|waydroid).*" },
    float = true,
})

hl.window_rule({
    name = "android-emulator-title",
    match = { title = ".*(Android Emulator|Emulator|Genymotion|scrcpy).*" },
    float = true,
})

-- Hiệu ứng đóng mở tức thì cho Rofi Launcher
hl.layer_rule({ match = { namespace = "rofi" }, noanim = false })
