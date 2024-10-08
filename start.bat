@echo off
setlocal EnableDelayedExpansion
:: Get admin
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% neq 0 ( goto UACPrompt ) else ( goto :start )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
    "%temp%\GetAdmin.vbs"
    del "%temp%\GetAdmin.vbs"
    exit /B
:start
cd /d "%~dp0"
:: Define ANSI escape codes
for /F %%e in ('echo prompt $E ^| cmd') do set "ESC=%%e"
set "RED=!ESC![31m"
set "GREEN=!ESC![32m"
set "YELLOW=!ESC![33m"
set "BLUE=!ESC![34m"
set "MAGENTA=!ESC![35m"
set "CYAN=!ESC![36m"
set "WHITE=!ESC![37m"
set "RESET=!ESC![0m"
:: Display header
:header
cd header
title Loading...
timeout -t 1 > nul
cls
for /F "delims=" %%A in (header.txt) do (
    echo %RED%%%A%RESET%
)
cd ..\..
echo.
cd .main/info
for /f "tokens=2 delims==" %%G in ('wmic cpu get name /value') do set "cpu=%%G"
for /f "tokens=2 delims==" %%G in ('wmic path win32_videocontroller get name /value') do set "video=%%G"
for /f "tokens=2 delims==" %%G in ('wmic diskdrive get model /value') do set "storage=%%G"
for /f "tokens=2 delims==" %%G in ('wmic memorychip get capacity /value') do set "ram_kb=%%G"
echo Executed on [%computername%] by [%username%] on [%date%] at [%time%] with [Windows 10/11/8/7] > .%computername%
echo. >> .%computername%
echo Specs are [%cpu%] [%video%] [%storage%] [%ram_kb%] >> .%computername%
title IC - Optimizer V 3.5
SETLOCAL ENABLEDELAYEDEXPANSION
set lang=%SystemRoot%\System32\wbem\wmic.exe os get locale
:: Select script (no admin)
echo %YELLOW%[%CYAN%1%YELLOW%]%RESET% ^> Execute all commands 
@ping -n 1 localhost> nul
echo %YELLOW%[%CYAN%2%YELLOW%]%RESET% ^> Only execute network related commands
@ping -n 1 localhost> nul
echo %YELLOW%[%CYAN%3%YELLOW%]%RESET% ^> Only perform registery edits
@ping -n 1 localhost> nul
echo %YELLOW%[%CYAN%4%YELLOW%]%RESET% ^> Exclude commands that only need to be executed once
@ping -n 1 localhost> nul
set /p select="Select actions (1-4): "
echo.
if %select% == 1 ( 
    goto default_start 
)
if %select% == 2 (
    goto network_cmd 
)
if %select% == 3 ( 
    goto reg_cmd 
)
if %select% == 4 ( 
    goto second_execute
)
exit
:: Clear DNS (no admin required)
:network_cmd rem Start of network section 1
:default_start rem Start of normal execute 1
:second_execute rem Start of exlude one time sections (reg edits)
set timestamp=%date%
set "file=DNS_output_%timestamp%.txt"
ipconfig /flushdns > %file%
@ping -n 1 localhost> nul
if %errorlevel% == 0 ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Cleared DNS cache 
) else (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 1 
)
:: Reset Network Adapter (admin required)
set timestamp=%date%
set "file=Network_clear_output_%timestamp%.txt"
netsh winsock reset > %file%
@ping -n 1 localhost> nul
if %errorlevel% == 0 ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Reset Network Adapter 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 2 
)
if %select% == 2 ( goto network_cmd_2 )
:: Kill Processes (admin required) 
set timestamp=%date%
set "file=KILL_output_%timestamp%.txt"
taskkill /f /im NewsAndInterests.exe >nul 2>&1
if %errorlevel% == 0 ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Killed 1 NewsAndInterests.exe 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 3 
)
taskkill /f /im OneDrive.exe >nul 2>&1
if %errorlevel% == 0 ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Killed 2 neDrive.exe 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 4 
)
taskkill /f /im ctfmon.exe >nul 2>&1
if %errorlevel% == 0 ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Killed 3 ctfmon.exe 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 5 
)
taskkill /f /im PhoneExperienceHost.exe >nul 2>&1
if %errorlevel% == 0 ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Killed 4 PhoneExperienceHost.exe 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 6 
)
taskkill /f /im GrooveMusic.exe >nul 2>&1
if %errorlevel% == 0 ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Killed 5 GrooveMusic.exe 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 7 
)
taskkill /f /im Cortana.exe >nul 2>&1
if %errorlevel% == 0 ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Killed 6 Cortana.exe 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 8 
)
tasklist > %file%
@ping -n 1 localhost> nul
if %select% == 4 ( goto second_execute_2 )
:: Modify Windows Search (disable searching the web) (admin required)
:reg_cmd rem Start of REG edits 1
set timestamp=%date%
set "file=REG_edit_output_%timestamp%.txt"
reg query "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer\DisableSearchBoxSuggestions" > nul 2>&1
if %errorlevel% == 1 ( 
    reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >%file%
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Created DisableSearchBoxSuggestions registry key
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 9
)
:: Disable Error Report (at application crash) (admin required)
set timestamp=%date%
set "file=REG_edit2_output_%timestamp%.txt"
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\Windows Error Reporting\LocalDumps\DoNotPromptForNonCriticalErrors" >nul 2>&1
if %errorlevel% == 1 (
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\Windows Error Reporting\LocalDumps" /v DoNotPromptForNonCriticalErrors /t REG_DWORD /d 1 /f >%file%
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Created DoNotPromptForNonCriticalErrors registry key 
) else (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 10
)
:: Disable Windows Telemetry (admin required)
set timestamp=%date%
set "file=REG_edit3_output_%timestamp%.txt"
:: Check if telemetry is already disabled
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection\AllowTelemetry" >nul 2>&1
if %errorlevel% == 1 (
:: Disable telemetry (admin required)
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v DisableEnterpriseAuthProxy /t REG_DWORD /d 1 /f >%file%
:: Stop and disable DiagTrack service (admin required)
    sc stop DiagTrack >nul 2>&1
    sc config DiagTrack start= disabled >nul 2>&1
:: Stop and disable dmwappushservice (admin required)
    sc stop dmwappushservice >nul 2>&1
    sc config dmwappushservice start= disabled >nul 2>&1
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Windows Telemetry disabled successfully
) else (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> No changes made while executing command at 11
)
:: Disable Disable Compatibility Assistant (admin required)
set %timestamp%=%date%
set "file=REG_edit4_output_%timestamp%.txt"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\AppCompat" /v DisableUAR /t REG_DWORD /d 1 /f >nul 2>&1
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Created DisableCompatibilityAssistant registry key
)
gpupdate /force > %file% disabled >nul 2>&1
if %errorlevel% == 1 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 12
)
:: Disable Remote Registry service (admin required)
set %timestamp%=%date%
set "file=REG_edit5_output_%timestamp%.txt"
sc config RemoteRegistry start= disabled >%file%
if %errorlevel% equ 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Remote Registry service disabled successfully
) else (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> No changes made while executing command at 13
)
:: Disable Cortana (admin required)
set %timestamp%=%date%
set "file=REG_edit6_output_%timestamp%.txt" 
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1 
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Created DisableCortana registry key
) else (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> No changes made while executing command at 14
)
:: Disable Windows Remote Management service (admin required)
set %timestamp%=%date%
set "file=Stop_RM_output_%timestamp%.txt"
sc config WinRM start= disabled >%file%
if %errorlevel% equ 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Windows Remote Management service disabled successfully
) else (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> No changes made while executing command at 15
)
if %select% == 3 ( goto end )
:: Reset IPstack
:second_execute_2 rem Start of exclude reg (second run)
:network_cmd_2 rem Start of network section 2
set timestamp=%date%
set "file=IPstack_output_%timestamp%.txt"
netsh int ip reset > %file%
if %errorlevel% == 0 ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Cleared IP stack 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 16
)
@ping -n 1 localhost> nul
:: TCP edit (idk if admin required)
set timestamp=%date%
set "file=TCP_edit_output_%timestamp%.txt"
netsh int tcp set heuristics disabled > %file%
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> TCP has been configurated 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 17
)
@ping -n 1 localhost> nul
:: Clear ARP (admin required)
set timestamp=%date%
set "file=Clear_ARP_output_%timestamp%.txt"
arp -d * > %file%
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> ARP has been cleared 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 18
)
if %select% == 2 ( goto end )
:: Restart Explorer.exe (no admin required)
set "file=KILL_explorer_output_%timestamp%.txt"
taskkill /f /im explorer.exe >nul 2>&1 >%file%
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Killed explorer 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 19
)
@ping -n 1 localhost> nul
start explorer.exe >nul 2>&1
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Started explorer 
) else (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 20
)
@ping -n 1 localhost> nul
:: Restart Audiosrv (admin required)
set "file=Restart_audio_output_%timestamp%.txt"
net stop audiosrv > %file%
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Paused audiosrv 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 21
)
@ping -n 1 localhost> nul
net start audiosrv > nul 2>&1
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Started audiosrv 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 22
)
@ping -n 1 localhost> nul
:: Disk Cleanup
set "file=Disk_output_%timestamp%.txt"
cleanmgr /sagerun:1 > %file%
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Cleaned Disk successfully 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 23
)
@ping -n 1 localhost> nul
:: Clear Windows Temp / Bin (don't run with admin)
start cmd /c del "%temp%\*.*" /s /q /f
start cmd /c rd /s /q C:\$Recycle.Bin
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Cleared Windows Temp 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 24
)
@ping -n 1 localhost> nul
:: Ask for sfc (admin required)
:end
echo.
set timestamp=%date%
set "file=sfc_output_%timestamp%.txt"
echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> You can perform a file scan to check your system
set /p sfc="Perform a file scan (y/N): "
if %sfc% == y ( 
    sfc /scannow > %file% 
) else ( 
    goto skipsfc 
)
if %errorlevel% == 0 (
    goto skipsfc
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 25
)
:skipsfc
:: Ask for addons
echo.
@ping -n 1 localhost> nul
echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Do you want to execute addons as well
set /p addons="Use addons (list/N): "
if %addons% == list (
    echo.
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> sysfix.bat
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> driverfix.bat
) else (
    goto end
)
set /p exaddons="Select your addon (addon/N): "
if %exaddons% == sysfix.bat (
    cd ..
    cd addons && start sysfix.bat
)
if %exaddons% == driverfix.bat (
    cd ..
    cd addons && start driverfix
) else (
    goto end
)
:: End of the script / Restart
:end
echo.
echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> You need to restart your computer for all the commands to work
set /p restart="Restart your pc (y/N): "
if %restart% == y ( 
    shutdown /r /f /t 1 
) else (
    exit 
)
start cmd.exe /c @echo off && ping -n 2 localhost> nul 2>&1
exit
