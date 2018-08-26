@echo off

SET TOOL=%1
SET TOOL_DIR=C:\Custom\
SET PATH_TXT=%PATH%

IF [%1] == [] (
    ECHO No tool defined
) ELSE (
    ECHO START
    IF NOT "x%PATH_TXT%"=="x!PATH_TXT:%TOOL_DIR%=!" ( 
        ECHO "%PATH%;%TOOL_DIR%"
        SETX PATH "%PATH%;%TOOL_DIR%" /m
    )
    ECHO START2
    ROBOCOPY ./ %TOOL_DIR% %TOOL%
)
