-- -----------------------------------------------------
-- Animations (Fast, Snappy & Instant Launcher Close)
-- -----------------------------------------------------

hl.config({
    animations = {
        enabled = true,
    }
})

hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("fast_decel", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.0} } })
hl.curve("fast_accel", { type = "bezier", points = { {0.3, 0}, {0.8, 0.15} } })

-- Cửa sổ mở và đóng cực nhanh (speed 2 / 1.5)
hl.animation({ leaf = "windows", enabled = true, speed = 2.5, bezier = "fast_decel", style = "popin 80%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.5, bezier = "fast_decel", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "fast_accel", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "fast_decel" })

-- Menu & Layers (Rofi Launcher, Overview, Bars): Đóng mở chớp nhoáng (speed 1.5 - 2)
hl.animation({ leaf = "layersIn", enabled = true, speed = 2.5, bezier = "fast_decel", style = "popin 80%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.2, bezier = "fast_accel", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2.5, bezier = "fast_decel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.2, bezier = "fast_accel" })

-- WORKSPACE: Chuyển ngay lập tức (không trượt màn hình)
hl.animation({ leaf = "workspaces", enabled = false })
hl.animation({ leaf = "specialWorkspace", enabled = false })
