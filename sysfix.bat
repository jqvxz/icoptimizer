@echo off
setlocal
title IC - Optimizer V 3.3 (sysfix.bat)
net stop wuauserv >nul 2>&1
net stop cryptSvc >nul 2>&1
net stop bits >nul 2>&1
net stop msiserver >nul 2>&1
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old >nul 2>&1
ren C:\Windows\System32\catroot2 catroot2.old >nul 2>&1
net start wuauserv >nul 2>&1 
net start cryptSvc >nul 2>&1
net start bits >nul 2>&1
net start msiserver >nul 2>&1
DISM /Online /Cleanup-Image /RestoreHealth >nul 2>&1
netsh advfirewall reset >nul 2>&1
winmgmt /salvagerepository >nul 2>&1
powercfg -restoredefaultschemes >nul 2>&1 
exit