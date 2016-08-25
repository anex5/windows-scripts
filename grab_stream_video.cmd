@echo off
setlocal enableextensions enabledelayedexpansion
set now=%date:~6,4%%date:~3,2%%date:~0,2%
for /f "tokens=1-2 delims=/:" %%a in ( 'time /t' ) do ( set mytime=%%a%%b )
set mydate=%now%_%mytime%
set rtmpdump=C:\Temp\dump\rtmpdump.exe
set "host=http://nudecams.me/"
set "server=rtmp://185.52.55.141/live-edge"
set "model=MoDeLnAmE"
set "token=dee93f7e251fa9a53fdc833cda5b138dd6d33f209d05edc13abc5c06ebb23557"
set "link=rtmp://origin9.stream.highwebmedia.com:1935/live-origin/"%model%"-sd-f5a10827c690b0468afdb9de70cc71f58280ad7e234a02230127b734c09e79ad"

%rtmpdump% -R -v -f "WIN 21.0.0.213" -W "%host%/static/flash/CBV_2p648.swf" ^
-C S:AnonymousUser -C S:%model% -C S:2.648 -C S:anonymous -C S:%token% ^
-r "%server%" -p "%host%/%model%/?" -y "mp4:%link%" -o "C:\Temp\%mydate%_%model%.flv"

pause