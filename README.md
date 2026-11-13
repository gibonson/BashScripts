# Check Disk Space & Network Monitoring - Pushover Notifications

## Description

A collection of lightweight Bash scripts for monitoring Linux servers and network services.

- **Disk monitoring:** Checks available disk space and sends notifications when it falls below a configured threshold.
- **Network monitoring:** Checks IP addresses and TCP ports, notifying when services become unavailable or recover.

**About Pushover**

Pushover is a notification service that allows servers and scripts to send instant push notifications directly to user devices.

Pushover offers a fully functional 30-day free trial, making it easy to test before purchasing a license.

---

## 1. Disk Space Monitoring

### `check_disk_pushover_notification.sh`

This script automatically monitors free disk space on Linux servers. When available disk space falls below a configured threshold, it sends a push notification.

1. Copy the [script](check_disk_pushover_notification.sh) to the `/opt` directory.
2. Open the script for editing:

   ```bash
   nano /opt/check_disk_pushover_notification.sh
   ```

   Configure the following variables:

   - `PUSHOVER_USER_KEY` – Your Pushover user key.
   - `PUSHOVER_APP_TOKEN` – Your Pushover application token.
   - `PARTITION` – Partition to check (e.g. `/` for the root filesystem).
   - `HOST` – Custom hostname for notifications (optional).

3. Make the script executable:

   ```bash
   chmod +x /opt/check_disk_pushover_notification.sh
   ```

4. Test notifications by temporarily setting `MIN_FREE_PERCENT` to `99` and running:

   ```bash
   /opt/check_disk_pushover_notification.sh
   ```

5. After testing, restore `MIN_FREE_PERCENT` to a realistic value, e.g. `10` or `15`.

6. Schedule automatic checks:

   ```bash
   crontab -e
   ```

   Add the following line:

   ```cron
   0 9 * * * /opt/check_disk_pushover_notification.sh
   ```

   This will run the script every day at 9:00 AM.

---

## 2. Network & Port Monitoring

### `port_monitor_pushover_notification.sh`

A lightweight Bash script for monitoring IP addresses and TCP ports across your network.

Sends Pushover notifications when services become unavailable or recover.

1. Copy the [script](port_monitor_pushover_notification.sh) to the `/opt` directory.
2. Open the script for editing:

   ```bash
   nano /opt/port_monitor_pushover_notification.sh
   ```

   Configure the following variables:

   - `PUSHOVER_USER_KEY` – Your Pushover user key.
   - `PUSHOVER_APP_TOKEN` – Your Pushover application token.
   - `TARGETS` – List of devices, IP addresses and TCP ports to monitor.

   Example:

   ```bash
   TARGETS=(
       "Bazzite-PC 192.168.0.148 22"
       "Sunshine 192.168.0.148 47990"
       "Portainer 192.168.0.148 9443"
   )
   ```

3. Make the script executable:

   ```bash
   chmod +x /opt/port_monitor_pushover_notification.sh
   ```

4. Run the script manually to test:

   ```bash
   /opt/port_monitor_pushover_notification.sh
   ```

5. Previous monitoring states are stored in:

   ```text
   ~/.local/state/port-monitor/
   ```

6. Schedule automatic checks:

   ```bash
   crontab -e
   ```

   Add the following line:

   ```cron
   0 * * * * /opt/port_monitor_pushover_notification.sh
   ```

   This will run the script every hour.

7. Enjoy ☕
