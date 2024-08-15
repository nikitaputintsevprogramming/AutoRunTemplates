@echo off
chcp 65001 >nul
set logfile="log.txt"

:: Установка рабочей директории в директорию скрипта
cd /d "%~dp0"

:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Требуются права администратора. Перезапуск...
    powershell start-process -verb runas -filepath "%~dpnx0"
    exit /b
)

echo ==============================
echo Запуск скрипта: %date% %time%
echo ============================== >> %logfile%
echo Запуск скрипта: %date% %time% >> %logfile%

:: Путь к папке автозагрузки текущего пользователя
set autostartFolder=%AppData%\Microsoft\Windows\Start Menu\Programs\Startup

:: Имя ярлыка
set shortcutName=QuizLauncher.lnk

:: Путь к текущему батнику
set scriptPath=%~dpnx0

:: Путь к ярлыку
set shortcutPath=%autostartFolder%\%shortcutName%

:: Проверка, существует ли ярлык в папке автозагрузки
if not exist "%shortcutPath%" (
    echo Ярлык не найден, создаем ярлык...
    echo Ярлык не найден, создаем ярлык... >> %logfile%
    
    :: Создание ярлыка с помощью PowerShell
    powershell -command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%shortcutPath%'); $s.TargetPath = '%scriptPath%'; $s.Save()"
    
    echo Ярлык создан: %shortcutPath%
    echo Ярлык создан: %shortcutPath% >> %logfile%
) else (
    echo Ярлык уже существует: %shortcutPath%
    echo Ярлык уже существует: %shortcutPath% >> %logfile%
)

:: Абсолютный путь к приложению
set exePath=%~dp0QUIZ\Quiz_interactiveMap.exe

echo Завершение explorer.exe...
echo Завершение explorer.exe... >> %logfile%
taskkill /f /im explorer.exe >> %logfile%

echo Запуск приложения %exePath%...
echo Запуск приложения %exePath%... >> %logfile%
start "" "%exePath%"

:wait_for_close
timeout /t 1 /nobreak >nul
tasklist | find /i "Quiz_interactiveMap.exe" >nul
if not errorlevel 1 goto wait_for_close

echo Приложение закрыто, перезапуск explorer.exe...
echo Приложение закрыто, перезапуск explorer.exe... >> %logfile%
start explorer.exe

echo Скрипт завершен: %date% %time%
echo Скрипт завершен: %date% %time% >> %logfile%
