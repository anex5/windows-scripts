@echo off
chcp 65001
::cls
::color A

setlocal EnableExtensions
setlocal ENABLEDELAYEDEXPANSION

set LOGFILE="%~dp0dism.log"
set DISM_CMD="%WINDIR%\SysWOW64\DISM.exe"
set "DISM_KEYS=/Quiet /NoRestart /LogPath:%LOGFILE%"

set SRCWIM=%~1
if not defined SRCWIM call :PRINT_USAGE

set SRCUPD=%~2
if not defined SRCUPD call :PRINT_USAGE

set DESTPATH=%~3
if not defined DESTPATH call :PRINT_USAGE
if not exist "%DESTPATH%" ( md "%DESTPATH%" || exit /b )

set PROCS="%~dp0procs.cmd"

if /i "%SRCUPD%" equ "%DESTPATH%" ( echo ERROR: Source and destination are the same! %SRCUPD% >&2 && exit /b )

del /q /s "%LOGFILE%" 2>NUL

%DISM_CMD% %DISM_KEYS% /mount-wim /wimfile:"%SRCWIM%" /index:1 /mountdir:"%DESTPATH%"
if errorlevel 1 (echo ERROR: Dism failed. Code: !ERRORLEVEL! >&2)

call :PROCDIR "%SRCUPD%" "\.*.cab$ \.*.msu$" "ADD_PACKAGE"

call :PREMISSION "Unmount image?" ":UNMOUNT"

if exist %LOGFILE% call :PREMISSION "Type %LOGFILE%?" "cls && type %LOGFILE%"

echo.&pause&goto:eof

:UNMOUNT
  call :PREMISSION "Commit image?" ":COMMIT" ":DISCARD"
  call :CLEANUP
exit /b !ERRORLEVEL!

:PREMISSION
  if [%1] == [] call :ERROR_ARG %*
	setlocal
	set QUESTION=%~1
  set TRUEPROC=%~2
  set FALSEPROC=%~3
  set /P answer=%QUESTION% ^(Y^)^:
  if /i "%answer:~,1%" EQU "Y" (
    call %TRUEPROC%
  ) else (
    call %FALSEPROC%
  )
  endlocal
exit /b !ERRORLEVEL!

:COMMIT
start "" /b /w %DISM_CMD% %DISM_KEYS% /Unmount-Wim /MountDir:%DESTPATH% /commit
if !ERRORLEVEL! NEQ 0 (
  @echo.Failed. Error:!errorlevel!
) else (
  echo WIM Updated with Changes.
)
echo.
exit /b !ERRORLEVEL!

:DISCARD
start "" /b /w %DISM_CMD% %DISM_KEYS% /Unmount-Wim /MountDir:%DESTPATH% /discard
if !ERRORLEVEL! NEQ 0 (
  @echo.Failed. Error:!errorlevel!
) else (
  echo WIM NOT updated, changes discarded.
echo.
exit /b !ERRORLEVEL!

:CLEANUP
%DISM_CMD% %DISM_KEYS% /CLEANUP-WIM && echo %DESTPATH% clean up finished.
echo.
exit /b !ERRORLEVEL!

:PROCDIR
	if [%1] == [] call :ERROR_ARG %*
	setlocal
	set SRCDIR=%~1
	set FILEMASKS=%~2
	if not defined FILEMASKS set FILEMASKS="\.*"
	set PROCNAME=%~3
	set TOTAL=0
	set COUNTER=0
	for /f "usebackq delims=" %%I in ( `dir /b /s /a:-d "%SRCDIR%\*" 2^>NUL ^| findstr /i "%FILEMASKS%" 2^>NUL` ) do (
		set /a TOTAL+=1
	)
	for /f "usebackq delims=" %%I in ( `dir /b /s /a:-d "%SRCDIR%\*" 2^>NUL ^| findstr /i "%FILEMASKS%" 2^>NUL` ) do (
		call :%PROCNAME% "%%~I"
		set /a COUNTER+=1
		set /a PTS= 100*!COUNTER!/!TOTAL!
		@echo.!COUNTER!^/!TOTAL! !PTS!^%% done.
		@echo.
	)
	endlocal
exit /b !ERRORLEVEL!

:ADD_PACKAGE
	if [%1] == [] call %PROCS% ERROR_ARG %*
	setlocal
	set FILENAME=%~1
  echo Injecting "%FILENAME%"
	%DISM_CMD% %DISM_KEYS% /image:"%DESTPATH%" /add-package /packagepath:"%FILENAME%"
	if errorlevel 1 (echo ERROR: Dism failed. Code: !ERRORLEVEL! >&2)
  endlocal
exit /b !ERRORLEVEL!

:PRINT_USAGE
   echo:
   echo USAGE:
   echo %~n0 ^<source^> ^<update_source^> ^<destination^>
exit /b !ERRORLEVEL!