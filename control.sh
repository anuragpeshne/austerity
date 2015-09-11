#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

. $DIR/constants.sh

addList "$DIR/controlList.txt" 'control'
