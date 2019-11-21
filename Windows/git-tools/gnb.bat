@ECHO OFF

REM
REM Git New Branch
REM
REM This script is intended to create a new branch from the master branch
REM

IF [%1] == [--help] (
    CALL :USAGE
    GOTO SUCCESS
)

IF [%1] == [] (
    ECHO No new branch name specified!
    ECHO -----------------------------
    CALL :USAGE
    GOTO FAILURE
) ELSE (
    SET NEW_BRANCH=%1
)

IF [%2] == [] (
    SET SOURCE_BRANCH=master
) ELSE (
    SET SOURCE_BRANCH=%1
)

git checkout %SOURCE_BRANCH%
git checkout -b %NEW_BRANCH%

GOTO SUCCESS

:USAGE
ECHO Git New Branch
ECHO   Creates new Git branch
ECHO Usage:
ECHO   gnb new-branch-name source-branch
ECHO.
ECHO   new-branch-name - Required - Name of the new branch
ECHO   source-branch - Optional - Name of branch to use a source for new branch

:FAILURE
EXIT /B 1

:SUCCESS
EXIT /B 0
