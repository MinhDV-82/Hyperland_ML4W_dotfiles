#!/usr/bin/env bash
# Hiện danh sách các cửa sổ đang chạy ở mọi workspace -> Chọn cái nào sẽ lôi cái đó về đặt cạnh cửa sổ hiện tại
CLIENTS=$(hyprctl clients -j | python3 -c "
import json, sys
data = json.load(sys.stdin)
for c in data:
    title = c.get('title', '').strip()
    clazz = c.get('class', '').strip()
    address = c.get('address', '')
    if title and clazz:
        print(f'{clazz} | {title} [addr:{address}]')
")

[ -z "$CLIENTS" ] && exit 0

CHOSEN=$(echo "$CLIENTS" | rofi -dmenu -i -p "Chọn cửa sổ đưa về đây (Attach):" -lines 8 2>/dev/null || \
         echo "$CLIENTS" | wofi --dmenu --prompt "Chọn cửa sổ đưa về đây:")

[ -z "$CHOSEN" ] && exit 0

ADDR=$(echo "$CHOSEN" | grep -o '\[addr:[^]]*\]' | sed 's/\[addr://;s/\]//')

if [ -n "$ADDR" ]; then
    CURRENT_WS=$(hyprctl monitors -j | python3 -c "import json, sys; print(json.load(sys.stdin)[0]['activeWorkspace']['id'])")
    hyprctl eval "hl.dispatch(hl.dsp.window.move({workspace = '$CURRENT_WS', address = '$ADDR'}))"
    hyprctl eval "hl.dispatch(hl.dsp.focus({address = '$ADDR'}))"
fi
