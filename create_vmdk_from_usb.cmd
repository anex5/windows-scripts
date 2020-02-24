@echo off
chcp 65001
cls
color A

for /F "usebackq tokens=1,2,3,4 " %%i in (`wmic logicaldisk get caption^,volumename^,drivetype 2^>NUL`) do (
	if %%j equ 2 (
		@echo %%i is a USB drive. Creating virtual disk "%USERPROFILE%\.VirtualBox\%%k.vmdk"
		For /F Tokens^=2Delims^=^" %%A In ('WMIC LogicalDisk Where "DeviceID='%%i'" Assoc /AssocClass:Win32_LogicalDiskToPartition 2^>Nul^|Find "n."') Do (
			For /F Tokens^=2Delims^=^" %%B In ('WMIC Path Win32_DiskDriveToDiskPartition 2^>Nul^|Find "%%A"') Do (
				@echo %%B
				"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" internalcommands createrawvmdk -filename "%USERPROFILE%\VirtualBox VMs\%%k.vmdk" -rawdisk %%B
			)
		) 
    )
)

pause
