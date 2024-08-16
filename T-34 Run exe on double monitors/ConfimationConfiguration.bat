@REM --------------- запуск двух окон на двух экранах с помощью утилиты Nircmd ---------------
@echo off
chcp 65001 >nul

REM Setting variables for the application path and executable name
set "APP_PATH=%~dp0Configurator\Car_Configurator.exe"
set "APP_EXE=Car_Configurator.exe"
set "NIRCMD_PATH=%~dp0nircmd-x64\nircmdc.exe"
set "SHORTCUT_NAME=Car_Configurator.lnk"
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

REM Function to create a shortcut if it doesn't exist
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

@REM REM Stopping the explorer process
@REM taskkill /F /IM explorer.exe

@REM if %ERRORLEVEL% NEQ 0 (
@REM     echo Error stopping explorer.
@REM     echo Restarting explorer...
@REM     start explorer.exe
@REM     echo Done!
@REM     pause
@REM     exit /b %ERRORLEVEL%
@REM )

setlocal

set "file=input.txt"

:: Показать текущее значение из файла, если файл существует
if exist "%file%" (
    echo Текущее значение в файле %file%:
    type "%file%"
) else (
    echo Файл %file% не найден. Будет создан новый.
)

REM Запускаем таймер в фоновом потоке
@REM start "" /b cmd /c "timeout /t 10 /nobreak >nul & echo Время ожидания истекло. Программа завершена. & exit /b"
@REM start "" /b cmd /c "timeout /t 10 /nobreak >nul & echo Время ожидания истекло. Программа завершена. & taskkill /f /im cmd.exe >nul 2>&1"
start "" /b cmd /c "timeout /t 10 /nobreak >nul & echo Время ожидания истекло. Ввод завершен. " 

:question
REM Задаем вопрос
set /p user_input=В последний раз была удачная конфигурация? (y/n) или пропустите ответ, чтобы продолжить без изменений:

:defrun
user_input = %file%
echo "hello"

if "%user_input%"=="" set "user_input=%file%"

:: Проверяем введенное значение и сохраняем его в файл
if /i "%user_input%"=="y" (
    
    echo y > "%file%"
    REM Set the first screen as primary
    echo Setting the first screen as primary...
    "%NIRCMD_PATH%" setprimarydisplay 1

    timeout /T 5 /NOBREAK >NUL

    REM Launch the first instance of the application on the first screen
    echo Launching the first instance of %APP_EXE%...
    start "" "%APP_PATH%"

    REM Wait for the first instance to launch
    timeout /T 5 /NOBREAK >NUL

    REM Set the second screen as primary
    echo Setting the second screen as primary...
    @REM "%NIRCMD_PATH%" setprimarydisplay 2
    @echo off
    for /L %%i in (2,1,5) do (
        "%NIRCMD_PATH%" setprimarydisplay %%i
        echo Primary display set to %%i
        timeout /t 2 /nobreak >nul
    )

    REM Launch the second instance of the application on the second screen
    echo Launching the second instance of %APP_EXE%...
    start "" "%APP_PATH%"
) else (
    if /i "%user_input%"=="n" (
        REM Set the second screen as primary
        echo Setting the second screen as primary...
        @REM "%NIRCMD_PATH%" setprimarydisplay 2
        @echo off
        for /L %%i in (2,1,5) do (
            "%NIRCMD_PATH%" setprimarydisplay %%i
            echo Primary display set to %%i
            timeout /t 2 /nobreak >nul
        )

        REM Launch the second instance of the application on the second screen
        echo Launching the second instance of %APP_EXE%...
        start "" "%APP_PATH%"
        @REM REM Wait for the first instance to launch
        @REM timeout /T 5 /NOBREAK >NUL

        REM Set the first screen as primary
        echo Setting the first screen as primary...
        "%NIRCMD_PATH%" setprimarydisplay 1

        timeout /T 5 /NOBREAK >NUL

        REM Launch the first instance of the application on the first screen
        echo Launching the first instance of %APP_EXE%...
        start "" "%APP_PATH%"

    ) else (
        @REM echo Введено неверное значение. Пожалуйста, введите "y" или "n". > "%file%"
        echo Введено неверное значение. Пожалуйста, введите "y" или "n".
        goto :question 
    )
)





echo Press Space or Enter to reload explorer.exe %APP_EXE%...

REM Wait for applications to finish
:wait_for_exit
tasklist /FI "IMAGENAME eq %APP_EXE%" 2>NUL | find /I /N "%APP_EXE%" >NUL
if "%ERRORLEVEL%"=="0" (
    timeout /T 5 /NOBREAK >NUL
    goto wait_for_exit
)

echo All instances of %APP_EXE% are finished.
echo Restarting explorer...
start explorer.exe

echo Done!
@REM pause
