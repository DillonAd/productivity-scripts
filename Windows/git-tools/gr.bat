@echo off

REM
REM Git Rebase Branch
REM
REM This script is intended to rebase new changes from master onto an existing feature branch
REM

IF [%1] == [] (
    SET TARGET_BRANCH=master
) ELSE (
    SET TARGET_BRANCH=%1
)

ECHO Target Branch : %TARGET_BRANCH%

FOR /F %%F IN ('git rev-parse --abbrev-ref HEAD') DO SET CURRENT_BRANCH=%%F

ECHO Current Branch : %CURRENT_BRANCH%

git rebase %TARGET_BRANCH% %CURRENT_BRANCH%
