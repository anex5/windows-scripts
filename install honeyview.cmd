@echo off
@chcp 65001
setlocal enableextensions enabledelayedexpansion

set SRCDIR=%~1
if not defined SRCDIR set SRCDIR=%~dp0

set FILEMASKS="HONEYVIEW-SETUP.EXE$"
for /f "usebackq tokens=* delims=" %%I in ( `dir /b /s /a:-d "%SRCDIR%\*" 2^>NUL ^| findstr /i "%FILEMASKS%" 2^>NUL` ) do (
    set INSTALLER="%%~I"
    set INSTALLER_EXENAME="%%~nxI"
    set INSTALLER_PATH="%%~dpI"
)

set "URI=http://dl.bandisoft.com/honeyview/HONEYVIEW-SETUP.EXE"

if not exist "%INSTALLER%" ( 
    if "!INSTALLER_EXENAME!" EQU "" ( 
      set "INSTALLER_EXENAME=HONEYVIEW-SETUP.EXE" 
      set INSTALLER_PATH=%SRCDIR%
      set "INSTALLER=!SRCDIR!!INSTALLER_EXENAME!"
    ) 
    @echo.
    @echo.Загружаю установщик !URI!...
    if "!URI!" NEQ "" ( start "" /b /w curl.exe -L "!URI!" -o "!INSTALLER_EXENAME!" ) else ( @echo.Cсылка на инсталлятор не найдена )
)

@echo.Устанавливаю HONEYVIEW %INSTALLER_EXENAME%
if exist "%INSTALLER%" ( start "" /b /w "%INSTALLER%" /S ) else ( @echo.Инсталлятор не найден в директории %SRCDIR% )
if !ERRORLEVEL! NEQ 0 ( @echo.Выполнение прервано. Ошибка:!errorlevel! )
echo.&pause&goto:eof