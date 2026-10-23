-- -----------------------------------------------------
-- General window decoration
-- name: "Default (All Blur)"
-- -----------------------------------------------------

hl.config({
    decoration = {
        rounding = 10,
        active_opacity = 0.9,
        inactive_opacity = 0.8,
        fullscreen_opacity = 0.95,
        rounding_power = 2,

        shadow = {
            enabled = true,
            range = 32,
            render_power = 2,
            color = "rgba(00000050)",
        },

        blur = {
            enabled   = true,
            size      = 6,
            passes    = 3,
            new_optimizations = true,
            ignore_opacity = true,
            xray = false,
            vibrancy  = 0.1696,
        },
    },
})

-- Layer rules for Waybar blur
hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
