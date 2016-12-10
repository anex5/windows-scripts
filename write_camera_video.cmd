@echo off
setlocal enableextensions enabledelayedexpansion
set now=%date:~6,4%%date:~3,2%%date:~0,2%
for /f "tokens=1-2 delims=/:" %%a in ( 'time /t' ) do ( set mytime=%%a%%b )

set in_file="E:\Work\windows-scripts\Vimicro USB2.0 UVC PC Camera.avs"
set out_folder=g:\Видео\cam\
rem set video_encoder=E:\Work\video\bin\x264.kmod\x264.2705kMod.x86_64.exe
rem set video_encoder=E:\Work\video\bin\x264.tmod\x264_32_tMod-8bit-all.exe

rem set "x264_stream=--level 2.0 --profile baseline --opencl --opencl-clbin %out_folder%x264.clbin --colorprim bt709 --transfer bt709 --colormatrix bt709 --qp 24 --keyint 240 --min-keyint 0 --threads 0 --thread-input --ref 1 --no-fast-pskip --bframes 1 --b-adapt 2 --b-pyramid --weightb --direct auto --nf --trellis 2 --partitions all --8x8dct --me hex --merange 16 --subme 5 --aud --rc-lookahead 150 --sync-lookahead 150 --non-deterministic --open-gop --cabac"

echo Encoding %in_file%
rem %video_encoder% %in_file% %x264_stream% --output "%out_folder%\%now%_%mytime:~0,-1%.mp4"
rem e:\Work\ffmpeg\bin\ffmpeg.exe -f dshow -i video="Vimicro USB2.0 UVC PC Camera" -c:v huffyuv -pix_fmt yuv422p out2.avi
"e:\Work\ffmpeg\bin\ffmpeg.exe" -loglevel error -f dshow -i video="Vimicro USB2.0 UVC PC Camera" -an ^
-vcodec libx264 -preset ultrafast -crf 21 -pix_fmt yuv422p -bsf:v h264_mp4toannexb ^
-maxrate 2000k -bufsize 10000k -f mp4 "%out_folder%\%now%_%mytime:~0,-1%.mp4"

pause