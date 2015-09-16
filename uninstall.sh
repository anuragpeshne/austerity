#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. $DIR/constants.sh

# make sure this script is executed as a sudo
if [ "$(id -u)" != "0" ]; then
    echo -e "${RED}FATAL:${NC} This script must be run as root\nTry 'sudo $DIR/control.sh'" 1>&2
    exit 1
fi

if [ -f $ORIG_FILE ]; then
    echo -n "Host Backup found...restoring it: "
    mv $ORIG_FILE /etc/hosts
    echo -e "${GREEN}✔ Done${NC}"
else
    echo -n "No backup found, trying to remove entries from /etc/hosts:"
    TMP_HOST_FILE="/tmp/austerity/Temp$RANDOM"
    touch $TMP_HOST_FILE
    cat $HOSTS | grep -v "#aus" > $TMP_HOST_FILE
    mv $TMP_HOST_FILE $HOSTS
    echo -e "${GREEN}✔ Done${NC}"
fi

if [ -f $DIR/crontab.orig ]; then
    echo -n "crontab backup found...restoring it: "
    sudo crontab $DIR/crontab.orig
    echo -e "${GREEN}✔ Done${NC}"
else
    echo -n "No crontab backup found, Removing Austerity jobs from crontab: "
    TMP_CRON_FILE="/tmp/austerityTemp$RANDOM"
    touch $TMP_CRON_FILE
    sudo crontab -l | egrep -v "$DIR/(un)?control.sh" > $TMP_CRON_FILE
    sudo crontab $TMP_CRON_FILE
    echo -e "${GREEN}✔ Done${NC}"
fi

echo -e "${GREEN} ✔ Austerity measure unset.${NC}"
