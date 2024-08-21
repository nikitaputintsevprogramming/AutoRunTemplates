@echo off
chcp 65001
setlocal enabledelayedexpansion

set "APP_PATH=%~dp0Configurator\Car_Configurator.exe"
set "SHORTCUT_PATH=%~dp0..\Run_exe.bat"
set "SHORTCUT_NAME=Car_Configurator.lnk"
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "NIRCMD_PATH=%~dp0nircmd-x64\nircmd.exe"

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

timeout /t 11 /nobreak

REM Check if nircmd.exe exists
if not exist "%NIRCMD_PATH%" (
    echo Error: nircmd.exe not found at %NIRCMD_PATH%
    exit /b 1
)

@REM echo Stopping the explorer process
@REM taskkill /F /IM explorer.exe

@REM if !ERRORLEVEL! NEQ 0 (
@REM     echo Error stopping explorer.
@REM     echo Restarting explorer...
@REM     start explorer.exe
@REM     echo Done!
@REM     pause
@REM     exit /b !ERRORLEVEL!
@REM )


set "file=%~dp0..\input.txt"

REM Display current value from the file if it exists
if exist "%file%" (
    echo Current value in file %file%:
    type "%file%"
) else (
    echo File %file% not found. A new one will be created.
)

REM Read the content of the file into a variable
set /p fileValue=<"%file%"

REM Remove any trailing spaces or newlines from the value
set "fileValue=%fileValue: =%"

REM Check the value and perform actions
if "%fileValue%"=="1" (
    REM Set the first screen as primary
    echo Setting the first screen as primary...
    "%NIRCMD_PATH%" setprimarydisplay 1

    timeout /T 5 /NOBREAK >NUL

    REM Launch the first instance of the application on the first screen
    echo Launching the first instance of %APP_PATH%...
    start "" "%APP_PATH%"

    REM Wait for the first instance to launch
    timeout /T 5 /NOBREAK >NUL

    REM Set the second screen as primary
    echo Setting the second screen as primary...
    for /L %%i in (2,1,5) do (
        "%NIRCMD_PATH%" setprimarydisplay %%i
        echo Primary display set to %%i
        timeout /t 2 /nobreak >nul
    )

    REM Launch the second instance of the application on the second screen
    echo Launching the second instance of %APP_PATH%...
    start "" "%APP_PATH%"

) else if "%fileValue%"=="0" (
    REM Set the second screen as primary
    echo Setting the second screen as primary...
    for /L %%i in (2,1,5) do (
        "%NIRCMD_PATH%" setprimarydisplay %%i
        echo Primary display set to %%i
        timeout /t 2 /nobreak >nul
    )

    REM Launch the second instance of the application on the second screen
    echo Launching the second instance of %APP_PATH%...
    start "" "%APP_PATH%"

    REM Wait for the first instance to launch
    timeout /T 5 /NOBREAK >NUL

    REM Set the first screen as primary
    echo Setting the first screen as primary...
    "%NIRCMD_PATH%" setprimarydisplay 1

    timeout /T 5 /NOBREAK >NUL

    REM Launch the first instance of the application on the first screen
    echo Launching the first instance of %APP_PATH%...
    start "" "%APP_PATH%"
) else (
    echo Error reading screen configuration, what value is in input.txt?
)

echo Press Space or Enter to reload explorer.exe %APP_PATH%...

REM Wait for applications to finish
:wait_for_exit
tasklist /FI "IMAGENAME eq Car_Configurator.exe" 2>NUL | find /I /N "Car_Configurator.exe" >NUL
if "!ERRORLEVEL!"=="0" (
    timeout /T 5 /NOBREAK >NUL
    goto wait_for_exit
)

echo All instances of Car_Configurator.exe are finished.
echo Restarting explorer...
start explorer.exe

echo Done!
timeout /t 2 /nobreak
exit /b
