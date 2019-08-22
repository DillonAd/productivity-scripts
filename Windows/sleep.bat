@ECHO OFF

REM Technically, this script will put the computer into HIBERNATE mode if it is enabled. To disable HIBERNATE mode, run:
REM powercfg -hibernate off

IF [%1] == [] (
    SET COUNTDOWN_SECONDS=3
) ELSE (
    SET COUNTDOWN_SECONDS=%2
)

ECHO Going to Standby mode in %COUNTDOWN_SECONDS% seconds

TIMEOUT /NOBREAK /T %COUNTDOWN_SECONDS%

rundll32 powrprof.dll,SetSuspendState 0,1,0