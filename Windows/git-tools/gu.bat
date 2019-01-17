@echo off
setlocal EnableDelayedExpansion

REM
REM Git Update
REM
REM This script is intended to update the current working branch from master (or a specified branch)
REM

IF [%1] == [] (
    SET TARGET_BRANCH=master
) ELSE (
    SET TARGET_BRANCH=%1
)

ECHO Target Branch : %TARGET_BRANCH%

FOR /F %%F IN ('git rev-parse --abbrev-ref HEAD') DO SET CURRENT_BRANCH=%%F

ECHO Current Branch : %CURRENT_BRANCH%

git checkout %TARGET_BRANCH%
git pull
git checkout %CURRENT_BRANCH%
git merge %TARGET_BRANCH%