@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% neq 0 ( goto UACPrompt ) else ( goto :start )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
    "%temp%\GetAdmin.vbs"
    del "%temp%\GetAdmin.vbs"
    exit /B
:: Display Header and Watermark
:start
cd /d "%~dp0"
:header
cd header 
title Loading...
type jqvon.txt
timeout -t 1 > nul
cls
type header.txt
cd ..\..
echo.
echo.
cd .main/info
echo Executed on [%computername%] by [%username%] on [%date%] at [%time%] with [Windows 10/11/8/7] > .%computername%
title IC - Optimizer V 2.0
for /f "tokens=*" %%a in ('wmic cpu get name^,numberofcores^,numberoflogicalprocessors') do set "cpu=%%a"
SETLOCAL ENABLEDELAYEDEXPANSION
set lang=%SystemRoot%\System32\wbem\wmic.exe os get locale
:: Clear DNS (no admin required)
set timestamp=%date%
set "file=DNS_output_%timestamp%.txt"
ipconfig /flushdns > %file%
@ping -n 1 localhost> nul
if %errorlevel% == 0 ( echo [*] ^> Cleared DNS cache ) else ( echo [*] ^> Error while executing command at 34 )
:: Reset Network Adapter (admin required)
set timestamp=%date%
set "file=Network_clear_output_%timestamp%.txt"
netsh winsock reset > %file%
@ping -n 1 localhost> nul
if %errorlevel% == 0 ( echo [*] ^> Reset Network Adapter ) else ( echo [*] ^> Error while executing command at 40 )
:: Kill Processes (admin required) 
set timestamp=%date%
set "file=KILL_output_%timestamp%.txt"
taskkill /f /im NewsAndInterests.exe >nul 2>&1
if %errorlevel% == 0 ( echo [*] ^> Killed 1 ) else ( echo [*] ^> Error while executing command at 45 )
taskkill /f /im OneDrive.exe >nul 2>&1
if %errorlevel% == 0 ( echo [*] ^> Killed 2 ) else ( echo [*] ^> Error while executing command at 47 )
taskkill /f /im ctfmon.exe >nul 2>&1
if %errorlevel% == 0 ( echo [*] ^> Killed 3 ) else ( echo [*] ^> Error while executing command at 49 )
taskkill /f /im PhoneExperienceHost.exe >nul 2>&1
if %errorlevel% == 0 ( echo [*] ^> Killed 4 ) else ( echo [*] ^> Error while executing command at 51 )
taskkill /f /im GrooveMusic.exe >nul 2>&1
if %errorlevel% == 0 ( echo [*] ^> Killed 5 ) else ( echo [*] ^> Error while executing command at 53 )
taskkill /f /im Cortana.exe >nul 2>&1
if %errorlevel% == 0 ( echo [*] ^> Killed 6 ) else ( echo [*] ^> Error while executing command at 55 )
tasklist > %file%
@ping -n 1 localhost> nulcx
:: Modify Windows Search (disable searching the web) (admin required)
set timestamp=%date%
set "file=REG_edit_output_%timestamp%.txt"
reg query "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" > nul 2>&1
if %errorlevel% == 1 ( 
    reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f  >nul 2>&1
    echo [*] ^> Created DisableSearchBoxSuggestions registry key
) else ( 
    echo [*] ^> Error while executing command at 58
)
:: Disable Error Report (at application crash) (admin required)
set timestamp=%date%
set "file=REG_edit2_output_%timestamp%.txt"
reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\Windows Error Reporting\LocalDumps\DoNotPromptForNonCriticalErrors" >nul 2>&1
if %errorlevel% == 1 (
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\Windows Error Reporting\LocalDumps" /v DoNotPromptForNonCriticalErrors /t REG_DWORD /d 1 /f >nul 2>&1
    echo [*] ^> Created DoNotPromptForNonCriticalErrors registry key 
) else (
    echo [*] ^> Error while executing command at 76
)
:: Restart Explorer.exe (no admin required)
set "file=KILL_explorer_output_%timestamp%.txt"
taskkill /f /im explorer.exe > %file%
if %errorlevel% == 0 ( echo [*] ^> Killed explorer ) else ( echo [*] ^> Error while executing command at 81 )
@ping -n 1 localhost> nul
start explorer.exe
if %errorlevel% == 0 ( echo [*] ^> Started explorer ) else ( echo [*] ^> Error while executing command at 84 )
@ping -n 1 localhost> nul
:: Restart Audiosrv (admin required)
set "file=Restart_audio_output_%timestamp%.txt"
net stop audiosrv > %file% > nul 2>&1
if %errorlevel% == 0 ( echo [*] ^> Paused audiosrv ) else ( echo [*] ^> Error while executing command at 89 )
@ping -n 1 localhost> nul
net start audiosrv > nul 2>&1
if %errorlevel% == 0 ( echo [*] ^> Started audiosrv ) else ( echo [*] ^> Error while executing command at 92 )
@ping -n 1 localhost> nul
:: Clear Windows Temp / Bin (don't run with admin)
start cmd /c del "%temp%\*.*" /s /q /f rem no admin
start cmd /c rd /s /q C:\$Recycle.Bin
if %errorlevel% == 0 ( echo [*] ^> Cleared Windows Temp ) else ( echo [*] ^> Error while executing command at 97 )
@ping -n 1 localhost> nul
:: Ask for sfc (admin required)
set timestamp=%date%
set "file=sfc_output_%timestamp%.txt"
set /p sfc="Perform a file scan (y/N): "
if sfc == y ( sfc /scannow > %file% ) else ( goto skipsfc )
if %errorlevel% == 0 ( echo [*] ^> Scan complete ) else ( echo [*] ^> Error while executing command at 104 )
:skipsfc
@ping -n 1 localhost> nul
:: End of the script / Restart
echo.
echo [*] ^> You need to restart your computer for all the commands to work
set /p restart="Restart your pc (y/N): "
if %restart% == y ( shutdown /r /f /t 1 ) else ( exit )
start cmd.exe /c @echo off && ping -n 2 localhost> nul 2>&1
exit