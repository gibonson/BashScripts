#!/bin/bash

# ==========================================
# Configuration
# ==========================================

# Minimum percentage of free space at which a notification should be sent
MIN_FREE_PERCENT=99

# Partition to check (e.g. "/" for root filesystem)
PARTITION="/"

# Your Pushover Data
PUSHOVER_USER_KEY=""
PUSHOVER_APP_TOKEN=""

# hostname from $"hostname or enter your own"
HOST=$(hostname)

# ==========================================
# Script
# ==========================================

# Get percentage of used space (without '%' sign)
USED_PERCENT=$(df -h "$PARTITION" | awk 'NR==2 {print $5}' | tr -d '%')

# Calculating the percentage of free space
FREE_PERCENT=$((100 - USED_PERCENT))

# Check if free space has fallen below or equal to the limit
if [ "$FREE_PERCENT" -le "$MIN_FREE_PERCENT" ]; then
    
# Message content and title
    TITLE="$HOST - Low disk space!!"
    MESSAGE="Only $FREE_PERCENT% free space left on $PARTITION."

# Sending a notification via the Pushover API
    curl -s \
      --form-string "token=$PUSHOVER_APP_TOKEN" \
      --form-string "user=$PUSHOVER_USER_KEY" \
      --form-string "title=$TITLE" \
      --form-string "message=$MESSAGE" \
      --form-string "priority=1" \
      https://api.pushover.net/1/messages.json > /dev/null
      
# echo "Notification sent: $MESSAGE" # Uncomment for testing in terminal
fi