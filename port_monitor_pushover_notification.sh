
#!/bin/bash

# ==========================================
# Configuration
# ==========================================

# Pushover
PUSHOVER_USER_KEY=""
PUSHOVER_APP_TOKEN=""

HOST=$(hostname)

# Connection timeout (seconds)
TIMEOUT=3

# Notify when service becomes available again
NOTIFY_RECOVERY=true

# Previous scan states
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/port-monitor"

# Targets: NAME IP PORT
TARGETS=(
    "PC1 192.168.0.1 22"
    "PC1-Sunshine 192.168.0.2 47990"
    "PC2-Portainer 192.168.0.3 9443"
    "Raspberry-Pi 192.168.0.4 22"
)

# ==========================================
# Functions
# ==========================================

send_notification() {
    local TITLE="$1"
    local MESSAGE="$2"

    curl -fsS \
        --form-string "token=$PUSHOVER_APP_TOKEN" \
        --form-string "user=$PUSHOVER_USER_KEY" \
        --form-string "title=$TITLE" \
        --form-string "message=$MESSAGE" \
        --form-string "priority=0" \
        https://api.pushover.net/1/messages.json \
        > /dev/null
}

check_port() {
    local IP="$1"
    local PORT="$2"

    timeout "$TIMEOUT" bash -c \
        ':</dev/tcp/$1/$2' _ "$IP" "$PORT" \
        2>/dev/null
}

# ==========================================
# Main
# ==========================================

mkdir -p "$STATE_DIR"

for TARGET in "${TARGETS[@]}"; do

    read -r NAME IP PORT <<< "$TARGET"

    STATE_FILE="$STATE_DIR/$(echo "$NAME" | tr -c 'A-Za-z0-9_.-' '_')"

    PREVIOUS=$(cat "$STATE_FILE" 2>/dev/null || echo "unknown")

    if check_port "$IP" "$PORT"; then
        CURRENT="up"
    else
        CURRENT="down"
    fi

    # No change
    if [ "$CURRENT" = "$PREVIOUS" ]; then
        continue
    fi

    TITLE="$HOST - $NAME"

    if [ "$CURRENT" = "down" ]; then

        MESSAGE="Service unavailable: $NAME ($IP:$PORT)"

        if send_notification "$TITLE" "$MESSAGE"; then
            echo "DOWN: $NAME ($IP:$PORT)"
            echo "down" > "$STATE_FILE"
        fi

    else

        if [ "$PREVIOUS" = "down" ] && [ "$NOTIFY_RECOVERY" = true ]; then

            MESSAGE="Service restored: $NAME ($IP:$PORT)"

            if send_notification "$TITLE" "$MESSAGE"; then
                echo "UP: $NAME ($IP:$PORT)"
                echo "up" > "$STATE_FILE"
            fi

        else
            echo "UP: $NAME ($IP:$PORT)"
            echo "up" > "$STATE_FILE"
        fi

    fi

done

