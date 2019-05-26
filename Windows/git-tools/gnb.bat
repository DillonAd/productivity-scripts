@echo off

REM
REM Git New Branch
REM
REM This script is intended to create a new branch from the master branch
REM

IF [%1] == [] (
    ECHO No new branch name specified
    EXIT 1
) ELSE (
    SET NEW_BRANCH=%1
)

IF [%2] == [] (
    SET SOURCE_BRANCH=master
) ELSE (
    SET SOURCE_BRANCH=%2
)

git checkout %SOURCE_BRANCH%
git checkout -b %NEW_BRANCH%
