@echo off
chcp 65001
setlocal enableextensions enabledelayedexpansion

set SRCPATH=%~1
if not defined SRCPATH call :PRINT_USAGE

set DESTPATH=%~2
if not defined DESTPATH set DESTPATH=%cd%

set PATTERN=%~3
if not defined PATTERN set PATTERN="\b*"

set PROCS="%~dp0procs.cmd"

if not exist "%SRCPATH%" call %PROCS% DIR_ERROR
if not exist "%DESTPATH%" ( md "%DESTPATH%" || exit /b )

for %%I in ( "%SRCPATH%." ) do set "OUTFILENAME=%%~nxI.ffconcat"

set "PREVFILENAME=."

:: Main cycle
@echo.ffconcat version 1.0>"%DESTPATH%\%OUTFILENAME%" &&^
call %PROCS% PROCDIR "%SRCPATH%" "%PATTERN%" "call :FN_TO_FFCONCAT ^"%%%%~I^" ^"%%%%PREVFILENAME%%%%^" %DESTPATH%\%OUTFILENAME%"

echo.Ready. File "%DESTPATH%\%OUTFILENAME%" saved.
echo.&pause&goto:eof

:PRINT_USAGE
   echo:
   echo USAGE:
   echo %~nx0 ^<source dir^> ^<destination dir^> [file name pattern]
exit /b !ERRORLEVEL!