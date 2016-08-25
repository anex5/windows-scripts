@echo off
setlocal enableextensions enabledelayedexpansion
set in1_file=
set in2_file=
set out_folder=

set ffmpeg=e:\Work\video\bin\ffmpeg\ffmpeg.exe

%ffmpeg% -i %in1_file% -i %in2_file% -filter_complex "blend=all_mode=difference",format=yuv420p -c:v huffyuv -pix_fmt yuv422p %out_folder%output.mkv

pause 