@echo off
setlocal enableextensions enabledelayedexpansion

set SRCDIR=%~1
if not defined SRCDIR set SRCDIR=%~dp0

set FILEMASKS="\MPC-HC.*.exe$"
for /f "usebackq tokens=* delims=" %%I in ( `dir /b /s /a:-d "%SRCDIR%\*" 2^>NUL ^| findstr /i "%FILEMASKS%" 2^>NUL` ) do (
    set INSTALLER="%%~I"
    set INSTALLER_EXENAME="%%~nxI"
    set INSTALLER_PATH="%%~dpI"
)

@echo.��⠭������� MPC-HC %INSTALLER_EXENAME%
if exist "%INSTALLER%" ( start "" /b /w "%INSTALLER%" /SILENT /LOG="mpc-hc-install.log" ) else ( @echo.���⠫���� �� ������ � ��४�ਨ %SRCDIR% )
if !ERRORLEVEL! NEQ 0 ( @echo.�믮������ ��ࢠ��. �訡��:!errorlevel! )
echo.&pause&goto:eof