-- -----------------------------------------------------
-- Window Gaps & Padding (KDE / Windows Style: Không khoảng trống dư thừa)
-- -----------------------------------------------------

hl.config({
    general = {
        gaps_in  = 2,  -- Khoảng cách giữa các cửa sổ kề nhau (giảm từ 10 xuống 2px)
        gaps_out = 0,  -- Khoảng cách đệm viền màn hình (padding viền ngoài = 0px để sát mép)
        border_size = 1, -- Đường viền mảnh gọn gàng
        col = {
            active_border   = { colors = {primary, on_primary}, angle = 90 },
            inactive_border = on_primary,
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    }
})
