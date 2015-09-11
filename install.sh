#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. $DIR/constants.sh

# make sure this script is executed as a sudo
if [ "$(id -u)" != "0" ]; then
    echo -e "${RED}FATAL:${NC} This script must be run as root\nTry 'sudo $DIR/control.sh'" 1>&2
    exit 1
fi

if [ -f $ORIG_FILE ]; then
    echo "File $ORIG_FILE exists."
else
    echo -n "Backing up $HOSTS: "
    sudo cp "$HOSTS" "$ORIG_FILE"
    if [ $? -ne 0 ]; then
        echo -e "${RED}✗ Failed to copy, exiting...${NC}"
        exit 1
    fi
    echo -e "${GREEN}✔ Backup created at $ORIG_FILE${NC}"

    echo -n "adding banned list: "
    addList "$DIR/banList.txt" 'ban'
    echo -e "${GREEN} ✔ Done${NC}"
fi

TMP_CRON_FILE="/tmp/austerityTemp$RANDOM"
touch $TMP_CRON_FILE

crontab -l 2> /dev/null | egrep '.'
if [ $? -eq 0 ]; then
    echo -n "Crontab found, backing it up..."
    crontab -l > $DIR/crontab.orig
    echo -e "${GREEN}✔ Backed up at $DIR/crontab.orig${NC}"
    cat $DIR/crontab.orig | grep -v "austerity" > $TMP_CRON_FILE
fi

echo -e "$PLAY_START\t$DIR/uncontrol.sh" >> $TMP_CRON_FILE
echo -e "$PLAY_STOP\t$DIR/control.sh" >> $TMP_CRON_FILE

sudo crontab $TMP_CRON_FILE
if [ $? -eq 0 ]; then
    echo -e "${GREEN} ✔ Austerity measure set.${NC}"
fi
