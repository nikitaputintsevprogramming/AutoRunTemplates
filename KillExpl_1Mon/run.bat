@echo off
chcp 65001
setlocal enabledelayedexpansion

set "APP_PATH=%~dp0Dedoslavl\Dedoslavl.exe"
set "SHORTCUT_PATH=%~dp0run.bat"
set "SHORTCUT_NAME=Dedoslavl.lnk"
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
@REM C:\Users\User\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

if not exist "%STARTUP_FOLDER%\%SHORTCUT_NAME%" (
    echo Creating shortcut in Startup folder...
    powershell -command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%STARTUP_FOLDER%\%SHORTCUT_NAME%');$s.TargetPath='%SHORTCUT_PATH%';$s.Save()"
    if %ERRORLEVEL% EQU 0 (
        echo Shortcut created successfully.
    ) else (
        echo Failed to create shortcut.
    )
) else (
    echo Shortcut already exists in Startup folder.
)

echo Stopping the explorer process
taskkill /F /IM explorer.exe

if !ERRORLEVEL! NEQ 0 (
    echo Error stopping explorer.
    echo Restarting explorer...
    start explorer.exe
    echo Done!
    pause
    exit /b !ERRORLEVEL!
)

REM Launch the first instance of the application on the first screen
    echo Launching the first instance of %APP_PATH%...
    start "" "%APP_PATH%"

    REM Wait for the first instance to launch
    timeout /T 5 /NOBREAK >NUL

REM Wait for applications to finish
:wait_for_exit
tasklist /FI "IMAGENAME eq Dedoslavl.exe" 2>NUL | find /I /N "Dedoslavl.exe" >NUL
if "!ERRORLEVEL!"=="0" (
    timeout /T 5 /NOBREAK >NUL
    goto wait_for_exit
)

echo All instances of Dedoslavl.exe are finished.
echo Restarting explorer...
start explorer.exe

echo Done!
timeout /t 2 /nobreak
exit /b
