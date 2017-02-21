@echo off
@chcp 65001
setlocal enableextensions enabledelayedexpansion

set SRCDIR=%~1
if not defined SRCDIR set SRCDIR=%~dp0

set "PROFILEDIR=%APPDATA%\Mozilla\Firefox\Profiles\"

set FILEMASKS="\Waterfox.*.exe$"
for /f "usebackq tokens=* delims=" %%I in ( `dir /b /s /a:-d "%SRCDIR%\*" 2^>NUL ^| findstr /I "%FILEMASKS%" 2^>NUL` ) do (
    set INSTALLER="%%I"
    set INSTALLER_EXENAME="%%~nxI"
    set INSTALLER_PATH="%%~dpI"
)

if not exist "%INSTALLER%" ( 
    @echo.Загружаю установщик...
    for /f tokens^=2^ delims^=^" %%I in ( 'curl.exe -s -L "https://www.waterfoxproject.org/downloads" 2^>NUL ^| findstr /i "Setup.*exe.*\<\/a\>" 2^>NUL' ) do (
        set URI=%%~I
        set INSTALLER=%%~nxI 
        set INSTALLER_EXENAME=%%~nxI                   
    )
    set INSTALLER_PATH=%SRCDIR%
    set "INSTALLER=!SRCDIR!!INSTALLER:%%20= !" 
    set "INSTALLER_EXENAME=!INSTALLER_EXENAME:%%20= !"
    if "!URI!" neq "" ( start "" /b /w curl.exe "!URI!" -o "!INSTALLER_EXENAME!" ) else ( @echo.Cсылка на инсталлятор не найдена )
)

@echo.
@echo.Устанавливаю Waterfox !INSTALLER!
if exist "%INSTALLER%" ( start "" /b /w "%INSTALLER%" -ms ) else ( @echo.Инсталлятор не найден в директории %SRCDIR%&goto:eof )
if exist "%ProgramFiles%\Waterfox\Waterfox.exe" ( start "" /b /w "%ProgramFiles%\Waterfox\Waterfox.exe" -CreateProfile "%UserName%" )

for /f "usebackq tokens=* delims=" %%I in ( `dir /b %PROFILEDIR%\ 2^>NUL ^| find /I "%USERNAME%" 2^>NUL` ) do (
    set "PROFILENAME=%%I"
)

@echo.
@echo.Профиль пользователя создан: !PROFILEDIR!!PROFILENAME!
if exist "%INSTALLER_PATH%\prefs.js" copy "%INSTALLER_PATH%\prefs.js" "!PROFILEDIR!!PROFILENAME!\"
if exist "%INSTALLER_PATH%\userContent.css" copy "%INSTALLER_PATH%\userContent.css" "!PROFILEDIR!!PROFILENAME!\chrome\"

if !ERRORLEVEL! NEQ 0 ( @echo.Выполнение прервано. Ошибка:!errorlevel! )
echo.&goto:eof