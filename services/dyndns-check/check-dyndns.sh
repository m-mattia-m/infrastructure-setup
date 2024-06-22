#!/bin/bash

# Define the domain and the files to update
DOMAIN="replace:home.dyn.dns"
STORAGE_FILE="./ip-archive.txt"
LOG_FILE="./check-dyndns.log"
FILES_TO_UPDATE="replace.files.to.update"
PLACEHOLDER="\${remote.host.ip.or.dyndns}"

# Get the current IP address behind the domain
CURRENT_IP=$(dig +short $DOMAIN | tr -d '\n' | xargs)

# Check if the storage file exists and read the last IP from it, or initialize it
if [ -f "$STORAGE_FILE" ]; then
    LAST_IP=$(cat $STORAGE_FILE | tr -d '\n' | xargs)
else
    LAST_IP=""
    install -m 777 /dev/null $STORAGE_FILE
fi

# Check if there is a log-file and create one if not
if [ ! -f "$LOG_FILE" ]; then
    install -m 777 /dev/null $LOG_FILE
fi

# Compare the current IP with the last stored IP
if [ "$CURRENT_IP" = "$LAST_IP" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - IP address has not changed." >> $LOG_FILE
    exit 0
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - IP address has changed from $LAST_IP to $CURRENT_IP." >> $LOG_FILE
    # Update the IP address in the specified files
    for FILE in $FILES_TO_UPDATE; do
        if [ -f "$FILE" ]; then
            if grep -q "$PLACEHOLDER" "$FILE"; then
                sed -i "s/$PLACEHOLDER/$CURRENT_IP/g" "$FILE"
            elif [ -n "$LAST_IP" ]; then
                sed -i "s/$LAST_IP/$CURRENT_IP/g" "$FILE"
            fi
            echo "$(date '+%Y-%m-%d %H:%M:%S') - File $FILE has been updated." >> $LOG_FILE
        else
            echo "$(date '+%Y-%m-%d %H:%M:%S') - File $FILE does not exist. Skipping." >> $LOG_FILE
        fi
    done

    # Store the new IP address in the storage file
    echo $CURRENT_IP > $STORAGE_FILE
fi
