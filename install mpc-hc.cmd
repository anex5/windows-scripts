@echo off
@chcp 65001
setlocal enableextensions enabledelayedexpansion

set SRCDIR=%~1
if not defined SRCDIR set SRCDIR=%~dp0

set FILEMASKS="\MPC-HC.*.exe$"
for /f "usebackq tokens=* delims=" %%I in ( `dir /b /s /a:-d "%SRCDIR%\*" 2^>NUL ^| findstr /i "%FILEMASKS%" 2^>NUL` ) do (
    set INSTALLER="%%~I"
    set INSTALLER_EXENAME="%%~nI"
    set INSTALLER_PATH="%%~dpI"
)

@echo.Устанавливаю MPC-HC %INSTALLER_EXENAME%...
if exist "%INSTALLER%" ( start "" /b /w "%INSTALLER%" /SILENT /LOG="mpc-hc-install.log" ) else ( @echo.Инсталлятор не найден в директории %SRCDIR% )
if exist "%INSTALLER_PATH%MPC-HC-settings.reg" ( @echo.Установка параметров... && reg import "%INSTALLER_PATH%MPC-HC-settings.reg" )
if !ERRORLEVEL! NEQ 0 ( @echo.Выполнение прервано. Ошибка:!errorlevel! )
echo.&pause&goto:eof