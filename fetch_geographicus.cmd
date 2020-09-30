@if (@CodeSection == @Batch) @then
@echo off & setlocal

set "DSTDIR=%~1"
if not defined DSTDIR set "DSTDIR=%~dp0"
if not exist "%DSTDIR%" mkdir "%DSTDIR%"
set "NAME=%~n1"

set "PAGES=%~2"
if not defined PAGES set "PAGES=1,1,1"

rem SETLOCAL ENABLEDELAYEDEXPANSION
set PROCS="%~dp0procs.cmd"

set USERAGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36"

for /f %%a in ('copy /Z "%~f0" nul') do set "CR=%%a"

rem set "url=https://gallica.bnf.fr/iiif/ark:/12148/btv1b8447838j"	
rem set "url=https://gallica.bnf.fr/iiif/ark:/12148/btv1b23006724"	
set "url=https://www.geographicus.com/mm5/graphics/00000001/zoomify/PrimitivWorldNavigation-sales-1770/TileGroup0"
set "testfnw=%Temp%/test_tile_w.jpg"
set "testfnh=%Temp%/test_tile_h.jpg"

@echo.Fetching %NAME% files from: %url%, pages: %PAGES%

setlocal ENABLEDELAYEDEXPANSION
for /L %%G in (%PAGES%) do (
    if not exist "%DSTDIR%\%%G" mkdir "%DSTDIR%\%%G"
    @echo."%DSTDIR%\%%G"
    set "purl=%url%"
    
    set /a WT=2816
    set /a HT=1792
    set /a TD=256
    set /a TDI=!TD!
    set /a TDJ=!TD!
    set /a TI=!WT! / !TD!
    set /a TJ=!HT! / !TD!

	@echo.Determine width
	curl -fsS -A !USERAGENT! -o !testfnw! "!purl!/4-!TI!-0.jpg" || (
		set /a WT = !WT! - !TD!
		curl -fsS -A !USERAGENT! -o !testfnw! "!purl!/4-!TI!-0.jpg" || (
			set /a WT = !WT! - !TD!
			curl -fsS -A !USERAGENT! -o !testfnw! "!purl!/4-!TI!-0.jpg" || (
				set /a WT = !WT! - !TD!
				curl -fsS -A !USERAGENT! -o !testfnw! "!purl!/4-!TI!-0.jpg" || @echo.Process failed. Error:!ERRORLEVEL!
			)
		)
	)
	@echo.Requested last tile at pos !WT!,0 of !TD!x!TD!

	for /f "tokens=3,4 delims=x+ " %%D in ( 'gm identify !testfnw!' ) do (
		set /a dimx=%%D
		set /a dimy=%%E
		@echo.Received tile of size !dimx!x!dimy!

		if !dimy! GTR !TD! (
			set /a "TDI=!TDJ!*1000/!dimy!*!dimx!/1000"	
		) else (
			set /a "TDI=!dimx!"
		)
		set /a "W=!WT!+!TDI!"
		set /a "WTC=!W!/!TD!+1"
		
		@echo.Result image width !W! ^(!WTC! tiles^)
	)

	@echo.Determine height

	curl -fsS -A !USERAGENT! -o !testfnh! "!purl!/4-0-!TJ!.jpg" || (
		set /a HT = !HT! - !TD!
		curl -fsS -A !USERAGENT! -o !testfnh! "!purl!/4-0-!TJ!.jpg" || (
			set /a HT = !HT! - !TD!
			curl -fsS -A !USERAGENT! -o !testfnh! "!purl!/4-0-!TJ!.jpg" || (
				set /a HT = !HT! - !TD!
				curl -fsS -A !USERAGENT! -o !testfnh! "!purl!/4-0-!TJ!.jpg" || @echo.Process failed. Error:!ERRORLEVEL!
			)
		)
	)
	@echo.Requested last tile at pos 0,!HT! of !TD!x!TD!

	for /f "tokens=3,4 delims=x+ " %%D in ( 'gm identify !testfnh!' ) do (
		set /a dimx=%%D
		set /a dimy=%%E
		@echo.Received tile of size !dimx!x!dimy!
		if !dimy! GTR !TD! (
			set /a "TDJ=!dimy!*1000/!dimx!*!TDI!"/1000"	
		) else (
			set /a "TDJ=!dimy!"
		)
		set /a "H=!HT!+!TDJ!"
		set /a "HTC=!H!/!TD!+1"
		
		@echo.Result image dimensions !W!x!H! ^(!WTC!x!HTC! tiles^)
	)
	set /a TC=!HTC!*!WTC!

	set /a COUNTER=0
    for /f "tokens=1,2,3 delims= " %%I in ('cscript /nologo /e:JScript "%~f0" "!purl!" "!W!" "!H!" "!TD!"') do (
        set /a COUNTER+=1
        set /a PTS=100*!COUNTER!/!TC!
        echo.
        @echo !COUNTER!.%%I %%J!CR!
        if not exist "%DSTDIR%/%%G/%%I" ( 
        	curl -fsS -A %USERAGENT% -o "%DSTDIR%/%%G/%%I" "%%J" || @echo.Process failed. Error:!ERRORLEVEL!
        )
        @echo.!PTS!^%% done.!CR!
    )

    for /f %%a in ( '2^>nul dir "%DSTDIR%/%%G" /a-d/b/-o/-p/s^|find /v /c ""') do set /a n=%%a

    @echo.Assembling !n! files. Please wait...
    gm montage -mode concatenate -tile !WTC!x!HTC! "%DSTDIR%/%%G/*.jpg" "%DSTDIR%/%NAME% - %%G.jpg" || @echo.Process failed. Error:!ERRORLEVEL!
)

goto :EOF
@end // end batch / begin JScript hybrid code

var w=Number(WSH.Arguments(1));
var h=Number(WSH.Arguments(2));
var td=Number(WSH.Arguments(3));
var wtc=Math.ceil(w/td);
var htc=Math.ceil(h/td);
var tdi=td;
var tdj=td;

for (i = 0; i < wtc; i++) {
	for (j = 0; j < htc; j++) {
		if ( i == wtc-1 & w % td > 0 ) { tdi = w % td; } else { tdi = td };
		if ( j == htc-1 & h % td > 0 ) { tdj = h % td; } else { tdj = td };
    	WSH.Echo(('00000' + j*td).slice(-6)+"_"+('000000' + i*td).slice(-6)+".jpg "+WSH.Arguments(0)+"/4-"+Number(i)+"-"+Number(j)+".jpg");
    }
}
        