#!/usr/bin/env bash
PATH_TO_TOOL=$1

if [[ $EUID -ne 0 ]]
  then echo "Please run as root"
  exit 1
fi

SCRIPT_NAME=$(basename $1)
COMMAND_NAME=${SCRIPT_NAME%%.*}
ln -sf $1 /usr/local/bin/$COMMAND_NAME
echo $COMMAND_NAME Created!