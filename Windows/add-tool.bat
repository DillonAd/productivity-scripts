@echo off

SET TOOL=%1
SET TOOL_DIR=C:\Custom\
SET PATH_TXT=%PATH%

IF [%1]==[--help] GOTO :help
IF [%1]==[/?] GOTO :help

IF [%1] == [] (
    ECHO Error - No tool defined
    GOTO help
) ELSE (
    GOTO main
)

:help

ECHO Usage: add-tool [tool-name]
ECHO Options: 
ECHO   [tool-name]  - Valid executable or batch file

goto end

:main
IF NOT "x%PATH_TXT%"=="x!PATH_TXT:%TOOL_DIR%=!" ( 
    SETX PATH "%PATH%;%TOOL_DIR%" /m
)
MKLINK %TOOL_DIR%\%TOOL% %CD%\%TOOL% 

:end