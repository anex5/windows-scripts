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
	gm convert -colorspace gray -level "25%%,10,26%%" -convolve "0,0,0,0,0,0,1,1,1,0,1,1,14,1,1,0,1,1,1,0,0,0,0,0,0" -median 3 -level "99%%,10,99%%" "!SRCPATH!/!FN!" "!TMPPATH!/test.png"
	gm composite -compose bumpmap -negate "!SRCPATH!/!FN!" -negate "!TMPPATH!\test.png" "%DESTPATH%\!FN:\=\\!"
	gm convert -negate -level "0%%,1,58%%" "%DESTPATH%\!FN:\=\\!" "%DESTPATH%\!FN:\=\\!"
)
echo.Ready.

echo.&pause&goto:eof

:PRINT_USAGE
   echo:
   echo USAGE:
   echo %~n0 ^<source^> ^<destination^> [filemask]
exit /b !ERRORLEVEL!