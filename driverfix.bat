@echo off
title IC - Optimizer V 3.3 (driverfix.bat)
START "" /WAIT /MIN ms-settings:windowsupdate-action >nul 2>&1
START "" /WAIT /MIN ms-settings:windowsdevices-devices >nul 2>&1
pnputil /enum-drivers > "%TEMP%\drivers.txt" >nul 2>&1
findstr /i /c:"Published name" "%TEMP%\drivers.txt" > "%TEMP%\driver_list.txt"
for /f "tokens=2 delims=:" %%G in (%TEMP%\driver_list.txt) do (
    pnputil /delete-driver %%G /force
)
setlocal
set PS_SCRIPT=%TEMP%\reset_gpu.ps1
echo Add-Type -AssemblyName System.Windows.Forms > "%PS_SCRIPT%"
echo [void] [System.Windows.Forms.SendKeys]::SendWait('{ESC}') >> "%PS_SCRIPT%"
echo [void] [System.Windows.Forms.SendKeys]::SendWait('+^{F5}') >> "%PS_SCRIPT%"
powershell -ExecutionPolicy Bypass -File "%PS_SCRIPT%"
del "%PS_SCRIPT%"
endlocal