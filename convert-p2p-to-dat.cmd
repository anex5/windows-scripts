@echo off
chcp 65001
::cls
::color A

setlocal EnableExtensions
setlocal ENABLEDELAYEDEXPANSION

set SRC=%~1
if not defined SRC call :PRINT_USAGE

set DEST=%~2
if not defined DEST call :PRINT_USAGE

if not exist "%SRC%" @echo.File "%SRC%" doesn't exist 
if /i "%SRC%" equ "%DEST%" @echo.File "%SRC%" and "%DEST%" are the same

:: Main cycle
::for /F "usebackq tokens=1,2* delims=:" %%i in (`type "%SRC%" 2^>NUL`) do @echo.%%j , 000 , %%i>>"%DEST%"
for /F "usebackq tokens=1,2* delims=:" %%i in ("%SRC%") do @echo.%%j , 000 , %%i>>"%DEST%"
echo.&pause&goto:eof

:PRINT_USAGE
   echo:
   echo USAGE:
   echo %~n0 ^<source^> ^<destination^>
exit /b !ERRORLEVEL!