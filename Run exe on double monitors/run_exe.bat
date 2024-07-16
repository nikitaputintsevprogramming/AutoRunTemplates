@REM --------------- запуск двух окон на двух экранах с помощью утилиты Nircmd ---------------
@echo off

REM Setting variables for the application path and executable name
set "APP_PATH=%~dp0Configurator\Car_Configurator.exe"
set "APP_EXE=Car_Configurator.exe"
set "NIRCMD_PATH=%~dp0nircmd-x64\nircmdc.exe"

REM Stopping the explorer process
taskkill /F /IM explorer.exe

if %ERRORLEVEL% NEQ 0 (
    echo Error stopping explorer.
    echo Restarting explorer...
    start explorer.exe
    echo Done!
    pause
    exit /b %ERRORLEVEL%
)

REM Set the first screen as primary
echo Setting the first screen as primary...
"%NIRCMD_PATH%" setprimarydisplay 1

REM Launch the first instance of the application on the first screen
echo Launching the first instance of %APP_EXE%...
start "" "%APP_PATH%"

REM Wait for the first instance to launch
timeout /T 5 /NOBREAK >NUL

REM Set the second screen as primary
echo Setting the second screen as primary...
"%NIRCMD_PATH%" setprimarydisplay 2

REM Launch the second instance of the application on the second screen
echo Launching the second instance of %APP_EXE%...
start "" "%APP_PATH%"

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
pause





@REM @REM --------------- запуск двух окон ---------------
@REM @echo off

@REM REM Установка переменных пути и имени процесса
@REM set APP_PATH=%~dp0Configurator\Car_Configurator.exe
@REM set APP_EXE=Car_Configurator.exe

@REM REM Остановка процесса explorer
@REM taskkill /F /IM explorer.exe

@REM if %ERRORLEVEL% NEQ 0 (
@REM     echo Ошибка при остановке explorer.
@REM     echo Перезапуск процесса explorer...
@REM     start explorer.exe
@REM     echo Готово!
@REM     pause
@REM     exit /b %ERRORLEVEL%
@REM )

@REM REM Запуск первого экземпляра приложения на первом экране
@REM echo Запуск первого экземпляра %APP_EXE%...
@REM start "" /MAX "%APP_PATH%"

@REM REM Ожидание запуска первого экземпляра
@REM timeout /T 5 /NOBREAK >NUL

@REM REM Запуск второго экземпляра приложения на втором экране
@REM echo Запуск второго экземпляра %APP_EXE%...
@REM start "" /MAX "%APP_PATH%"

@REM REM Ожидание завершения работы приложений
@REM :wait_for_exit
@REM tasklist /FI "IMAGENAME eq %APP_EXE%" 2>NUL | find /I /N "%APP_EXE%" >NUL
@REM if "%ERRORLEVEL%"=="0" (
@REM     timeout /T 5 /NOBREAK >NUL
@REM     goto wait_for_exit
@REM )

@REM echo Все экземпляры %APP_EXE% завершены.
@REM echo Перезапуск процесса explorer...
@REM start explorer.exe

@REM echo Готово!
@REM pause







@REM --------------- запуск одного окна ---------------

@REM @REM @echo off

@REM REM Установка переменных пути и имени процесса
@REM set APP_PATH=%~dp0Configurator\Car_Configurator.exe
@REM set APP_EXE=Car_Configurator.exe

@REM echo Остановка процесса explorer...
@REM taskkill /F /IM explorer.exe

@REM if %ERRORLEVEL% NEQ 0 (
@REM     echo Ошибка при остановке explorer.
@REM     echo Перезапуск процесса explorer...
@REM     start explorer.exe
@REM     echo Готово!
@REM     pause
@REM     exit /b %ERRORLEVEL%
@REM )

@REM echo Запуск %APP_EXE%...
@REM start "" "%APP_PATH%"

@REM if %ERRORLEVEL% NEQ 0 (
@REM     echo Ошибка при запуске %APP_EXE%.
@REM     echo Перезапуск процесса explorer...
@REM     start explorer.exe
@REM     echo Готово!
@REM     pause
@REM     exit /b %ERRORLEVEL%
@REM )

@REM echo %APP_EXE% запущен успешно.

@REM :wait_for_exit
@REM REM Ждем завершения %APP_EXE%
@REM tasklist /FI "IMAGENAME eq %APP_EXE%" 2>NUL | find /I /N "%APP_EXE%" >NUL
@REM REM Проверяем наличие процесса %APP_EXE%
@REM if "%ERRORLEVEL%"=="0" (
@REM     timeout /T 5 /NOBREAK >NUL
@REM     goto wait_for_exit
@REM )

@REM echo %APP_EXE% завершен.
@REM echo Перезапуск процесса explorer...
@REM start explorer.exe

@REM echo Готово!
@REM pause
