@echo off
setlocal enabledelayedexpansion
set files=3021917 3035583 2990214 3050265 2952664 3022345 3068708 3065987 3068708 3022345 3075249 3080149

for %%f in (%files%) do (
  @echo.Uninstalling KB%%f
  start "" /b /w %WINDIR%\SysWOW64\wusa.exe /uninstall /quiet /norestart /kb:%%f /log:%~n0.log
  if !ERRORLEVEL! NEQ 0 (@echo.Failed. Error:!errorlevel!)
)
rem dism /online /get-packages /format:table
pause