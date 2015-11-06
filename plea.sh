#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. $DIR/constants.sh

if [ -z $1 ]; then
    let TIMEOUT="10"
else
    let TIMEOUT=$1
fi

$DIR/uncontrol.sh
at -f $DIR/control.sh now + $TIMEOUT minutes
