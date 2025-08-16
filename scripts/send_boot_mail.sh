#!/bin/bash
# send_boot_mail.sh
# Sends an email when the machine boots up.
# Loads configuration from .env

set -a
# Load environment variables
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
if [ -f "$SCRIPT_DIR/../.env" ]; then
    export $(grep -v '^#' "$SCRIPT_DIR/../.env" | xargs)
else
    echo "Error: .env file not found in $SCRIPT_DIR/../"
    exit 1
fi
set +a

HOSTNAME=$(hostname)
TIME=$(date "+%Y-%m-%d %H:%M:%S")

# Function to check internet connectivity
check_internet() {
    ping -c1 8.8.8.8 &>/dev/null
}

# Wait until internet is available (retry up to 5 minutes)

MAX_RETRIES=30
COUNT=0
while ! check_internet; do
    echo "[$(date)] No internet, retrying..." >> /tmp/boot-email.log
    sleep 10
    COUNT=$((COUNT+1))
    if [ $COUNT -ge $MAX_RETRIES ]; then
        echo "[$(date)] Gave up waiting for internet" >> /tmp/boot-email.log
        exit 1
    fi
done

# Check required vars
: "${SMTP_SERVER:?Missing SMTP_SERVER}"
: "${SMTP_PORT:?Missing SMTP_PORT}"
: "${SMTP_USER:?Missing SMTP_USER}"
: "${SMTP_PASS:?Missing SMTP_PASS}"
: "${MAIL_TO:?Missing MAIL_TO}"
: "${MAIL_FROM:?Missing MAIL_FROM}"

IP=$(hostname -I | awk '{print $1}')
MESSAGE="Your PC $HOSTNAME just powered on.
IP Address: $IP
Time: $TIME"

# Send email
if echo "$MESSAGE" | msmtp --host="$SMTP_SERVER" \
                           --port="$SMTP_PORT" \
                           --auth=on \
                           --user="$SMTP_USER" \
                           --passwordeval="echo \"$SMTP_PASS\"" \
                           --tls=on \
                           --tls-starttls=on \
                           --from="$MAIL_FROM" \
                           "$MAIL_TO"; then
    echo "[$(date)] Email sent successfully" >> /tmp/boot-email.log
else
    echo "[$(date)] Failed to send email" >> /tmp/boot-email.log
fi