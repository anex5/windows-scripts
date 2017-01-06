@if (@CodeSection == @Batch) @then
@echo off & setlocal

set url=%1
set filter=%2
rem set "filter=himawari08_2017005_...._rgb_fd\.jpg"

for /f "delims=" %%I in ('cscript /nologo /e:JScript "%~f0" "%url%" "%filter%"') do (
    rem // do something useful with %%I
    curl -o "f:\himawari\%%I" %url%%%I
)
pause
goto :EOF
@end // end batch / begin JScript hybrid code

// returns a DOM root object
function fetch(url) {
    var XHR = WSH.CreateObject("Microsoft.XMLHTTP"),
        DOM = WSH.CreateObject('htmlfile');

    XHR.open("GET",url,true);
    XHR.setRequestHeader('User-Agent','XMLHTTP/1.0');
    XHR.send('');
    while (XHR.readyState!=4) {WSH.Sleep(25)};
    DOM.write('<meta http-equiv="x-ua-compatible" content="IE=9" />');
    DOM.write(XHR.responseText);
    return DOM;
}

var DOM = fetch(WSH.Arguments(0)),
    links = DOM.getElementsByTagName('a');
 
var pattern = new RegExp(WSH.Arguments(1), i);               
for (var i in links)
    if (links[i].href && pattern.test(links[i].href)) WSH.Echo(links[i].pathname);
        