@echo off

if exist "%1\" (
    rmdir /s /q %1
) else (
    del %1
)
