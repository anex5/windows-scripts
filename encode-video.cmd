@echo off
setlocal 
set in_files=*.wmv
set out_folder=D:\Work\Video\
set video_encoder=bin\x264.2538kMod.x86_64.exe 
set "video_encoder_keys=--opencl --opencl-clbin %out_folder%x264.clbin --input-res 1920x1080 --fps 30001/1001 --force-cfr --profile high --level 4.1 --qpmin 20 --qpmax 32 --qpstep 4 --fade-compensate 1.0 --ref 6 --mixed-refs --mbtree 1 --no-fast-pskip --fgo 10 --scenecut 40 --keyint 300 --min-keyint 30 --rc-lookahead 240 --open-gop --bframes 9 --b-pyramid normal --b-adapt 1 --direct auto --8x8dct --no-dct-decimate --me umh --merange 24 --aq-mode 1 --aq-strength 0.5 --subme 9 --cabac --trellis 0 --weightp 2 --no-psy --cqm flat --sar 1:1 --deblock 1:1 --colormatrix bt709 --partitions i4x4,i8x8,p8x8,b8x8 --threads auto --sync-lookahead 150 --non-deterministic --cplxblur 20 --video-filter resize:width=1280,height=720,method=spline"
set audio_encoder=bin\qaac64.exe
set demuxer=bin\ffmpeg.exe
set muxer=bin\ffmpeg.exe

for %%f in (%in_files%) do (
echo %%~f
echo pass 1
rem echo %video_encoder_keys%
%video_encoder% %%~f %video_encoder_keys% --pass 1 --bitrate 1200 --ratetol 10 --ipratio 1.090909 --pbratio 1.333333 --output NUL --stats %out_folder%%%~nf.stats --index %%~nf.index 
echo pass 2
%video_encoder% %%~f %video_encoder_keys% --pass 2 --bitrate 1300 --ratetol 10 --ipratio 1.090909 --pbratio 1.333333 --output %out_folder%%%~nf.264 --stats %out_folder%%%~nf.stats --index %%~nf.index 

rem "mkvtoolnix\mkvmerge.exe" -o "%%~nf.new.mkv" "--default-track" "0:yes" "--forced-track" "0:no" "--aspect-ratio" "0:16/9" "--default-duration" "0:23.976fps" "-d" "0" "-A" "-S" "-T" "--no-global-tags" "--no-chapters" "(" "%%~nf.264" ")" "--language" "0:jpn" "--default-track" "0:yes" "--forced-track" "0:no" "-a" "0" "-D" "-S" "-T" "--no-global-tags" "--no-chapters" "(" "%%~nf.ogg" ")" "--track-order" "0:0,1:0"
rem %demuxer% -i %%~f -vn -map 0:0 -c:a flac %out_folder%%%~nf.flac
rem %audio_encoder% %%~nf.flac -v 256 -o %%~nf.m4a
rem %muxer% -i %out_folder%%%~nf.264 -i %out_folder%%%~nf.m4a -map 0:0 -map 1:0 -vcodec copy -acodec copy -shortest %out_folder%%%~nf.mp4
)

pause
