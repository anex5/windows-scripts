@echo off
start /w %WINDIR%\SysWOW64\wusa.exe /uninstall /quiet /norestart /kb:3021917
start /w %WINDIR%\SysWOW64\wusa.exe /uninstall /quiet /norestart /kb:3035583
start /w %WINDIR%\SysWOW64\wusa.exe /uninstall /quiet /norestart /kb:2990214
start /w %WINDIR%\SysWOW64\wusa.exe /uninstall /quiet /norestart /kb:3050265
start /w %WINDIR%\SysWOW64\wusa.exe /uninstall /quiet /norestart /kb:2952664
start /w %WINDIR%\SysWOW64\wusa.exe /uninstall /quiet /norestart /kb:3022345
start /w %WINDIR%\SysWOW64\wusa.exe /uninstall /quiet /norestart /kb:3068708
start /w %WINDIR%\SysWOW64\wusa.exe /uninstall /quiet /norestart /kb:3065987
rem dism /online /get-packages /format:table
pause