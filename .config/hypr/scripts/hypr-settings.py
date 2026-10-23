#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Hyprland System Settings (Trung tâm Cài đặt Hệ thống)
Built with GTK4 and Libadwaita for ML4W / Hyprland on Fedora.
"""

import os
import sys
import json
import subprocess
import threading
import gi

gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')
from gi.repository import Gtk, Adw, GLib, Gio, Pango

HOME = os.path.expanduser("~")
NIGHTLIGHT_CONF = os.path.join(HOME, ".config/hypr/nightlight.json")
DOCK_CONF = os.path.join(HOME, ".config/ml4w-dock/config.json")
STATUSBAR_CONF = os.path.join(HOME, ".config/ml4w-statusbar/config.json")
MONITORS_CONF = os.path.join(HOME, ".config/hypr/monitors.conf")
MONITORS_LUA = os.path.join(HOME, ".config/hypr/monitors.lua")

def run_cmd(cmd, async_run=True):
    """Run shell command"""
    if async_run:
        threading.Thread(target=lambda: subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL), daemon=True).start()
    else:
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        return res.stdout.strip()

def notify(title, msg):
    run_cmd(f"notify-send '{title}' '{msg}' -t 2000 2>/dev/null || true")

class SettingsWindow(Adw.PreferencesWindow):
    def __init__(self, app):
        super().__init__(application=app)
        self.set_title("Cài đặt hệ thống (Hyprland Settings)")
        self.set_default_size(920, 680)

        # Debounce timer for slider
        self.nightlight_debounce_timer = None

        # Build Pages
        self.build_nightlight_page()
        self.build_display_page()
        self.build_appearance_page()
        self.build_wallpaper_page()
        self.build_panels_page()
        self.build_shortcuts_page()
        self.build_info_page()

    # -------------------------------------------------------------
    # TAB 1: Ánh sáng xanh (Night Light)
    # -------------------------------------------------------------
    def build_nightlight_page(self):
        page = Adw.PreferencesPage()
        page.set_title("Ánh sáng xanh")
        page.set_icon_name("weather-clear-night-symbolic")

        # Load Night Light state
        nl_state = {"enabled": True, "temperature": 4500}
        if os.path.exists(NIGHTLIGHT_CONF):
            try:
                with open(NIGHTLIGHT_CONF, "r") as f:
                    nl_state.update(json.load(f))
            except Exception:
                pass

        # Check running process
        is_running = (subprocess.run("pgrep -x hyprsunset", shell=True).returncode == 0)
        if not is_running and nl_state.get("enabled"):
            # If enabled in config but not running, start it
            self.apply_nightlight(nl_state["temperature"])
            is_running = True

        # Group 1: Switch
        grp_toggle = Adw.PreferencesGroup()
        grp_toggle.set_title("Chế độ bảo vệ mắt (Night Light)")
        grp_toggle.set_description("Lọc ánh sáng xanh màn hình giúp giảm mỏi mắt và dễ ngủ hơn khi làm việc ban đêm.")

        self.sw_nightlight = Adw.SwitchRow()
        self.sw_nightlight.set_title("Kích hoạt ánh sáng xanh")
        self.sw_nightlight.set_subtitle("Điều chỉnh nhiệt độ màu của toàn bộ màn hình")
        self.sw_nightlight.set_active(is_running)
        self.sw_nightlight.connect("notify::active", self.on_nightlight_toggled)
        grp_toggle.add(self.sw_nightlight)
        page.add(grp_toggle)

        # Group 2: Slider & Presets
        grp_temp = Adw.PreferencesGroup()
        grp_temp.set_title("Nhiệt độ màu (Color Temperature)")
        grp_temp.set_description("Kéo thanh trượt để chỉnh tông màu theo ý muốn (Kelvin). Giá trị càng nhỏ màn hình càng ấm.")

        # Slider Row
        self.row_slider = Adw.ActionRow()
        cur_temp = int(nl_state.get("temperature", 4500))
        self.temp_label = Gtk.Label(label=f"{cur_temp} K")
        self.temp_label.set_css_classes(["title-2", "accent"])
        self.update_temp_description(cur_temp)

        # Scale slider (2500K to 6500K)
        adj = Gtk.Adjustment(value=cur_temp, lower=2500, upper=6500, step_increment=50, page_increment=250)
        self.scale = Gtk.Scale(orientation=Gtk.Orientation.HORIZONTAL, adjustment=adj)
        self.scale.set_hexpand(True)
        self.scale.set_draw_value(False)
        self.scale.add_mark(3500, Gtk.PositionType.BOTTOM, "3500K")
        self.scale.add_mark(4500, Gtk.PositionType.BOTTOM, "4500K (Chuẩn)")
        self.scale.add_mark(5500, Gtk.PositionType.BOTTOM, "5500K")
        self.scale.add_mark(6500, Gtk.PositionType.BOTTOM, "6500K (Tắt)")
        self.scale.connect("value-changed", self.on_slider_changed)

        box_slider = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        box_slider.set_margin_top(12)
        box_slider.set_margin_bottom(12)
        box_slider.set_margin_start(12)
        box_slider.set_margin_end(12)

        header_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        lbl_cur = Gtk.Label(label="Mức nhiệt độ hiện tại:")
        lbl_cur.set_hexpand(True)
        lbl_cur.set_xalign(0)
        header_box.append(lbl_cur)
        header_box.append(self.temp_label)

        box_slider.append(header_box)
        box_slider.append(self.scale)

        # Presets Buttons Box
        box_presets = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        box_presets.set_homogeneous(True)
        box_presets.set_margin_top(6)

        presets = [
            ("3500 K\n(Đêm muộn)", 3500),
            ("4500 K\n(Khuyên dùng)", 4500),
            ("5500 K\n(Hoàng hôn)", 5500),
            ("6500 K\n(Tắt lọc)", 6500)
        ]

        for label, val in presets:
            btn = Gtk.Button(label=label)
            btn.add_css_class("pill")
            if val == 4500:
                btn.add_css_class("suggested-action")
            btn.connect("clicked", lambda b, v=val: self.set_preset_temp(v))
            box_presets.append(btn)

        box_slider.append(box_presets)
        self.row_slider.set_child(box_slider)
        grp_temp.add(self.row_slider)
        page.add(grp_temp)

        # Group 3: Autostart
        grp_auto = Adw.PreferencesGroup()
        grp_auto.set_title("Tự động hóa")
        row_auto = Adw.SwitchRow()
        row_auto.set_title("Khởi động cùng hệ thống")
        row_auto.set_subtitle("Tự động áp dụng nhiệt độ đã chọn mỗi khi đăng nhập")
        row_auto.set_active(nl_state.get("enabled", True))
        row_auto.connect("notify::active", self.on_autostart_toggled)
        grp_auto.add(row_auto)
        page.add(grp_auto)

        self.add(page)

    def update_temp_description(self, temp):
        if temp <= 3500:
            desc = "Rất ấm (Thích hợp phòng tối hoàn toàn)"
        elif temp <= 4500:
            desc = "Dịu nhẹ (Mức khuyên dùng tiêu chuẩn)"
        elif temp <= 5500:
            desc = "Ấm nhẹ (Tông màu hoàng hôn dịu mắt)"
        else:
            desc = "Bình thường (Màu sắc gốc)"
        self.temp_label.set_text(f"{temp} K ({desc})")

    def on_slider_changed(self, scale):
        temp = int(scale.get_value())
        self.update_temp_description(temp)

        # Debounce live apply
        if self.nightlight_debounce_timer:
            GLib.source_remove(self.nightlight_debounce_timer)
        self.nightlight_debounce_timer = GLib.timeout_add(150, self._apply_slider_temp, temp)

    def _apply_slider_temp(self, temp):
        self.nightlight_debounce_timer = None
        if self.sw_nightlight.get_active():
            self.apply_nightlight(temp)
            self.save_nightlight_state(True, temp)
        return False

    def set_preset_temp(self, temp):
        self.scale.set_value(temp)
        self.sw_nightlight.set_active(True)
        self.apply_nightlight(temp)
        self.save_nightlight_state(True, temp)

    def on_nightlight_toggled(self, switch, gparam):
        active = switch.get_active()
        temp = int(self.scale.get_value())
        if active:
            self.apply_nightlight(temp)
            self.save_nightlight_state(True, temp)
            self.show_toast(f"Đã bật ánh sáng xanh: {temp}K")
        else:
            self.disable_nightlight()
            self.save_nightlight_state(False, temp)
            self.show_toast("Đã tắt ánh sáng xanh")

    def on_autostart_toggled(self, switch, gparam):
        active = switch.get_active()
        temp = int(self.scale.get_value())
        self.save_nightlight_state(active, temp)

    def apply_nightlight(self, temp):
        def _task():
            subprocess.run("pkill -9 -x hyprsunset 2>/dev/null || true", shell=True)
            import time
            time.sleep(0.15)
            subprocess.Popen(["hyprsunset", "-t", str(temp)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        threading.Thread(target=_task, daemon=True).start()

    def disable_nightlight(self):
        def _task():
            subprocess.run("pkill -9 -x hyprsunset 2>/dev/null || true", shell=True)
            import time
            time.sleep(0.15)
            subprocess.Popen(["hyprsunset", "-i"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        threading.Thread(target=_task, daemon=True).start()

    def save_nightlight_state(self, enabled, temp):
        try:
            with open(NIGHTLIGHT_CONF, "w") as f:
                json.dump({"enabled": enabled, "temperature": temp}, f, indent=2)
        except Exception as e:
            print("Error saving nightlight:", e)

    # -------------------------------------------------------------
    # TAB 2: Màn hình & Hiển thị (Displays & Monitors)
    # -------------------------------------------------------------
    def build_display_page(self):
        page = Adw.PreferencesPage()
        page.set_title("Màn hình")
        page.set_icon_name("video-display-symbolic")

        # Group 1: Hardware Detected
        grp_hw = Adw.PreferencesGroup()
        grp_hw.set_title("Màn hình kết nối")
        grp_hw.set_description("Danh sách màn hình phần cứng nhận diện trên máy:")

        # Query hyprctl monitors
        monitors_raw = run_cmd("hyprctl monitors all -j", async_run=False)
        monitors = []
        try:
            monitors = json.loads(monitors_raw)
        except Exception:
            pass

        for m in monitors:
            name = m.get("name", "Unknown")
            model = m.get("model", "")
            desc = m.get("description", "")
            width = m.get("width", 1920)
            height = m.get("height", 1080)
            refresh = round(m.get("refreshRate", 60))
            disabled = m.get("disabled", False)

            row = Adw.ActionRow()
            display_title = f"{name} — {model if model else desc}"
            row.set_title(display_title)
            status_text = "🔴 Đã tắt (Disabled)" if disabled else "🟢 Đang hoạt động (Active)"
            row.set_subtitle(f"Độ phân giải: {width}x{height} @ {refresh}Hz | {status_text}")
            grp_hw.add(row)

        page.add(grp_hw)

        # Group 2: Display Modes (Chế độ thiết lập)
        grp_modes = Adw.PreferencesGroup()
        grp_modes.set_title("Chế độ hiển thị (Display Profiles)")
        grp_modes.set_description("Chọn cấu hình hiển thị mong muốn. Cài đặt được lưu cố định, không bị tự động bật 2 màn hình.")

        # Mode 1: HDMI Only
        row_hdmi = Adw.ActionRow()
        row_hdmi.set_title("🖥️ Chỉ dùng màn hình ngoài (HDMI-A-1)")
        row_hdmi.set_subtitle("LG UltraGear 144Hz hiển thị chính, tắt màn laptop (Chuẩn 1 màn hình)")
        btn_hdmi = Gtk.Button(label="Áp dụng")
        btn_hdmi.add_css_class("suggested-action")
        btn_hdmi.connect("clicked", lambda b: self.apply_display_profile("hdmi"))
        row_hdmi.add_suffix(btn_hdmi)
        grp_modes.add(row_hdmi)

        # Mode 2: Laptop Only
        row_laptop = Adw.ActionRow()
        row_laptop.set_title("💻 Chỉ dùng màn hình Laptop (eDP-1)")
        row_laptop.set_subtitle("Chỉ sử dụng màn hình tích hợp của máy, tắt màn hình ngoài")
        btn_laptop = Gtk.Button(label="Áp dụng")
        btn_laptop.connect("clicked", lambda b: self.apply_display_profile("laptop"))
        row_laptop.add_suffix(btn_laptop)
        grp_modes.add(row_laptop)

        # Mode 3: Extend (2 màn hình)
        row_ext = Adw.ActionRow()
        row_ext.set_title("🖥️➕💻 Mở rộng cả 2 màn hình (Extend)")
        row_ext.set_subtitle("Sử dụng cả Laptop (bên trái) và màn ngoài LG (bên phải)")
        btn_ext = Gtk.Button(label="Áp dụng")
        btn_ext.connect("clicked", lambda b: self.apply_display_profile("extend"))
        row_ext.add_suffix(btn_ext)
        grp_modes.add(row_ext)

        # Mode 4: Mirror
        row_mirror = Adw.ActionRow()
        row_mirror.set_title("👥 Nhân đôi màn hình (Mirror)")
        row_mirror.set_subtitle("Hiển thị cùng một nội dung trên cả màn hình laptop và màn ngoài")
        btn_mirror = Gtk.Button(label="Áp dụng")
        btn_mirror.connect("clicked", lambda b: self.apply_display_profile("mirror"))
        row_mirror.add_suffix(btn_mirror)
        grp_modes.add(row_mirror)

        page.add(grp_modes)

        # Group 3: Advanced Tool
        grp_adv = Adw.PreferencesGroup()
        grp_adv.set_title("Công cụ nâng cao")
        row_nwg = Adw.ActionRow()
        row_nwg.set_title("Mở Trình sắp xếp màn hình nwg-displays")
        row_nwg.set_subtitle("Kéo thả vị trí, chỉnh tỉ lệ scale và tần số quét chi tiết")
        btn_nwg = Gtk.Button(label="Mở nwg-displays")
        btn_nwg.connect("clicked", lambda b: run_cmd("~/.local/bin/nwg-displays &"))
        row_nwg.add_suffix(btn_nwg)
        grp_adv.add(row_nwg)
        page.add(grp_adv)

        self.add(page)

    def apply_display_profile(self, mode):
        run_cmd(f"~/.config/hypr/scripts/display-switch.sh {mode}")
        names = {
            "hdmi": "Chỉ màn hình ngoài HDMI (1 màn hình)",
            "laptop": "Chỉ màn hình Laptop",
            "extend": "Mở rộng cả 2 màn hình",
            "mirror": "Nhân đôi màn hình"
        }
        self.show_toast(f"Đã chuyển: {names.get(mode, mode)}")

    # -------------------------------------------------------------
    # TAB 3: Giao diện & Màu sắc (Themes & Accent Colors)
    # -------------------------------------------------------------
    def build_appearance_page(self):
        page = Adw.PreferencesPage()
        page.set_title("Giao diện")
        page.set_icon_name("preferences-desktop-theme-symbolic")

        # Accent colors
        grp_color = Adw.PreferencesGroup()
        grp_color.set_title("Màu chủ đạo hệ thống (Accent Color)")
        grp_color.set_description("Chọn màu điểm nhấn cho Dock, Statusbar, Quickshell và các ứng dụng.")

        color_presets = [
            ("💎 Trắng Tuyết (Monochrome Pure White)", "#ffffff"),
            ("⚪ Trắng Bạc (Silver Light)", "#d1d5db"),
            ("🔵 Xanh Dương (Ocean Blue)", "#3b82f6"),
            ("🟣 Tím Neon (Neon Purple)", "#8b5cf6"),
            ("🟢 Xanh Ngọc (Emerald Green)", "#10b981"),
            ("🔴 Đỏ Hồng (Crimson Rose)", "#f43f5e"),
            ("🟠 Cam Hoàng Hôn (Sunset Orange)", "#f97316"),
            ("🟡 Vàng Cyberpunk (Cyberpunk Gold)", "#f59e0b")
        ]

        for name, hex_code in color_presets:
            row = Adw.ActionRow()
            row.set_title(name)
            row.set_subtitle(f"Mã màu: {hex_code}")

            btn = Gtk.Button(label="Áp dụng")
            if hex_code == "#ffffff":
                btn.add_css_class("suggested-action")
            btn.connect("clicked", lambda b, c=hex_code: self.apply_accent_color(c))
            row.add_suffix(btn)
            grp_color.add(row)

        page.add(grp_color)

        # Custom Hex Entry
        grp_custom = Adw.PreferencesGroup()
        grp_custom.set_title("Mã màu HEX tùy chọn")
        row_entry = Adw.EntryRow()
        row_entry.set_title("Nhập mã màu HEX (ví dụ: #ffffff hoặc #00aaff)")
        btn_apply_hex = Gtk.Button(label="Áp dụng màu này")
        btn_apply_hex.connect("clicked", lambda b: self.apply_accent_color(row_entry.get_text().strip()))
        row_entry.add_suffix(btn_apply_hex)
        grp_custom.add(row_entry)
        page.add(grp_custom)

        # GTK & Icons
        grp_gtk = Adw.PreferencesGroup()
        grp_gtk.set_title("Font chữ, Con trỏ và Biểu tượng")
        row_gtk = Adw.ActionRow()
        row_gtk.set_title("Mở nwg-look")
        row_gtk.set_subtitle("Cài đặt Font chữ hệ thống, bộ Icon GTK và kích thước chuột")
        btn_gtk = Gtk.Button(label="Mở nwg-look")
        btn_gtk.connect("clicked", lambda b: run_cmd("nwg-look &"))
        row_gtk.add_suffix(btn_gtk)
        grp_gtk.add(row_gtk)
        page.add(grp_gtk)

        self.add(page)

    def apply_accent_color(self, hex_code):
        if not hex_code.startswith("#"):
            hex_code = "#" + hex_code
        if len(hex_code) not in (4, 7):
            self.show_toast("Mã HEX không hợp lệ! Ví dụ: #ffffff")
            return
        run_cmd(f"~/.config/hypr/scripts/set-accent-color.sh '{hex_code}'")
        self.show_toast(f"Đã cập nhật màu chủ đạo: {hex_code}")

    # -------------------------------------------------------------
    # TAB 4: Hình nền (Wallpaper)
    # -------------------------------------------------------------
    def build_wallpaper_page(self):
        page = Adw.PreferencesPage()
        page.set_title("Hình nền")
        page.set_icon_name("preferences-desktop-wallpaper-symbolic")

        grp_wp = Adw.PreferencesGroup()
        grp_wp.set_title("Quản lý hình nền máy tính")

        # Current wallpaper info
        cur_wp = run_cmd("cat ~/.cache/ml4w/hyprland-dotfiles/current_wallpaper 2>/dev/null", async_run=False)
        if not cur_wp:
            cur_wp = "Mặc định (ML4W Wallpapers)"

        row_cur = Adw.ActionRow()
        row_cur.set_title("Hình nền đang dùng")
        row_cur.set_subtitle(os.path.basename(cur_wp))
        grp_wp.add(row_cur)

        # Random wallpaper
        row_rand = Adw.ActionRow()
        row_rand.set_title("🎲 Đổi hình nền ngẫu nhiên")
        row_rand.set_subtitle("Chọn ngẫu nhiên một hình nền đẹp từ bộ sưu tập")
        btn_rand = Gtk.Button(label="Đổi hình nền")
        btn_rand.connect("clicked", lambda b: self.change_random_wallpaper())
        row_rand.add_suffix(btn_rand)
        grp_wp.add(row_rand)

        # ML4W Wallpaper app
        row_app = Adw.ActionRow()
        row_app.set_title("🖼️ Thư viện hình nền (ML4W Wallpaper App)")
        row_app.set_subtitle("Xem hình thu nhỏ và chọn hình nền theo danh mục")
        btn_app = Gtk.Button(label="Mở bộ sưu tập")
        btn_app.add_css_class("suggested-action")
        btn_app.connect("clicked", lambda b: run_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-app &"))
        row_app.add_suffix(btn_app)
        grp_wp.add(row_app)

        page.add(grp_wp)
        self.add(page)

    def change_random_wallpaper(self):
        run_cmd("~/.config/ml4w/scripts/ml4w-wallpaper-app --random")
        self.show_toast("Đã đổi hình nền ngẫu nhiên!")

    # -------------------------------------------------------------
    # TAB 5: Thanh tác vụ & Dock (Panels & Dock)
    # -------------------------------------------------------------
    def build_panels_page(self):
        page = Adw.PreferencesPage()
        page.set_title("Thanh công cụ")
        page.set_icon_name("preferences-system-windows-symbolic")

        # Statusbar
        grp_bar = Adw.PreferencesGroup()
        grp_bar.set_title("Thanh trạng thái trên (Quickshell Statusbar)")

        sb_autohide = False
        if os.path.exists(STATUSBAR_CONF):
            try:
                with open(STATUSBAR_CONF, "r") as f:
                    sb_autohide = json.load(f).get("bar", {}).get("autohide", False)
            except Exception:
                pass

        sw_sb = Adw.SwitchRow()
        sw_sb.set_title("Tự động ẩn thanh trên (Autohide)")
        sw_sb.set_subtitle("Ẩn thanh trạng thái khi có cửa sổ chạm tới")
        sw_sb.set_active(sb_autohide)
        sw_sb.connect("notify::active", lambda s, p: run_cmd("~/.config/ml4w/scripts/ml4w-toggle-statusbar-autohide"))
        grp_bar.add(sw_sb)
        page.add(grp_bar)

        # Dock
        grp_dock = Adw.PreferencesGroup()
        grp_dock.set_title("Thanh Dock dưới (Quickshell Dock)")

        dock_autohide = False
        if os.path.exists(DOCK_CONF):
            try:
                with open(DOCK_CONF, "r") as f:
                    dock_autohide = json.load(f).get("dock", {}).get("autohide", False)
            except Exception:
                pass

        sw_dock = Adw.SwitchRow()
        sw_dock.set_title("Tự động ẩn Dock dưới (Autohide)")
        sw_dock.set_subtitle("Ẩn thanh ứng dụng bên dưới khi cửa sổ phóng to")
        sw_dock.set_active(dock_autohide)
        sw_dock.connect("notify::active", lambda s, p: run_cmd("~/.config/ml4w/scripts/ml4w-toggle-dock-autohide"))
        grp_dock.add(sw_dock)
        page.add(grp_dock)

        # Restart Bars
        grp_restart = Adw.PreferencesGroup()
        grp_restart.set_title("Khởi động lại")
        row_restart = Adw.ActionRow()
        row_restart.set_title("🔄 Khởi động lại toàn bộ thanh giao diện")
        row_restart.set_subtitle("Tải lại Quickshell Statusbar và Dock nếu gặp hiện tượng treo hoặc hiển thị sai")
        btn_restart = Gtk.Button(label="Khởi động lại")
        btn_restart.connect("clicked", lambda b: self.restart_bars())
        row_restart.add_suffix(btn_restart)
        grp_restart.add(row_restart)
        page.add(grp_restart)

        self.add(page)

    def restart_bars(self):
        run_cmd("~/.config/hypr/scripts/restart-bars.sh")
        self.show_toast("Đã khởi động lại Statusbar & Dock!")

    # -------------------------------------------------------------
    # TAB 6: Phím tắt hệ thống (Keybindings)
    # -------------------------------------------------------------
    def build_shortcuts_page(self):
        page = Adw.PreferencesPage()
        page.set_title("Phím tắt")
        page.set_icon_name("input-keyboard-symbolic")

        grp_keys = Adw.PreferencesGroup()
        grp_keys.set_title("Bảng tra cứu phím tắt (Keybindings Cheatsheet)")
        grp_keys.set_description("Danh sách các tổ hợp phím tắt nhanh trên hệ thống:")

        shortcuts = [
            ("Win + I", "⚙️ Mở Cài đặt hệ thống (Cửa sổ này)"),
            ("Win + Return", "💻 Mở Terminal (Cửa sổ dòng lệnh)"),
            ("Win + E", "📁 Mở Quản lý tệp tin (File Manager)"),
            ("Win + B", "🌐 Mở Trình duyệt web"),
            ("Win + D / Win + Space", "🚀 Mở Menu tìm kiếm ứng dụng (Rofi)"),
            ("Win + Q", "❌ Đóng cửa sổ đang chọn"),
            ("Win + F", "🔍 Bật / Tắt chế độ toàn màn hình (Fullscreen)"),
            ("Win + Shift + Space", "📌 Thả nổi cửa sổ (Toggle Floating)"),
            ("Win + V", "📋 Mở lịch sử Khay nhớ tạm (Clipboard History)"),
            ("Win + P", "🖥️ Chuyển đổi nhanh chế độ màn hình"),
            ("Win + Print", "📸 Chụp ảnh màn hình (Screenshot)"),
            ("Ctrl + Alt + Delete", "🚪 Menu Đăng xuất, Khởi động lại hoặc Tắt máy")
        ]

        for key, desc in shortcuts:
            row = Adw.ActionRow()
            row.set_title(desc)
            lbl = Gtk.Label(label=key)
            lbl.add_css_class("heading")
            lbl.set_css_classes(["card", "heading"])
            lbl.set_margin_start(10)
            lbl.set_margin_end(10)
            lbl.set_margin_top(4)
            lbl.set_margin_bottom(4)
            row.add_suffix(lbl)
            grp_keys.add(row)

        page.add(grp_keys)
        self.add(page)

    # -------------------------------------------------------------
    # TAB 7: Thông tin hệ thống (System Info)
    # -------------------------------------------------------------
    def build_info_page(self):
        page = Adw.PreferencesPage()
        page.set_title("Thông tin")
        page.set_icon_name("dialog-information-symbolic")

        grp_info = Adw.PreferencesGroup()
        grp_info.set_title("Thông số thiết bị")

        os_info = run_cmd("grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '\"'", async_run=False) or "Fedora Linux"
        kernel_info = run_cmd("uname -r", async_run=False) or "Unknown"
        hypr_info = run_cmd("hyprctl version | head -n 1", async_run=False) or "Hyprland"
        cpu_info = run_cmd("lscpu | grep 'Model name' | cut -d: -f2 | sed 's/^[ \t]*//'", async_run=False) or "CPU"
        gpu_info = run_cmd("lspci | grep -iE 'vga|3d' | cut -d: -f3 | sed 's/^[ \t]*//' | head -n 1", async_run=False) or "GPU"

        items = [
            ("Hệ điều hành (OS)", os_info),
            ("Nhân hệ điều hành (Kernel)", kernel_info),
            ("Giao diện Compositor", hypr_info),
            ("Bộ xử lý (CPU)", cpu_info),
            ("Card đồ họa (GPU)", gpu_info),
            ("Hệ điều hành hiển thị", "Wayland Native")
        ]

        for title, value in items:
            row = Adw.ActionRow()
            row.set_title(title)
            row.set_subtitle(value)
            grp_info.add(row)

        page.add(grp_info)
        self.add(page)

    def show_toast(self, text):
        toast = Adw.Toast.new(text)
        toast.set_timeout(2)
        self.add_toast(toast)

class SettingsApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id="org.hyprland.systemsettings", flags=Gio.ApplicationFlags.FLAGS_NONE)

    def do_activate(self):
        win = self.props.active_window
        if not win:
            win = SettingsWindow(self)
        win.present()

if __name__ == "__main__":
    app = SettingsApp()
    sys.exit(app.run(sys.argv))
