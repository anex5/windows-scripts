@echo off
chcp 65001
::cls
::color A

::setlocal EnableExtensions
::setlocal ENABLEDELAYEDEXPANSION

set FILENAME=%~1
if not defined FILENAME set FILENAME=backup

set SRCPATH=%~2
if not defined SRCPATH set SRCPATH=%~dp0

set DESTPATH=%~3
if not defined DESTPATH set DESTPATH=%~dp0

set TMPPATH=%~4
if not defined TMPPATH set TMPPATH=%TMP%

set PASSWORD=111

::set compress_cmd="%ProgramFiles%\WinRAR\winrar.exe"
::set "compress_keys=-r -u -dh -rr10p -qo+ -y -se -scUL -p%PASSWORD% -ep2 -ma -m5 -IBCK -INUL -x*\Thumbs.db -w%TMPPATH% -ilog%DESTPATH%%FILENAME%.error.log "

set compress_cmd="%ProgramFiles%\7-Zip\7z.exe"
set "compress_keys=-mx9 -ms=on -mqs=on -mhc=on -mhe=on -mmt=on -spf2 -t7z -ssw -y -p%PASSWORD% -scrcSHA256 -sccUTF-8 -scsUTF-8 -x!*\Thumbs.db -w%TMPPATH%"
:: -ms=on -mqs=on -mhc=on -mhe=on -mmt=on 
if not exist "%SRCPATH%" call :PRINT_USAGE
if not exist "%DESTPATH%" ( md "%DESTPATH%" || exit /b )
if not exist "%TMPPATH%" ( md "%TMPPATH%" || exit /b )

:: Main
echo.Creating backup...

%compress_cmd% u %compress_keys% -- "%DESTPATH%%FILENAME%.7z" @"%SRCPATH%%FILENAME%.lst

if errorlevel 1 ( @echo. && @echo.ERROR! Process %compress_cmd% failed. Code: %errorlevel% )

type %DESTPATH%%FILENAME%.error.log 2>NUL

echo.&pause&goto:eof

:PRINT_USAGE
   echo:
   echo USAGE:
   echo %~n0 ^<filename> ^<source path^> ^<destination path^> [temp_dir]
exit /b !ERRORLEVEL!