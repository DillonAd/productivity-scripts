#!/usr/bin/env bash
PATH_TO_TOOL=$1

# echo "$1" >> ~/.bashrc

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

SCRIPT_NAME=$(basename $1)
COMMAND_NAME=${SCRIPT_NAME%%.*}
echo $COMMAND_NAME Created!
ln -sf $1 /usr/local/bin/$COMMAND_NAME