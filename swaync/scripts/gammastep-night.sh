#!/bin/sh

set -eu

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/gammastep/config.ini"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/gammastep-swaync"
STATE_FILE="$STATE_DIR/enabled"

mkdir -p "$STATE_DIR"

read_value() {
    key=$1
    value=$(sed -n "s/^${key}[[:space:]]*=[[:space:]]*//p" "$CONFIG" | head -n 1)
    printf '%s\n' "$value"
}

set_value() {
    key=$1
    value=$2
    tmp=$(mktemp)
    sed "s/^${key}[[:space:]]*=.*/${key}=${value}/" "$CONFIG" > "$tmp"
    mv "$tmp" "$CONFIG"
}

restart_gammastep() {
    pkill -x gammastep 2>/dev/null || true
    sleep 0.15
    gammastep >/dev/null 2>&1 &
}

case "${1:-}" in
    get-temp)
        read_value temp-night
        ;;
    set-temp)
        value=${2:?missing temperature}
        set_value temp-night "$value"
        restart_gammastep
        ;;
    get-gamma)
        value=$(read_value gamma-night)
        awk "BEGIN { printf \"%d\\n\", ($value * 100) + 0.5 }"
        ;;
    set-gamma)
        value=${2:?missing gamma percentage}
        awk "BEGIN { if ($value < 50 || $value > 100) exit 1 }"
        set_value gamma-night "$(awk "BEGIN { printf \"%.2f\", $value / 100 }")"
        restart_gammastep
        ;;
    toggle)
        if [ "$(cat "$STATE_FILE" 2>/dev/null || printf true)" = true ]; then
            kill -USR1 "$(pgrep -xo gammastep)"
            printf false > "$STATE_FILE"
        else
            kill -USR1 "$(pgrep -xo gammastep)"
            printf true > "$STATE_FILE"
        fi
        ;;
    enabled)
        printf '%s\n' "$(cat "$STATE_FILE" 2>/dev/null || printf true)"
        ;;
    *)
        printf 'Usage: %s {get-temp|set-temp|get-gamma|set-gamma|toggle|enabled}\n' "$0" >&2
        exit 2
        ;;
esac
