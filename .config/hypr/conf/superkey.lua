-- Bắt phím SUPER riêng lẻ khi bấm nhả (release)
hl.bind("SUPER_L", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-launcher.sh"), {
    release = true,
    description = "Toggle App Launcher on Super tap"
})
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-launcher.sh"), {
    release = true,
    description = "Toggle App Launcher on Super tap"
})
