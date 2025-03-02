#!/bin/bash

CURRENT_DIR=$(pwd)
SCRIPT=$CURRENT_DIR/run.sh
LOG=$CURRENT_DIR/run.log

echo "" > $LOG
# This cron job will run the script every day at 3:00 PM. You can change the time by modifying the next line accordingly.
CRON_JOB="0 15 * * * $SCRIPT >> $LOG 2>&1"

# Add the cron job to the crontab
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -