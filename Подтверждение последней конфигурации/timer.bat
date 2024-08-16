@echo off
chcp 65001 >nul

setlocal enabledelayedexpansion

:: Создаем временный файл для хранения состояния таймера
set "timeout_file=%temp%\timeout.txt"

:: Запускаем таймер в фоновом режиме
start "" /b cmd /c "timeout /t 4 >nul & echo Timeout > \"%timeout_file%\" & exit"

:: Запрашиваем ввод пользователя
set /p "user_input=Введите что-нибудь (или ничего не вводите, чтобы истекло время): "

:: Проверяем, завершился ли таймер
if exist "%timeout_file%" (
    echo Время ожидания истекло.
    del "%timeout_file%"
) else (
    echo Вы ввели: %user_input%
)
echo "Hello"
pause
:: Очищаем фоновый процесс таймера (если все еще запущен)
taskkill /f /im cmd.exe >nul 2>&1

endlocal
