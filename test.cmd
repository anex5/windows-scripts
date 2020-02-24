@echo off
setlocal EnableDelayedExpansion
for /f %%a in ('copy /Z "%~f0" nul') do set "CR=%%a"
for /L %%n in (5 -1 1) do (
  <nul set /P "=This window will close in %%n seconds!CR!"
  ping -n 2 localhost > nul
)