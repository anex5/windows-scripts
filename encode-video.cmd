@echo off
setlocal 
set in_files=*.wmv
set out_folder=

for %%f in (%in_files%) do (
echo %%~f
echo pass 1
rem "bin\x264.2538kMod.x86_64.exe" %%~f --opencl --input-res 1920x1080 --fps 30001/1001 --force-cfr --profile high --level 4.1 --pass 1 --qpmin 22 --qpmax 32 --qpstep 4 --bitrate 1200 --ratetol 10 --fade-compensate 1.0 --ipratio 1.4 --pbratio 1.3 --ref 6 --mixed-refs --mbtree 1 --no-fast-pskip --fgo 10 --scenecut 40 --keyint 300 --min-keyint 30 --rc-lookahead 120 --open-gop --bframes 9 --b-pyramid normal --b-adapt 1 --direct auto --8x8dct --no-dct-decimate --me umh --merange 24 --aq-mode 1 --aq-strength 1 --subme 9 --cabac --trellis 0 --weightp 2 --no-psy --cqm flat --sar 1:1 --deblock 1:1 --colormatrix bt709 --partitions i4x4,i8x8,p8x8,b8x8 --threads auto --lookahead-threads 2 --mvrange-thread -1 --sync-lookahead 150 --thread-input --demuxer-threads 1 --non-deterministic --cplxblur 20 --video-filter resize:width=1280,height=720,method=spline --output %out_folder%%%~nf.264 --stats %out_folder%%%~nf.stats --index %%~nf.index --opencl-clbin %out_folder%x264.clbin
echo pass 2
"bin\x264.2538kMod.x86_64.exe" %%~f --opencl --input-res 1920x1080 --fps 30001/1001 --force-cfr --profile high --level 4.1 --pass 2 --qpmin 22 --qpmax 32 --qpstep 4 --bitrate 1300 --ratetol 10 --fade-compensate 1.0 --ipratio 1.4 --pbratio 1.3 --ref 6 --mixed-refs --mbtree 1 --no-fast-pskip --fgo 10 --scenecut 40 --keyint 300 --min-keyint 30 --rc-lookahead 120 --open-gop --bframes 9 --b-pyramid normal --b-adapt 1 --direct auto --8x8dct --no-dct-decimate --me umh --merange 24 --aq-mode 1 --aq-strength 1 --subme 9 --cabac --trellis 0 --weightp 2 --no-psy --cqm flat --sar 1:1 --deblock 1:1 --colormatrix bt709 --partitions i4x4,i8x8,p8x8,b8x8 --threads auto --lookahead-threads 1 --mvrange-thread -1 --sync-lookahead 150 --thread-input --demuxer-threads 1 --non-deterministic --cplxblur 20 --video-filter resize:width=1280,height=720,method=spline --output %out_folder%%%~nf.264 --stats %out_folder%%%~nf.stats --index %%~nf.index --opencl-clbin %out_folder%x264.clbin

REM "mkvtoolnix\mkvmerge.exe" -o "%%~nf.new.mkv" "--default-track" "0:yes" "--forced-track" "0:no" "--aspect-ratio" "0:16/9" "--default-duration" "0:23.976fps" "-d" "0" "-A" "-S" "-T" "--no-global-tags" "--no-chapters" "(" "%%~nf.264" ")" "--language" "0:jpn" "--default-track" "0:yes" "--forced-track" "0:no" "-a" "0" "-D" "-S" "-T" "--no-global-tags" "--no-chapters" "(" "%%~nf.ogg" ")" "--track-order" "0:0,1:0"
rem "bin\ffmpeg.exe" -y -i %%~f -vn -map 0:0 -c:a flac %out_folder%%%~nf.flac
rem "bin\qaac64.exe" %%~nf.flac -v256 -o %%~nf.m4a
rem "bin\ffmpeg.exe" -y -i %out_folder%%%~nf.264 -i %out_folder%%%~nf.m4a -map 0:0 -map 1:0 -vcodec copy -acodec copy -shortest %out_folder%%%~nf.mp4
)

pause
