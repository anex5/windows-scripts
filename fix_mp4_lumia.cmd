@echo off
chcp 65001
::cls
::color A

setlocal EnableExtensions
setlocal ENABLEDELAYEDEXPANSION

set SRC=%~1
if not defined SRC call :PRINT_USAGE

set SRCNAME=%~n1
set SRCDP=%~dp1

set DST=%~2
if not defined DST set DST=%SRCDP%%SRCNAME%.fixed.mp4

set TMPPATH=%~3
if not defined TMPPATH set TMPPATH=%TMP%\

rem echo:
rem echo %DST%

set ffmpeg=ffmpeg.exe -hide_banner -y

%ffmpeg% -i "%SRC%" -vcodec copy -an -bsf:v h264_mp4toannexb "%TMPPATH%%SRCNAME%.raw.h264"
%ffmpeg% -framerate 30 -i "%TMPPATH%%SRCNAME%.raw.h264" -c copy "%TMPPATH%%SRCNAME%.framerate.fixed.mp4"
%ffmpeg% -i "%SRC%" -c:a aac -b:a 160k "%TMPPATH%%SRCNAME%.aac"
rem %ffmpeg% -hwaccel_device 0 -hwaccel cuvid -i "%TMPPATH%%SRCNAME%.framerate.fixed.mp4" -i "%TMPPATH%%SRCNAME%.aac" -vf "hwupload_cuda,scale_npp=w=1280:h=720:format=yuvj420p:interp_algo=lanczos,hwdownload,format=yuv420p" -c:v h264_nvenc -preset:v llhq -profile:v main -level:v 4.1 -rc:v ll_2pass_quality -rc-lookahead:v 32 -temporal-aq:v 1 -weighted_pred:v 1 -coder:v cabac -c:a copy -pix_fmt yuv420p -movflags +faststart -shortest "%DST%"
%ffmpeg% "%TMPPATH%%SRCNAME%.framerate.fixed.mp4" -i "%TMPPATH%%SRCNAME%.aac" -c:v libx265 -preset ultrafast -x265-params crf=22:qcomp=0.8:aq-mode=1:aq_strength=1.0:qg-size=16:psy-rd=0.7:psy-rdoq=5.0:rdoq-level=1:merange=44 -c:a copy -movflags +faststart -shortest "%DST%"

if exist "%TMPPATH%%SRCNAME%.raw.h264" ( del /q /s "%TMPPATH%%SRCNAME%.raw.h264" 2>NUL )
if exist "%TMPPATH%%SRCNAME%.framerate.fixed.mp4" ( del /q /s "%TMPPATH%%SRCNAME%.framerate.fixed.mp4" 2>NUL )
if exist "%TMPPATH%%SRCNAME%.aac" ( del /q /s "%TMPPATH%%SRCNAME%.aac" 2>NUL )

echo.&pause&goto:eof

:PRINT_USAGE
   echo:
   echo USAGE:
   echo %~n0 ^<source^> [destination] [temp_dir]
exit /b !ERRORLEVEL!
