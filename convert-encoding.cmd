@echo off
chcp 65001
setlocal enableextensions enabledelayedexpansion

set SRCPATH=%~1
if not defined SRCPATH call :PRINT_USAGE

set DESTPATH=%~2
if not defined DESTPATH set DESTPATH=%cd%

set SRCENC=%~3
if not defined SRCENC set SRCENC=cp1251

set DESTENC=%~4
if not defined DESTENC set DESTENC=utf-8

set PATTERN=%~5
if not defined PATTERN set PATTERN="\.*.txt$"

set PROCS="%~dp0procs.cmd"
set ICONV="%ProgramFiles%\GnuWin32\bin\iconv.exe"

if not exist "%SRCPATH%" call %PROCS% DIR_ERROR
if not exist "%DESTPATH%" ( md "%DESTPATH%" || exit /b )

:: Main cycle
echo "%SRCPATH%" "%PATTERN%" %SRCENC% %DESTENC%
call %PROCS% PROCDIR "%SRCPATH%" "%PATTERN%" "iconv.exe -f %SRCENC% -t %DESTENC% %%%%I"

echo.Ready. Files saved to "%DESTPATH%".
echo.&pause&goto:eof

:PRINT_USAGE
   echo:
   echo USAGE:
   echo %~nx0 ^<source dir^> ^<destination dir^> ^<source encoding^> ^<destination encoding^> [file name pattern]
   %ICONV% -l
   echo 

exit /b !ERRORLEVEL!