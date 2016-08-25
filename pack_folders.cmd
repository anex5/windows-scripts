@echo off
chcp 65001
cls
::color A

setlocal EnableExtensions
setlocal ENABLEDELAYEDEXPANSION

set SRCPATH=%~1
if not defined SRCPATH call :PRINT_USAGE&&goto:eof

set DESTPATH=%~2
if not defined DESTPATH call :PRINT_USAGE&&goto:eof

set TMPPATH=%~3
if not defined TMPPATH set TMPPATH=%TMP%

set PROCS="%~dp0procs.cmd"

if not exist "%SRCPATH%\*" call %PROCS% DIR_ERROR %SRCPATH%
if not exist "%DESTPATH%\*" ( md "%DESTPATH%" || exit /b )
if not exist "%TMPPATH%\*" ( md "%TMPPATH%" || exit /b )
if /i "%SRCPATH%" equ "%DESTPATH%" call %PROCS% ERROR_SELF "%SRCPATH%"

:: Main cycle
call %PROCS% PROCDIR "%SRCPATH%" "\.*.bpg$" "call :COMPRESS_DIR ^"%%%%~I^" ^"%DESTPATH%^" ^"%SRCPATH%^""
echo.&pause&goto:eof

:PRINT_USAGE
   echo:
   echo USAGE:
   echo %~n0 ^<source^> ^<destination^> [temp_dir]
exit /b !ERRORLEVEL!