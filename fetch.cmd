@if (@CodeSection == @Batch) @then
@echo off & setlocal
@chcp 65001

set URL=%1
if not defined URL call :PRINT_USAGE&&goto:eof

set FILTER=%~2
if not defined FILTER set "FILTER=*" 

set DESTPATH=%~3
if not defined DESTPATH set DESTPATH=%~dp0

rem set "FILTER=himawari08_2017005_...._rgb_fd\.jpg"

for /f "delims=" %%I in ('cscript /nologo /e:JScript "%~f0" "%URL%" "%FILTER%"') do (
    rem // do something useful with %%I
    set /a COUNTER+=1
    echo.
    echo !COUNTER!.%url%/%%I
    curl -f -o "%DESTPATH%\%%I" %URI%/%%I    
)
pause

:PRINT_USAGE
   echo:
   echo USAGE:
   echo %~n0 ^<url^> ^<pattern^> [destination_path]
exit /b !ERRORLEVEL!

goto :EOF
@end // end batch / begin JScript hybrid code

// returns a DOM root object
function fetch(url) {
    var XHR = WSH.CreateObject("Microsoft.XMLHTTP"),
        DOM = WSH.CreateObject('htmlfile');

    XHR.open("GET", url, true);
    XHR.setRequestHeader('User-Agent','XMLHTTP/1.0' );
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
        