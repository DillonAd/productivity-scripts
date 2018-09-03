@echo off

SET TOOL=%1
SET TOOL_DIR=C:\Custom\
SET PATH_TXT=%PATH%

IF [%1] == [] (
    ECHO No tool defined
) ELSE (
    IF NOT "x%PATH_TXT%"=="x!PATH_TXT:%TOOL_DIR%=!" ( 
        ECHO "%PATH%;%TOOL_DIR%"
        SETX PATH "%PATH%;%TOOL_DIR%" /m
    )
    MKLINK %TOOL_DIR%\%TOOL% %CD%\%TOOL% 
)
