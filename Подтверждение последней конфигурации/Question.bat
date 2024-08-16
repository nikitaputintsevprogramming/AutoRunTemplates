@echo off
chcp 65001 >nul

setlocal

REM Запускаем таймер в фоновом потоке
start "" /b cmd /c "timeout /t 10 /nobreak >nul & echo Время ожидания истекло. Программа завершена. & exit /b"

REM Задаем вопрос
set /p answer=Вы хотите продолжить? (y/n):

REM Проверяем ответ
if /i "%answer%"=="n" (
    echo Вы выбрали "Нет". Программа завершена.
    exit /b
)

REM Если введен ответ до истечения времени
echo Вы выбрали: %answer%

REM Завершаем фоновый таймер
taskkill /f /im cmd.exe >nul 2>&1

REM Продолжить выполнение программы или добавить дополнительный код здесь
pause
