@echo off

setlocal EnableExtensions
setlocal EnableDelayedExpansion

if "%~1" neq "" (
  2>nul >nul findstr /rc:"^ *:%~1\>" "%~f0" && (
    shift /1
    goto %1
  ) || (
    >&2 echo ERROR: routine %~1 not found
  )
) else >&2 echo ERROR: missing routine
exit /b

:PROCDIR
	if [%1] == [] call :ERROR_ARG %*
	setlocal DISABLEDELAYEDEXPANSION
	set SRCDIR=%~1
	set FILEMASKS=%~2
	if not defined FILEMASKS set FILEMASKS="\.*"
	set PROC=%~3
	set TOTAL=0
	set COUNTER=0

	for /f "usebackq tokens=* delims=" %%I in ( `dir /b /s /a:-d "%SRCDIR%\*" 2^>NUL ^| findstr /i "%FILEMASKS%" 2^>NUL` ) do (
		set /a TOTAL+=1 >nul
	)

	for /f "usebackq tokens=* delims=" %%I in ( `dir /b /s /a:-d "%SRCDIR%\*" 2^>NUL ^| findstr /i "%FILEMASKS%" 2^>NUL` ) do (
		%PROC%

		set PREVFILENAME=%%I
		set /a COUNTER+=1
		SETLOCAL ENABLEDELAYEDEXPANSION
		set /a PTS= 100*!COUNTER!/!TOTAL!
		if !ERRORLEVEL! NEQ 0 ( 
    		@echo.Process failed. Error:!ERRORLEVEL!
    	) else (
    		@echo.!COUNTER!^/!TOTAL! !PTS!^%% done.
			@echo.
		)
		endlocal
	)
	endlocal
exit /b !ERRORLEVEL!

:EXTRACT_FILE
	if [%1] == [] call :ERROR_ARG %*
	setlocal
	set extract_cmd="%ProgramFiles%\WinRAR\winrar.exe"
	set "rar_keys=-r -y -o- -ad -IBCK -INUL -x*\Thumbs.db"
	set SRCDIR=%~dp1
    set FILENAME=%~1
    set DEST=%~2
    set WORKPATH=%~3
    call set DESTDIR=%%DEST%%%%SRCDIR:%WORKPATH%=%%
    if not exist "%DESTDIR%" ( md "%DESTDIR%" || exit /b )
	echo.Extracting file "%FILENAME%"
	%extract_cmd% x %rar_keys% -- "%FILENAME%" "%DESTDIR%" 2>NUL
	if errorlevel 1 ( @echo.ERROR! Process %extract_cmd% failed. Code: %errorlevel% )
	endlocal
exit /b !ERRORLEVEL!

:COMPRESS_DIR
	if [%1] == [] call :ERROR_ARG %* 
	if not defined PSRCDIR set "PSRCDIR=" 
	setlocal
	set compress_cmd="%ProgramFiles%\WinRAR\winrar.exe"
	set "rar_keys=-r -y -s -scul -ppassword -ep1 -m5 -ms*.bpg;*.jpg;*.png;*.rar;*.zip;*.7z -IBCK -INUL -x*\Thumbs.db"
	set SRCDIR=%~dp1
	set FILENAME="%~1"
	set DEST=%~2
	set WORKPATH=%~3
	call set DESTDIR=%%DEST%%%%SRCDIR:%WORKPATH%=%%
	set OUTPUTFILENAME=%DESTDIR:~0,-1%.rar
	call :GETFILEINFO dp "%DESTDIR:~0,-1%.rar" DESTDIR
	if not exist "%DESTDIR%" ( md "%DESTDIR%" || exit /b )
	if /i "%SRCDIR%" neq "%PSRCDIR%" echo.Compressing directory "%SRCDIR%" && %compress_cmd% a %rar_keys% -- "%OUTPUTFILENAME%" "%SRCDIR%" 2>NUL 
	if errorlevel 1 ( @echo.ERROR! Process %compress_cmd% failed. Code: %errorlevel% )
	endlocal
	set PSRCDIR=%~dp1
exit /b !ERRORLEVEL!

:ENCODE_FILE
	if [%1] == [] call :ERROR_ARG %*
	setlocal
	set size=0
	set encode_cmd="d:\Tools\bpg-0.9.6-win64\bpgenc.exe"
	set "encode_keys=-q 32 -limitedrange -b 8 -m 8 -e x265 -o"
	set reencoder="c:\Program Files\GraphicsMagick-1.3.33-Q16\gm.exe"

	set FILENAME="%~1"
	set OUTPUTFILENAME="%~2"
	set TEMPFILENAME="%~3"
	set TEMPFILENAME1="%~dp3_.png"

	echo.Encoding file %FILENAME%

	::%reencoder% -alpha off -strip -mattecolor white -background white -layers Dispose -format png -quality 98 %FILENAME% %TEMPFILENAME1%
	%reencoder% convert -define webp:method=6,target-psnr=92,pass=2,thread-level=2,image-hint=photo,filter-type=0,filter-strength=50,preprocessing=2 %FILENAME% %OUTPUTFILENAME%
	if errorlevel 1 ( @echo.ERROR! Process %reencoder% failed. Code: %errorlevel% ) 
	rem copy %FILENAME% %TEMPFILENAME1%
	rem %encode_cmd% %TEMPFILENAME1% %encode_keys% %TEMPFILENAME%
	
	rem call :GETFILEINFO z %TEMPFILENAME% size
	
	::if errorlevel 1 (
	::	@echo.ERROR! Process %encode_cmd% failed. Code: %errorlevel%
	::) else (
	::	if %size% LSS 50 (
	::		echo.Ouput size: %size%. Encoding failed!
	::		echo.%FILENAME%>>%TMPPATH%\Failed.txt
	::	) else (
	::		echo.Ready. Ouput size: %size%. %OUTPUTFILENAME%
	::		copy %TEMPFILENAME% %OUTPUTFILENAME%
	::		del /q /s %FILENAME%
	::	)
	::)
	endlocal
exit /b !ERRORLEVEL!

:GETFILEINFO
	if [%1] == [] call :ERROR_ARG %*
	setlocal
	set sw=%~1
	call set info=%%~%sw%2
	::echo.info="%info%"
	ENDLOCAL & IF "%~3" NEQ "" SET %3=%info%
exit /b !ERRORLEVEL!

:ESCAPE_SCHARS_STR
	if [%1] == [] call :ERROR_ARG %*
	setlocal
	set schars="^& ^< ^> ^| ^` ^' ^. ^, ^; ^= ^( ^) ^^! [ ]"
	set str=%~1
	for %%f in (%schars%) do (
    set str="!str:%%f=^%%f!"  
	ENDLOCAL & IF "%~2" NEQ "" SET %2=%str%                  
exit /b !ERRORLEVEL!

:FN_TO_FFCONCAT
	if [%1] == [] call :ERROR_ARG %*
	setlocal ENABLEDELAYEDEXPANSION
	set FILENAME=%~1
	set PREVFILENAME="%~2"
	set FFCONCATFILENAME="%~3"

	set /a nh=0 & set /a nm=0
	set /a ph=23 & set /a pm=50

	for /f "delims=_, tokens=3,4" %%I in ( "%PREVFILENAME%" ) do ( 
		set p=%%I
		set ph=!p:~0,2!
		set pm=!p:~2,4!
		set /a ph=100!ph! %% 100
		set /a pm=100!pm! %% 100
    )

	for /f "delims=_, tokens=3,4" %%I in ( "%FILENAME%" ) do ( 
		set n=%%I
		set nh=!n:~0,2!
		set nm=!n:~2,4!
		set /a nh=100!nh! %% 100
		set /a nm=100!nm! %% 100
    )

    set /a DELAY=((nh-ph)*60+(nm-pm))

    echo !DELAY! !nh! !ph! !nm! !pm! %PREVFILENAME% %FFCONCATFILENAME%
    if !DELAY!==-1430 set /a DELAY=10
        
	echo file !FILENAME:\=\\!>>%FFCONCATFILENAME%
	echo duration !DELAY:~0,-1!>>%FFCONCATFILENAME% 

	ENDLOCAL
exit /b !ERRORLEVEL!

:NEWDATENAME
    for /f "delims=:., tokens=1-4" %%m in ("%TIME: =0%") do (
        @echo.%~1-%date:~6,4%-%date:~3,2%-%date:~0,2%-%%m%%n%%o%%p%~2
    )
exit /b !ERRORLEVEL!

:DAYNUM
	setlocal
	for /F "tokens=1-3 delims=." %%a in ( "%~1" ) do (
   		set /A "DD=1%%a-100, MM=1%%b-100, Ymod4=%%c%%4 "
	)

	for /F "tokens=%MM%" %%m in ("0 31 59 90 120 151 181 212 243 273 304 334") do (
		set /A DN=DD+%%m
	)
	if %Ymod4% equ 0 if %MM% gtr 2 set /A DN+=1
	set SDN=00%DN%
	@echo.%SDN:~-3%
	ENDLOCAL
exit /b !ERRORLEVEL!

:UNQ
  if [%1] == [] call :ERROR_ARG %*
  IF "%~2" NEQ "" set %1=%~2
exit /b !ERRORLEVEL!

:ERROR_ARG
	echo ERROR: Argument expected. Received: %* >&2
exit /b 1

:DIR_ERROR
	echo ERROR: Invalid source directory! %~1 >&2
exit /b 1

:ERROR_SELF
	echo ERROR: Source and destination are the same! %~1 >&2
exit /b 1
