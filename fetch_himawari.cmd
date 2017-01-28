@if (@CodeSection == @Batch) @then
@echo off & setlocal

SETLOCAL ENABLEDELAYEDEXPANSION
set PROCS="%~dp0procs.cmd"
		
set "url=http://www.ssec.wisc.edu/data/geo-new/images/himawari08/animation_images"
for /f "usebackq tokens=* delims=" %%I in ( `powershell get-date((get-date^).addDays(-1^)^) -uformat "%%d.%%m.%%Y"` ) do set "DMY=%%I"
for /f "usebackq tokens=* delims=" %%I in ( `call %PROCS% DAYNUM %DMY%` ) do set "DN=%%I"
set "filter=himawari08_%date:~6,4%%DN%_...._rgb_fd\.jpg"
@echo.Fetching files for %DMY% day of year %DN% filename: %filter%

for /f "delims=" %%I in ('cscript /nologo /e:JScript "%~f0" "%url%" "%filter%"') do (
    rem // do something useful with %%I
    set /a COUNTER+=1
    set /a PTS= 100*!COUNTER!/142
    echo.
    @echo !COUNTER!.%url%/%%I
    curl -f -o "f:\himawari\%%I" %url%/%%I || @echo.Process failed. Error:!ERRORLEVEL!
    @echo.!PTS!^%% done.
)
rem pause
goto :EOF
@end // end batch / begin JScript hybrid code

// returns a DOM root object
function fetch(url) {
    var XHR = WSH.CreateObject("Microsoft.XMLHTTP"),
        DOM = WSH.CreateObject('htmlfile');

    XHR.open("GET", url, true);
    XHR.setRequestHeader( 'User-Agent', 'XMLHTTP/1.0' );
    XHR.send('');
    while (XHR.readyState!=4) { WSH.Sleep(25) };
    DOM.write('<meta http-equiv="x-ua-compatible" content="IE=9" />');
    DOM.write(XHR.responseText);
    return DOM;
}

var DOM = fetch(WSH.Arguments(0)),
    links = DOM.getElementsByTagName('a');
 
var pattern = new RegExp(WSH.Arguments(1), i);              
for (var i in links)
    if (links[i].href && pattern.test(links[i].href)) WSH.Echo(links[i].pathname);
        