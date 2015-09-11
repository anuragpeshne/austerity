#!#!/bin/sh

# some colors to script look cool
RED='\033[0;31m'
LRED='\033[1;31m'
NC='\033[0m' # No Color
BROWN='\033[0;33m'
GREEN='\033[1;32m'

# declare hosts file
SCRIPT_LOC="/Users/$SUDO_USER/code/austerity"
HOSTS="/Users/anuragpeshne/temp/hosts" #"/etc/hosts"
ORIG_FILE="$HOSTS.org"
AUS_FILE="$HOSTS.aus"

# function to append domains to hosts
function addToHosts {
    echo "127.0.0.1\twww.$1" >> $HOSTS
    echo "127.0.0.1\t$1" >> $HOSTS
}

function addList {
    while read -r line; do
        name=$line
        addToHosts $name $1
    done < "$1"
}

# make sure this script is executed as a sudo
if [ "$(id -u)" != "0" ]; then
    echo -e "${RED}FATAL:${NC} This script must be run as root\nTry 'sudo ./control.sh'" 1>&2
    exit 1
fi

if [ -f $ORIG_FILE ]; then
    echo "File $ORIG_FILE exists."
else
    echo -n "Backing up $HOSTS: "
    sudo cp "$HOSTS" "$ORIG_FILE"
    if [ $? -ne 0 ]; then
        echo "${RED}✗ Failed to copy, exiting...${NC}"
        exit 1
    fi
    echo "${GREEN}✔ Backup created at $ORIG_FILE${NC}"

    echo -n "adding banned list"
    addList "./banList.txt"
    echo "${GREEN}✔ Done${NC}"
fi

if [! -f "./controlCron" ]; then
    echo -e "0 10 * * * *\t$SCRIPT_LOC/control.sh" > ./controlCron
fi

if [! -f "./uncontrolCron"]; then
    echo -e "0 12 * * * *\t$SCRIPT_LOC/uncontrol.sh" > ./uncontrolCron
fi

crontab -l | egrep '.'
if [ $? -eq 0 ]; then
    echo -n "Crontab found, backing it up..."
    crontab -l > $SCRIPT_LOC/crontab.orig
    echo "${GREEN}✔ Done${NC}"
fi
