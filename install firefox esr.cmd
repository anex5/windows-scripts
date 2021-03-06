@echo off
@chcp 65001
setlocal enableextensions enabledelayedexpansion

set SRCDIR=%~1
if not defined SRCDIR set SRCDIR=%~dp0

set "PROFILEDIR=%APPDATA%\Mozilla\Firefox\Profiles\"

set FILEMASKS="FirefoxSetup.exe"
for /f "usebackq tokens=* delims=" %%I in ( `dir /b /s /a:-d "%SRCDIR%\*" 2^>NUL ^| findstr /I "%FILEMASKS%" 2^>NUL` ) do (
    set INSTALLER="%%I"
    set INSTALLER_EXENAME="%%~nxI"
    set INSTALLER_PATH="%%~dpI"
)

set "URI=https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=en-US"

if not exist "%INSTALLER%" ( 
    if "!INSTALLER_EXENAME!" EQU "" ( 
      set "INSTALLER_EXENAME=FirefoxSetup.exe" 
      set INSTALLER_PATH=%SRCDIR%
      set "INSTALLER=!SRCDIR!!INSTALLER_EXENAME!"
    ) 
    @echo.
    @echo.Загружаю установщик !URI!...
    if "!URI!" NEQ "" ( start "" /b /w curl.exe -L "!URI!" -o "!INSTALLER_EXENAME!" ) else ( @echo.Cсылка на инсталлятор не найдена )
)

@echo.
@echo.Устанавливаю Firefox ESR !INSTALLER!
if exist "%INSTALLER%" ( start "" /b /w "%INSTALLER%" -ms ) else ( @echo.Инсталлятор не найден в директории %SRCDIR%&goto:eof )
if exist "%ProgramFiles%\Mozilla Firefox\Firefox.exe" ( start "" /b /w "%ProgramFiles%\Mozilla Firefox\Firefox.exe" -CreateProfile "%UserName%" )

for /f "usebackq tokens=* delims=" %%I in ( `dir /b %PROFILEDIR%\ 2^>NUL ^| find /I "%USERNAME%" 2^>NUL` ) do (
    set "PROFILENAME=%%I"
)

@echo.
@echo.Профиль пользователя создан: !PROFILEDIR!!PROFILENAME!
if exist "%INSTALLER_PATH%\prefs.js" copy "%INSTALLER_PATH%\prefs.js" "!PROFILEDIR!!PROFILENAME!\"
if exist "%INSTALLER_PATH%\userContent.css" copy "%INSTALLER_PATH%\userContent.css" "!PROFILEDIR!!PROFILENAME!\chrome\"

if !ERRORLEVEL! NEQ 0 ( @echo.Выполнение прервано. Ошибка:!errorlevel! )
echo.&goto:eof