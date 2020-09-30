@echo off
chcp 65001
setlocal enableextensions enabledelayedexpansion

set "SRCPATH=%~1"
if not defined SRCPATH set "SRCPATH=%~dp0"

set "DESTPATH=%~2"
if not defined DESTPATH set "DESTPATH=%~dp0/out"
if not exist "%DESTPATH%" mkdir "%DESTPATH%"

set "FILEMASKS=%~3"
if not defined FILEMASKS set "FILEMASKS=\.*.png$"

set "TMPPATH=%Temp%"

if not exist "%SRCPATH%\*" call PRINT_USAGE
if not exist "%DESTPATH%\*" ( md "%DESTPATH%" || exit /b )
if not exist "%TMPPATH%\*" ( md "%TMPPATH%" || exit /b )

for /f "usebackq tokens=* delims=" %%I in ( `dir /b /a:-d "%SRCPATH%\*" 2^>NUL ^| findstr /i "%FILEMASKS%" 2^>NUL` ) do (
	set FN=%%~nxI
	@echo.Processing file !FN:\=\\!
	gm convert -colorspace gray -level "65%%,4,100%%" "!SRCPATH!/!FN!" "%DESTPATH%\!FN:\=\\!"
)
echo.Ready.

echo.&pause&goto:eof

:PRINT_USAGE
   echo:
   echo USAGE:
   echo %~n0 ^<source^> ^<destination^> [filemask]
exit /b !ERRORLEVEL!