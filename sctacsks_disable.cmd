REM --- Disable tasks
@echo off
setlocal enabledelayedexpansion
echo Disabling tasks. Depending on Windows version this may have errors, this is normal...
timeout 3

tasks="\Microsoft\Windows\Application Experience\AitAgent" ^
"\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
"\Microsoft\Windows\Application Experience\ProgramDataUpdater"
"\Microsoft\Windows\Autochk\Proxy"
"\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
"\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
"\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
"\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
"\Microsoft\Windows\Maintenance\WinSAT"
"\Microsoft\Windows\Media Center\ActivateWindowsSearch"
"\Microsoft\Windows\Media Center\ConfigureInternetTimeService"
"\Microsoft\Windows\Media Center\DispatchRecoveryTasks"
"\Microsoft\Windows\Media Center\ehDRMInit"
"\Microsoft\Windows\Media Center\InstallPlayReady"
"\Microsoft\Windows\Media Center\mcupdate"
"\Microsoft\Windows\Media Center\MediaCenterRecoveryTask"
"\Microsoft\Windows\Media Center\ObjectStoreRecoveryTask"
"\Microsoft\Windows\Media Center\OCURActivate"
"\Microsoft\Windows\Media Center\OCURDiscovery"
"\Microsoft\Windows\Media Center\PBDADiscovery"
"\Microsoft\Windows\Media Center\PBDADiscoveryW1"
"\Microsoft\Windows\Media Center\PBDADiscoveryW2"
"\Microsoft\Windows\Media Center\PvrRecoveryTask"
"\Microsoft\Windows\Media Center\PvrScheduleTask"
"\Microsoft\Windows\Media Center\RegisterSearch"
"\Microsoft\Windows\Media Center\ReindexSearchRoot"
"\Microsoft\Windows\Media Center\SqlLiteRecoveryTask"
"\Microsoft\Windows\Media Center\UpdateRecordPath"

for %%f in (%tasks%) do (
  @echo.Uninstalling KB%%f
  start "" /b /w %WINDIR%\SysWOW64\schtasks.exe /Change /TN %%f /DISABLE
  if !ERRORLEVEL! NEQ 0 (@echo.Failed. Error:!errorlevel!)
)

echo - done