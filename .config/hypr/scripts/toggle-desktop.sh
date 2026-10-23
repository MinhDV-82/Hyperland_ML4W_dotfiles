#!/usr/bin/env bash
# Win + D: Show Desktop / Restore Desktop (Ẩn toàn bộ để lộ màn hình chính)
hyprctl eval "hl.dispatch(hl.dsp.workspace.toggle_special('minimized'))"
