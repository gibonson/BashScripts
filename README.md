# Check Disk Space - Pushover Notifications

## Descripton

This script automatically monitors free disk space on Linux servers.
When the available disk space falls below a configured threshold, the script immediately sends a push notification to the administrator.

**About Pushover**

Pushover is a notification service that allows servers and scripts to send instant push notifications directly to user devices.
Pushover offers a fully functional 30-day free trial, making it easy to test before purchasing a license.

## 1.Manual check_disk_pushover_notification.sh

1. Copy the [script](/check_disk_pushover_notification.sh) to the `/opt` directory:

1. Open the script for editing:

    `nano /opt/check_disk_pushover_notification.sh`

    Set the following variables:

    - `PUSHOVER_USER_KEY` – Your Pushover user key.
    - `PUSHOVER_APP_TOKEN` – Your Pushover application token.
    - `PARTITION` - Partition to check (e.g. "/" for root filesystem)
    - `HOST` - enter your name if you want to use a different name than the host nametname 

1. Make the Script Executable:

    `chmod +x /opt/check_disk_pushover_notification.sh`

1. To test notifications, temporarily change the `MIN_FREE_PERCENT` variable to `99`.

    Run the script manually:

    `/opt/check_disk_pushover_notification.sh`

    You should receive a test notification.

5. After testing, change `MIN_FREE_PERCENT` back to a realistic value, for example `10`,`15`
6. Schedule Automatic Checks
    Edit the cron configuration:

    `crontab -e`

    Add the following line:

    `0 9 * * * /opt/check_disk_pushover_notification.sh`

    This will run the script every day at 9:00 PM.

7. Enjoy ☕

### That's it!

The system will now check disk space automatically and send a notification when free space falls below the configured threshold.

## 1.Manual port_monitor_pushover_notification.sh
~/.local/state/port-monitor/ 
