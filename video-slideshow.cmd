@echo off
chcp 65001
setlocal enableextensions enabledelayedexpansion

set SRCFILE=%~1
if not defined SRCFILE call :PRINT_USAGE

set DESTPATH=%~2
if not defined DESTPATH set DESTPATH=%cd%

set PROCS="%~dp0procs.cmd"

if not exist "%SRCFILE%" call %PROCS% DIR_ERROR
if not exist "%DESTPATH%" ( md "%DESTPATH%" || exit /b )

set OUTFILEPREFIX=%~3
if not defined OUTFILEPREFIX for %%I in ( %SRCFILE% ) do set "OUTFILEPREFIX=%%~nI"

for /f "usebackq tokens=* delims=" %%I in ( `call %PROCS% NEWDATENAME %OUTFILEPREFIX%` ) do set "OUTFILENAME=%%I.mp4"

set "ffmpeg=e:\Work\video\bin\ffmpeg\ffmpeg.exe"

set "x264opts=colorprim=bt709:transfer=bt709:colormatrix=bt709:fullrange=off:analyse=0x3,0x133"

%ffmpeg% -r 2 -y -fflags +genpts  -f concat -safe 0 -i "%SRCFILE%" -map 0:0 -c:v libx264 -crf:v 21 -level:v 4.1 -profile:v high -tune:v film -preset:v fast ^
-maxrate:v 1000k -bufsize:v 2000k -r 10 -threads 0 -f mp4 -pix_fmt yuv420p -metadata title=%OUTFILEPREFIX% ^
-x264opts %x264opts% -x264-params %x264opts% %DESTPATH%%OUTFILENAME%

::-map 0:1 -c:a libfdk_aac -profile:a aac_he_v2 -afterburner 1 -signaling explicit_sbr -vbr 5 -ac 2 -ar 44100 ^

echo.Ready. File "%DESTPATH%%OUTFILENAME%" saved.
echo.&pause&goto:eof

:PRINT_USAGE
   echo:
   echo USAGE:
   echo %~nx0 ^<source^> [destination] [outfile prefix title]
exit /b !ERRORLEVEL!