#!/usr/bin/env bash
#
# Git New Branch
#
# This script is intended to create a new branch from master (or a specified branch)
#

if [[ -z "$1" ]]; then
    echo No new branch name specified
    exit 1
else
    INTENDED_BRANCH=$1
fi

if [ -z "$2" ]; then
    TARGET_BRANCH=master
else
    TARGET_BRANCH=$2
fi

echo Intended Branch : $INTENDED_BRANCH
echo Target Branch : $TARGET_BRANCH

git checkout $TARGET_BRANCH
git pull
git checkout -b $INTENDED_BRANCH
