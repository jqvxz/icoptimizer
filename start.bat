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
echo.
echo [!] This version of icoptimizer is outdated please install icoptimizer-remake
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
title IC - Optimizer v3.6
SETLOCAL ENABLEDELAYEDEXPANSION
set lang=%SystemRoot%\System32\wbem\wmic.exe os get locale
:: Select script (no admin)
echo %YELLOW%[%CYAN%1%YELLOW%]%RESET% ^> Execute all commands (recommended)
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
:: Disable Windows Stickey keys
set %timestamp%=%date%
set "file=StickyKeys_output_%timestamp%.txt"
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "506" /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "StickyKeysEnabled" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "HotkeyTriggered" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "AudibleFeedback" /t REG_DWORD /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility" /v "KeyboardPreference" /t REG_DWORD /d "0" /f >nul 2>&1

reg query "HKCU\Control Panel\Accessibility\StickyKeys" /v "StickyKeysEnabled" >%file%
if %errorlevel% equ 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Windows StickyKeys disabled successfully
) else (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while disable StickeyKeys at 16
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
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 17
)
@ping -n 1 localhost> nul
:: TCP edit (idk if admin required)
set timestamp=%date%
set "file=TCP_edit_output_%timestamp%.txt"
netsh int tcp set heuristics disabled > %file%
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> TCP has been configurated 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 18
)
@ping -n 1 localhost> nul
:: Clear ARP (admin required)
set timestamp=%date%
set "file=Clear_ARP_output_%timestamp%.txt"
arp -d * > %file%
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> ARP has been cleared 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 19
)
if %select% == 2 ( goto end )
:: Restart Explorer.exe (no admin required)
set "file=KILL_explorer_output_%timestamp%.txt"
taskkill /f /im explorer.exe >nul 2>&1 >%file%
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Killed explorer 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 20
)
@ping -n 1 localhost> nul
start explorer.exe >nul 2>&1
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Started explorer 
) else (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 21
)
@ping -n 1 localhost> nul
:: Restart Audiosrv (admin required)
set "file=Restart_audio_output_%timestamp%.txt"
net stop audiosrv > %file%
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Paused audiosrv 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 22
)
@ping -n 1 localhost> nul
net start audiosrv > nul 2>&1
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Started audiosrv 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 23
)
@ping -n 1 localhost> nul
:: Disk Cleanup
set "file=Disk_output_%timestamp%.txt"
cleanmgr /sagerun:1 > %file%
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Cleaned Disk successfully 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 24
)
@ping -n 1 localhost> nul
:: Clear Windows Temp / Bin (don't run with admin)
start cmd /c del "%temp%\*.*" /s /q /f
start cmd /c rd /s /q C:\$Recycle.Bin
if %errorlevel% == 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Cleared Windows Temp 
) else ( 
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 25
)
@ping -n 1 localhost> nul
:: Scan for useless programs
set installed=0
:: Check for McAfee
reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{26C36889-3AE9-467D-8D32-79AF9D5E644A}" >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> 1. Problematic program is not installed
) else (
    reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{26C36889-3AE9-467D-8D32-79AF9D5E644A}" /v DisplayName 2>nul | findstr /i /c:"McAfee" >nul
    if errorlevel 0 (
        echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Please remove McAfee
        set installed=1
    ) else (
        echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> 1. Problematic program is not installed
    )
)
:: Check for RAV Protection
reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{A659376D-C397-4F52-9479-6B189509045E}" >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> 2. Problematic program is not installed
) else (
    reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{A659376D-C397-4F52-9479-6B189509045E}" /v DisplayName 2>nul | findstr /i /c:"RAV" >nul
    if errorlevel 0 (
        echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Please remove RAV Protection
        set installed=1
    ) else (
        echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> 2. Problematic program is not installed
    )
)
:: Check for Norton Security
reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{8C704500-4BF2-11D1-9F44-00C04FC295EE}" >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> 3. Problematic program is not installed
) else (
    reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{8C704500-4BF2-11D1-9F44-00C04FC295EE}" /v DisplayName 2>nul | findstr /i /c:"Norton" >nul
    if errorlevel 0 (
        echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Please remove Norton Security
        set installed=1
    ) else (
        echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> 3. Problematic program is not installed
    )
)
:: Check for Avast Antivirus
reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{E6F465A5-1FB8-406F-99C0-7E3E10C4B55A}" >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> 4. Problematic program is not installed
) else (
    reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{E6F465A5-1FB8-406F-99C0-7E3E10C4B55A}" /v DisplayName 2>nul | findstr /i /c:"Avast" >nul
    if errorlevel 0 (
        echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Please remove Avast Antivirus
        set installed=1
    ) else (
        echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> 4. Problematic program is not installed 
    )
)
:: Check for Kaspersky Security
reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{2F617D7C-D9AA-4D74-9182-2A0F36EEDCB4}" >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> 5. Problematic program is not installed 
) else (
    reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{2F617D7C-D9AA-4D74-9182-2A0F36EEDCB4}" /v DisplayName 2>nul | findstr /i /c:"Kaspersky" >nul
    if errorlevel 0 (
        echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Consider removing Kaspersky Security
        set installed=1
    ) else (
        echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> 5. Problematic program is not installed 
    )
)
:: Check for AVG Antivirus
reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{B056A5B5-1E98-4872-8779-5BB072220D6E}" >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> 6. Problematic program is not installed 
) else (
    reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{B056A5B5-1E98-4872-8779-5BB072220D6E}" /v DisplayName 2>nul | findstr /i /c:"AVG" >nul
    if errorlevel 0 (
        echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Please remove AVG Antivirus
        set installed=1
    ) else (
        echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> 6. Problematic program is not installed 
    )
)
:: Check for Bitdefender
reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{DCE31E58-CB4F-4A90-9232-5FDCB2A97C98}" >nul 2>&1
if %errorlevel% neq 0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> 7. Problematic program is not installed 
) else (
    reg query "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{DCE31E58-CB4F-4A90-9232-5FDCB2A97C98}" /v DisplayName 2>nul | findstr /i /c:"Bitdefender" >nul
    if errorlevel 0 (
        echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Consider removing Bitdefender
        set installed=1
    ) else (
        echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> 7. Problematic program is not installed 
    )
)
:: Create file and message
set timestamp=%date%
set "file=Programs_output_%timestamp%.txt"
if %installed%==0 (
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Scanned for McAfee, RAV, Norton, Avast, Kaspersky, AVG, Bitdefender
)
echo Value of installed = %installed% > %file%
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
    echo %YELLOW%[%CYAN%*%YELLOW%]%RESET% ^> Error while executing command at 26
)
:skipsfc
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
