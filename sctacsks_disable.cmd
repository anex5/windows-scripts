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

echo."Microsoft\Windows\Speech\SpeechModelDownloadTask">> %FN%
echo."Microsoft\Windows\SpacePort\SpaceAgentTask">> %FN%
echo."Microsoft\Windows\SpacePort\SpaceManagerTask">> %FN%
echo."Microsoft\Windows\NlaSvc\WiFiTask">> %FN%
echo."Microsoft\Windows\WCM\WiFiTask">> %FN%
echo."Microsoft\Windows\Management\Provisioning\Logon">> %FN%
echo."Microsoft\Windows\License Manager\TempSignedLicenseExchange">> %FN%
echo."Microsoft\Windows\ErrorDetails\EnableErrorDetailsUpdate">> %FN%
echo."Microsoft\Windows\ErrorDetails\ErrorDetailsUpdate">> %FN%
echo."Microsoft\Windows\DUSM\dusmtask">> %FN%
echo."Microsoft\XblGameSave\XblGameSaveTask">> %FN%
echo."Microsoft\XblGameSave\XblGameSaveTaskLogon">> %FN%
echo."Microsoft\Windows\Device Information\Device">> %FN%
echo."Microsoft\Windows\ApplicationData\appuriverifierinstall">> %FN%
echo."Microsoft\Windows\ApplicationData\appuriverifierdaily">> %FN%
echo."Microsoft\Windows\Windows Media Sharing\UpdateLibrary">> %FN%
echo."Microsoft\Windows\WDI\ResolutionHost">> %FN%
echo."Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser">> %FN%
echo."Microsoft\Windows\Location\Notifications">> %FN%
echo."Microsoft\Windows\Location\WindowsActionDialog">> %FN%
echo."Microsoft\Windows\RetailDemo\CleanupOfflineContent">> %FN%
echo."Microsoft\Windows\Windows Error Reporting\QueueReporting">> %FN%
echo."Microsoft\Windows\Shell\FamilySafetyMonitor">> %FN%
echo."Microsoft\Windows\Shell\FamilySafetyMonitorToastTask">> %FN%
echo."Microsoft\Windows\Shell\FamilySafetyRefreshTask">> %FN%
echo."Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem">> %FN%
echo."Microsoft\Windows\Maintenance\WinSAT">> %FN%
echo."Microsoft\Windows\FileHistory\File History (maintenance mode)">> %FN%
echo."Microsoft\Windows\Data Integrity Scan\Data Integrity Scan">> %FN%
echo."Microsoft\Windows\Data Integrity Scan\Data Integrity Scan for Crash Recovery">> %FN%
echo."Microsoft\Windows\DiskFootprint\StorageSense">> %FN%
echo."Microsoft\Windows\DiskFootprint\Diagnostics">> %FN%
echo."Microsoft\Windows\DiskCleanup\SilentCleanup">> %FN%


for /f "tokens=* delims=," %%f in (.\%FN%) do (
  @echo.Отключение %%f  
  start "" /b /w %WINDIR%\SysWOW64\schtasks.exe /Change /TN %%f /DISABLE
  if !ERRORLEVEL! NEQ 0 (@echo.Не выполнено. Ошибка №!errorlevel!)
)

del /q /s %FN%

echo Готово.
pause