#!/usr/bin/env bash
#
# Git Update
#
# This script is intended to update the current working branch from master (or a specified branch)
#

if [ -z "$1" ]; then
    TARGET_BRANCH=master
else
    TARGET_BRANCH=$1
fi

echo Target Branch : $TARGET_BRANCH

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

echo Current Branch : $CURRENT_BRANCH

git checkout $TARGET_BRANCH
git pull
git checkout $CURRENT_BRANCH
git merge $TARGET_BRANCH