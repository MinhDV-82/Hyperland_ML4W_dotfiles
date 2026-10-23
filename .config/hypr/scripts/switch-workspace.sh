#!/usr/bin/env bash
TARGET="$1"
if [ -n "$TARGET" ]; then
    hyprctl eval "hl.dispatch(hl.dsp.focus({workspace = '$TARGET'}))"
fi
