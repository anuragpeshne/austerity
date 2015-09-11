#!/bin/bash

# declare hosts file
HOSTS="/etc/hosts"
ORIG_FILE="$HOSTS.orig"

PLAY_START="0 10 * * * *"
PLAY_STOP="0 14 * * * *"
# * * * * *  command to execute
# │ │ │ │ │
# │ │ │ │ │
# │ │ │ │ └───── day of week (0 - 6) (0 to 6 are Sunday to Saturday
# │ │ │ └────────── month (1 - 12)
# │ │ └─────────────── day of month (1 - 31)
# │ └──────────────────── hour (0 - 23)
# └───────────────────────── min (0 - 59)

# some colors to script look cool
RED='\033[0;31m'
LRED='\033[1;31m'
NC='\033[0m' # No Color
BROWN='\033[0;33m'
GREEN='\033[1;32m'

# function to append domains to hosts
# $1: domain name
# $2: entry type- ban or control
function addToHosts {
    echo -e "127.0.0.1\twww.$1\t#aus $3" >> $HOSTS
    echo -e "127.0.0.1\t$1\t#aus $3" >> $HOSTS
}

# $1: domain name
# $2: entry type- ban or control
function addList {
    while read -r line; do
        domain=$line
        addToHosts $domain $1 $2
    done < "$1"
}
