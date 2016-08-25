@echo off
setlocal enableextensions enabledelayedexpansion
set in_files=out.avi
set out_folder=e:\Work\videos\
set video_encoder=bin\x264_64_tMod-8bit-all.exe 
rem set video_encoder=bin\x265.exe
rem set "video_encoder_keys=--opencl --opencl-clbin %out_folder%x264.clbin --input-res 1920x1080 --fps 60001/1001 --force-cfr --profile high --level 4.2 --qpmin 20 --qpmax 34 --qpstep 4 --fade-compensate 1.0 --ref 2 --mixed-refs --mbtree 1 --no-fast-pskip --fgo 10 --scenecut 40 --keyint 600 --min-keyint 30 --rc-lookahead 150 --open-gop --bframes 9 --b-pyramid normal --b-adapt 1 --direct auto --8x8dct --no-dct-decimate --me umh --merange 28 --aq-mode 1 --aq-strength 0.5 --subme 9 --cabac --trellis 1 --weightp 1 --no-psy --cqm flat --sar 1:1 --deblock 1:1 --slices 4 --colorprim bt709 --transfer bt709 --colormatrix bt709 --partitions i4x4,i8x8,p8x8,b8x8 --threads auto --sync-lookahead 150 --non-deterministic --cplxblur 20 --frames 0"
set "video_encoder_keys=--opencl --opencl-clbin %out_folder%x264.clbin --input-res 640x480 --fps 60 --force-cfr --profile high --level 4.2 --qpmin 20 --qpmax 34 --qpstep 4 --fade-compensate 1.0 --ref 2 --mixed-refs --mbtree 1 --no-fast-pskip --fgo 10 --scenecut 0 --keyint 600 --min-keyint 30 --rc-lookahead 150 --open-gop --bframes 9 --b-pyramid normal --b-adapt 1 --direct auto --8x8dct --no-dct-decimate --me umh --merange 28 --aq-mode 1 --aq-strength 0.5 --subme 9 --cabac --trellis 1 --weightp 1 --no-psy --cqm flat --sar 1:1 --deblock 1:1 --slices 4 --colorprim bt709 --transfer bt709 --colormatrix bt709 --partitions i4x4,i8x8,p8x8,b8x8 --threads auto --sync-lookahead 150 --non-deterministic --cplxblur 20 --frames 0"
rem set "video_encoder_keys=--pmode --pme --input-res 1920x1080 --fps 60001/1001 --min-cu-size 32 --me 2 --subme 7 --max-merge 5 --early-skip --rdpenalty 2 --no-strong-intra-smoothing --keyint 300 --min-keyint 30 --bframes 9 --weightb --bframe-bias 25 --ref 4 --rc-lookahead 16 --scenecut 50 --qp 26 --colormatrix bt709
set audio_encoder=bin\qaac64.exe
set demuxer=bin\ffmpeg.exe
set muxer=bin\ffmpeg.exe

for %%f in (%in_files%) do (
rem echo Loadplugin^("C:\Program Files (x86)\AviSynth\plugins\yadifmod.dll"^) > "%%~nf.avs"
rem echo Loadplugin^("C:\Program Files (x86)\AviSynth\plugins\nnedi3.dll"^) >> "%%~nf.avs"
rem echo LoadPlugin^("C:\Program Files (x86)\AviSynth\plugins\ffms2.dll"^) >> "%%~nf.avs"
rem echo FFVideoSource^("%%~f"^) >> "%%~nf.avs"
rem echo nnedi3^(field=1^) >> "%%~nf.avs" 

echo Encoding %%~f pass 1
echo %video_encoder_keys%
%video_encoder% %%~f %video_encoder_keys% --pass 1 --qp 25 --ipratio 1.33 --pbratio 1.33 --output NUL --stats %out_folder%%%~nf.stats --index %%~nf.index 
echo Encoding %%~f pass last
%video_encoder% %%~f %video_encoder_keys% --qp 25 --ipratio 1.4 --pbratio 1.33 --output %out_folder%%%~nf.264 --index %%~nf.index 

rem "mkvtoolnix\mkvmerge.exe" -o "%%~nf.new.mkv" "--default-track" "0:yes" "--forced-track" "0:no" "--aspect-ratio" "0:16/9" "--default-duration" "0:23.976fps" "-d" "0" "-A" "-S" "-T" "--no-global-tags" "--no-chapters" "(" "%%~nf.264" ")" "--language" "0:jpn" "--default-track" "0:yes" "--forced-track" "0:no" "-a" "0" "-D" "-S" "-T" "--no-global-tags" "--no-chapters" "(" "%%~nf.ogg" ")" "--track-order" "0:0,1:0"
rem %demuxer% -i %%~f -vn -map 0:0 -c:a flac %out_folder%%%~nf.flac
rem %audio_encoder% %%~nf.flac -v 256 -o %%~nf.m4a
rem %muxer% -i %out_folder%%%~nf.264 -i %out_folder%%%~nf.m4a -map 0:0 -map 1:0 -vcodec copy -acodec copy -shortest %out_folder%%%~nf.mp4
)

pause
