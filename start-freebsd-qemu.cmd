@echo off
chcp 65001
REM
REM  This script is used to run a Windows x64 VM on QEMU that is hosted by a Windows x64 host system
REM  The Host system is a PC with x64 CPU.
REM
set EXECUTABLE="C:\Program Files\qemu\qemu-system-x86_64.exe"
set MACHINE=-m 2G -smp cores=2,threads=1 -name FreeBSD -no-reboot -parallel none -serial none -monitor stdio 

REM No acceleration
REM generic cpu emulation.
REM to find out which CPU types are supported by the QEMU version on your system, then run:
REM	 qemu-system-x86_64.exe -cpu help
REM the see if your host system CPU is listed
REM

set CPU=-machine q35,accel=tcg,hpet=off -cpu qemu64,kvm=off,-smap,-smep

REM Enables x64 UEFI-BIOS that will be used by QEMU :
set BIOS=-drive if=pflash,format=raw,unit=0,file="c:\Program Files\qemu\share\edk2-x86_64-code.fd",readonly=on -drive if=pflash,format=raw,unit=1,file="D:\temp\qemu\FreeBSD\edk2-i386-vars.fd"

REM  Use regular GFX simulation
: set GFX=-device ramfb -device VGA 
set GFX=-vga qxl -display gtk
set USB_CTRL=-device usb-ehci,id=usbctrl
set KEYB_MOUSE=-device usb-kbd -device usb-tablet

REM # The following line enable the full-speed HD controller (requires separate driver)
REM # Following line uses the AHCI controller for the Virtual Hard Disk:
rem set DRIVE0=-device ahci,id=ahci -device ide-hd,drive=disk,bus=ahci.0

REM
REM This will set the Windows VM x64 disk image that will be launched by QEMU
REM The disk image is in the qcow2 format accepted by QEMU.
REM You get the .qcow2 image, once you get the VHDX Windows VM x64 image 
REM and apply the script to inject the virtio x64 drivers and then run the 
REM the QEMU tool to convert the .VHDX image to .qcow2 format
REM 	i.e. 
REM	qemu-img convert -c -p -O qcow2 Windows_VM_VHDX_with_injected_drivers_file.vhdx file.qcow2
REM file : points to the specified qcow2 image path.
REM
rem set DISK0=-drive id=disk,file="D:\temp\qemu\FreeBSD\FreeBSD-13.2-RELEASE-amd64.qcow2",if=none
set DISK0=-hda "D:\temp\qemu\FreeBSD\FreeBSD-13.2-RELEASE-amd64-mini-memstick.img" -boot a
rem set DISK1=-drive id=flash,if=floppy,format=raw,file="D:\temp\qemu\FreeBSD\FreeBSD-13.2-RELEASE-amd64-mini-memstick.img"

REM
REM for kdnet on, then best option:
REM   NETWORK0="-netdev user,id=net0,hostfwd=tcp::53389-:3389,hostfwd=tcp::50001-:50001 -device virtio-net,netdev=net0,disable-legacy=on"
REM
set NETHOST=-netdev user,id=net0,hostfwd=tcp::3589-:3389
set NETGUEST=-device e1000,netdev=net0

REM Audio
set AUDIO=-audiodev sdl,id=snd0

REM RTC
set RTC=-rtc base=localtime,clock=host,driftfix=none

REM Random Number Generator
rem set RNG=-object rng-random,id=rng0,filename=/dev/urandom -device virtio-rng-pci,rng=rng0

REM # The following line should enable the Daemon (instead of interactive)
set DEAMON=-daemonize"

%EXECUTABLE% %MACHINE% %CPU% %BIOS% %GFX% %USB_CTRL% %KEYB_MOUSE% %DRIVE0% %DISK1% %DISK0% %NETHOST% %NETGUEST% %AUDIO% %RTC%
