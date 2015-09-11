#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. $DIR/constants.sh

cat $HOSTS | grep -v '#aus control' > $HOSTS.dup
mv $HOSTS.dup $HOSTS
