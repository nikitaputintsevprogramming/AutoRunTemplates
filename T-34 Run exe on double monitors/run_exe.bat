@REM --------------- запуск двух окон на двух экранах с проверкой конфигурации и автозагрузкой ---------------
@echo off

REM Установка переменных пути и имени процесса
set "APP_PATH=%~dp0Configurator\Car_Configurator.exe"
set "APP_EXE=Car_Configurator.exe"
set "NIRCMD_PATH=%~dp0nircmd-x64\nircmdc.exe"
set "SHORTCUT_NAME=Car_Configurator.lnk"
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "CONFIG_FILE=%~dp0screen_config.txt"
set "DEFAULT_CONFIG=1"

REM Проверка наличия ярлыка в автозагрузке
if not exist "%STARTUP_FOLDER%\%SHORTCUT_NAME%" (
    echo Creating shortcut in Startup folder...
    "%NIRCMD_PATH%" shortcut "%APP_PATH%" "%STARTUP_FOLDER%\%SHORTCUT_NAME%"
    if %ERRORLEVEL% EQU 0 (
        echo Shortcut created successfully.
    ) else (
        echo Failed to create shortcut.
    )
) else (
    echo Shortcut already exists in Startup folder.
)

REM Проверка, существовал ли успешный запуск ранее
if exist "%CONFIG_FILE%" (
    set /p CONFIG=<"%CONFIG_FILE%"
) else (
    echo %DEFAULT_CONFIG% > "%CONFIG_FILE%"
    set CONFIG=%DEFAULT_CONFIG%
)

REM Спросить пользователя о последнем запуске экранов
set /p "USER_INPUT=Did the screens work correctly in the last launch? (y/n): " <nul
timeout /t 7 /nobreak >nul
if not defined USER_INPUT (
    echo No response, continuing with previous configuration...
) else if /i "%USER_INPUT%"=="n" (
    REM Меняем конфигурацию, если был ответ "n"
    if "%CONFIG%"=="1" (
        set CONFIG=2
    ) else (
        set CONFIG=1
    )
    echo %CONFIG% > "%CONFIG_FILE%"
)

REM Остановка процесса explorer
taskkill /F /IM explorer.exe
if %ERRORLEVEL% NEQ 0 (
    echo Error stopping explorer.
    echo Restarting explorer...
    start explorer.exe
    echo Done!
    pause
    exit /b %ERRORLEVEL%
)

REM Запуск конфигурации экранов в зависимости от сохранённого состояния
if "%CONFIG%"=="1" (
    echo Setting the first screen as primary...
    "%NIRCMD_PATH%" setprimarydisplay 1
    timeout /t 5 /nobreak >nul

    echo Launching the first instance of %APP_EXE%...
    start "" "%APP_PATH%"
    
    timeout /t 5 /nobreak >nul

    echo Setting the second screen as primary...
    for /L %%i in (2,1,5) do (
        "%NIRCMD_PATH%" setprimarydisplay %%i
        echo Primary display set to %%i
        timeout /t 2 /nobreak >nul
    )
) else (
    echo Setting the second screen as primary...
    for /L %%i in (2,1,5) do (
        "%NIRCMD_PATH%" setprimarydisplay %%i
        echo Primary display set to %%i
        timeout /t 2 /nobreak >nul
    )

    timeout /t 5 /nobreak >nul

    echo Launching the first instance of %APP_EXE%...
    start "" "%APP_PATH%"

    timeout /t 5 /nobreak >nul

    echo Setting the first screen as primary...
    "%NIRCMD_PATH%" setprimarydisplay 1
)

REM Запуск второго экземпляра приложения на втором экране
echo Launching the second instance of %APP_EXE%...
start "" "%APP_PATH%"

echo Press Space or Enter to reload explorer.exe %APP_EXE%...

REM Ожидание завершения работы приложений
:wait_for_exit
tasklist /FI "IMAGENAME eq %APP_EXE%" 2>NUL | find /I /N "%APP_EXE%" >NUL
if "%ERRORLEVEL%"=="0" (
    timeout /t 5 /nobreak >nul
    goto wait_for_exit
)

REM Завершение работы
echo All instances of %APP_EXE% are finished.
echo Restarting explorer...
start explorer.exe
echo Done!
pause
