@echo off
chcp 65001
setlocal enabledelayedexpansion
@echo Отключение задач планировщика. В зависимости от версии windows могут появляться сообщения об ошибках...
timeout 3

set "FN=temp.list"

echo."\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask">> %FN%
echo."\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip">> %FN%
echo."\Microsoft\Windows\Customer Experience Improvement Program\HypervisorFlightingTask">> %FN%
echo."\Microsoft\Windows\Customer Experience Improvement Program\BthSQM">> %FN%
echo."\Microsoft\Windows\Customer Experience Improvement Program\Consolidator">> %FN%
echo."\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask">> %FN%
echo."\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip">> %FN%
echo."\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem">> %FN%
echo."\Microsoft\Windows\Shell\FamilySafetyMonitor">> %FN%
echo."\Microsoft\Windows\Shell\FamilySafetyRefresh">> %FN%
echo."\Microsoft\Windows\Application Experience\AitAgent">> %FN%
echo."\Microsoft\Windows\Application Experience\ProgramDataUpdater">> %FN%
echo."\Microsoft\Windows\Application Experience\StartupAppTask">> %FN%
echo."\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser">> %FN%
echo."\Microsoft\Windows\Autochk\Proxy">> %FN%
echo."\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector">> %FN%
echo."\Microsoft\Windows\Maintenance\WinSAT">> %FN%
echo."\Microsoft\Windows\Media Center\ActivateWindowsSearch">> %FN%
echo."\Microsoft\Windows\Media Center\ConfigureInternetTimeService">> %FN%
echo."\Microsoft\Windows\Media Center\DispatchRecoveryTasks">> %FN%
echo."\Microsoft\Windows\Media Center\ehDRMInit">> %FN%
echo."\Microsoft\Windows\Media Center\InstallPlayReady">> %FN%
echo."\Microsoft\Windows\Media Center\mcupdate">> %FN%
echo."\Microsoft\Windows\Media Center\MediaCenterRecoveryTask">> %FN%
echo."\Microsoft\Windows\Media Center\ObjectStoreRecoveryTask">> %FN%
echo."\Microsoft\Windows\Media Center\OCURActivate">> %FN%
echo."\Microsoft\Windows\Media Center\OCURDiscovery">> %FN%
echo."\Microsoft\Windows\Media Center\PBDADiscovery">> %FN%
echo."\Microsoft\Windows\Media Center\PBDADiscoveryW1">> %FN%
echo."\Microsoft\Windows\Media Center\PBDADiscoveryW2">> %FN%
echo."\Microsoft\Windows\Media Center\PvrRecoveryTask">> %FN%
echo."\Microsoft\Windows\Media Center\PvrScheduleTask">> %FN%
echo."\Microsoft\Windows\Media Center\RegisterSearch">> %FN%
echo."\Microsoft\Windows\Media Center\ReindexSearchRoot">> %FN%
echo."\Microsoft\Windows\Media Center\SqlLiteRecoveryTask">> %FN%
echo."\Microsoft\Windows\Media Center\UpdateRecordPath" >> %FN%

for /f "tokens=* delims=," %%f in (.\%FN%) do (
  @echo.Отключение %%f  
  start "" /b /w %WINDIR%\SysWOW64\schtasks.exe /Change /TN %%f /DISABLE
  if !ERRORLEVEL! NEQ 0 (@echo.Не выполнено. Ошибка №!errorlevel!)
)

del /q /s %FN%

echo Готово.
pause