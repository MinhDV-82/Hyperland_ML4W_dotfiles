# Hyprland ML4W Dotfiles (Customized by MinhDV-82)

Cấu hình tùy biến cá nhân cho **Hyprland** dựa trên nền tảng **ML4W Dotfiles**, tối ưu hóa giao diện và trải nghiệm làm việc thân thiện theo phong cách kết hợp giữa **KDE Plasma & Windows**.

---

## ✨ Điểm nổi bật & Tùy biến

1. **Bảng màu Toàn diện (Monochrome White & Global Accent Support):**
   - Hỗ trợ đổi màu chủ đạo (Accent Color) toàn hệ thống nhanh chóng bằng `Win + I`.
   - Cơ chế thông minh với màu **Trắng Tuyết / Bạc Bạch Kim (`#FFFFFF` / `#F8FAFC`)**: Sử dụng thuật toán `scheme-monochrome` giúp viền cửa sổ focus, Quickshell Statusbar, Dock và Rofi Launcher giữ chuẩn màu trắng tinh khôi tương phản chữ đen, khắc phục triệt để lỗi fallback ngả màu xanh ngọc của Material You.
   - Hỗ trợ đầy đủ các dải màu khác (`scheme-fidelity`) cho Tím, Xanh dương, Xanh lá, Đỏ, Cam...

2. **Phím tắt Thông minh & Trực quan (KDE / Windows Style):**
   - `Super` / `Super + Space` / `Alt + F2`: Bật ngay cửa sổ tìm kiếm ứng dụng (Rofi Drun / KRunner).
   - `Win + E`: Mở trình quản lý tệp Dolphin.
   - `Win + I`: Mở bảng Menu Cài đặt & Tiện ích cá nhân hóa.
   - `Win + Return` hoặc `Ctrl + Alt + T`: Mở Terminal.
   - `Alt + F4` / `Win + Q`: Đóng cửa sổ đang chọn.
   - `Ctrl + Shift + Esc`: Mở trình theo dõi hệ thống (System Monitor / Task Manager).
   - `Win + Left/Right/Up/Down`: Snap chia nửa màn hình tiện lợi.

3. **Tối ưu Hiệu ứng (Snappy Animations):**
   - Tinh chỉnh tốc độ đóng mở của Launcher và các lớp Menu (`layersOut: 1.2`, `layersIn: 2.5`), giúp giao diện phản hồi chớp nhoáng, không có độ trễ thừa.
   - Tắt hiệu ứng cuộn trượt chuyển Workspace để tối đa hóa hiệu suất làm việc.

---

## 🛠️ Cấu trúc thư mục

- `.config/hypr/`: Toàn bộ cấu hình Hyprland, Keybindings, Rules, Window Decorations & Animations.
- `.config/quickshell/`: Thanh Statusbar trên cùng tùy biến.
- `.config/rofi/`: Giao diện tìm kiếm ứng dụng Rofi đã đồng bộ bảng màu.
- `.config/matugen/`: Bộ quy tắc và template sinh bảng màu tự động.
- `.config/ml4w/`: Các scripts điều khiển hệ thống, wallpaper và theme.
- `.config/kitty/`, `waybar/`, `swaync/`, `walker/`...
