#!/bin/bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. $DIR/constants.sh

if [ -z $1 ]; then
  let TIMEOUT=$((10*60))
else
  let TIMEOUT=$(($1*60))
fi

block()
# function to block, call this when detect a ctrl-c
{
  $DIR/control.sh
  echo "$( date ): Blocked"
}

trap block SIGINT

$DIR/uncontrol.sh
echo "$( date ): Sites unblocked for $TIMEOUT seconds"
sleep $TIMEOUT
block
