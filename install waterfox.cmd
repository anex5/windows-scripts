@echo off
setlocal enableextensions enabledelayedexpansion

set SRCDIR=%~1
if not defined SRCDIR set SRCDIR=%~dp0

set FILEMASKS="\Waterfox.*.exe$"
for /f "usebackq tokens=* delims=" %%I in ( `dir /b /s /a:-d "%SRCDIR%\*" 2^>NUL ^| findstr /i "%FILEMASKS%" 2^>NUL` ) do (
    set INSTALLER="%%I"
    set INSTALLER_EXENAME="%%~nxI"
    set INSTALLER_PATH="%%~dpI"
)

if not exist "%INSTALLER%" ( 
    @echo.����㦠� ��⠭��騪...
    for /f tokens^=2^ delims^=^" %%I in ( 'curl.exe -s -L "https://www.waterfoxproject.org/downloads" 2^>NUL ^| findstr /i "Setup.*exe.*\<\/a\>" 2^>NUL' ) do (
        set URI=%%~I
        set INSTALLER=%%~nxI 
        set INSTALLER_EXENAME=%%~nxI                   
    )
    set INSTALLER_PATH=%SRCDIR%
    set "INSTALLER=!SRCDIR!!INSTALLER:%%20= !" 
    set "INSTALLER_EXENAME=!INSTALLER_EXENAME:%%20= !"
    if "!URI!" neq "" ( start "" /b /w curl.exe "!URI!" -o "!INSTALLER_EXENAME!" ) else ( @echo.C�뫪� �� ���⠫���� �� ������� )
)

@echo.��⠭������� waterfox %INSTALLER_EXENAME%
if exist "%INSTALLER%" ( start "" /b /w "%INSTALLER%" -ms ) else ( @echo.���⠫���� �� ������ � ��४�ਨ %SRCDIR% )
if exist "%INSTALLER_PATH%\local-settings.js" copy "%INSTALLER_PATH%\local-settings.js" "%ProgramFiles%\Waterfox\Defaults\Pref"
if !ERRORLEVEL! NEQ 0 ( @echo.�믮������ ��ࢠ��. �訡��:!errorlevel! )
echo.&pause&goto:eof


