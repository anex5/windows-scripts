@echo off
chcp 65001
::cls
::color A

setlocal EnableExtensions
setlocal ENABLEDELAYEDEXPANSION

set SRCPATH=%~1
if not defined SRCPATH call :PRINT_USAGE

set DESTPATH=%~2
if not defined DESTPATH call :PRINT_USAGE

set TMPPATH=%~3
if not defined TMPPATH set TMPPATH=%TMP%

set PROCS="%~dp0procs.cmd"

if not exist "%SRCPATH%" call %PROCS% DIR_ERROR
if not exist "%DESTPATH%" ( md "%DESTPATH%" || exit /b )
if not exist "%TMPPATH%" ( md "%TMPPATH%" || exit /b )
if /i "%SRCPATH%" equ "%DESTPATH%" call %PROCS% ERROR_SELF

set TEMPFILENAME="%TMPPATH%\_.bpg"

:: Main cycle
::if exist %TMPPATH%\Failed.txt ( del /q /s %TMPPATH%\Failed.txt 2>NUL )
::call %PROCS% PROCDIR "%SRCPATH%" "\.*.zip$ \.*.rar$" "call :EXTRACT_FILE ^"%%%%~I^" "%DESTPATH%" "%%%%SRCPATH%%%%""
call %PROCS% PROCDIR "%SRCPATH%" "\.*.jpg$ \.*.png$" "call :ENCODE_FILE ^"%%%%~I^" ^"%DESTPATH%/%%%%~nI.webp^" %TEMPFILENAME%"
::call %PROCS% PROCDIR "%DESTPATH%" "\.*.bpg$" "if exist "^%%%%~dpnI.jpg^" del /q /s ^"%%%%~dpnI.jpg^" & if exist "^%%%%~dpnI.png^" del /q /s ^"%%%%~dpnI.png^""

if exist "%TEMPFILENAME%" ( del /q /s "%TEMPFILENAME%" 2>NUL )
::type %TMPPATH%\Failed.txt 2>NUL
echo.&pause&goto:eof

:PRINT_USAGE
   echo:
   echo USAGE:
   echo %~n0 ^<source^> ^<destination^> [temp_dir]
exit /b !ERRORLEVEL!