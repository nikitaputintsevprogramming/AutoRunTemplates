@echo off
chcp 65001 >nul

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
@REM start "" /b cmd /c "timeout /t 10 /nobreak >nul & echo Время ожидания истекло. Программа завершена. & exit /b" & taskkill /f /im cmd.exe >nul 2>&
start "" /b cmd /c "timeout /t 10 /nobreak >nul & echo Время ожидания истекло. Программа завершена. 1"

:question
REM Задаем вопрос
set /p user_input=Введите другое значение если экраны при последнем запуске открывались наоборот (1/0) или пропустите ответ, чтобы продолжить без изменений:

:: Проверяем введенное значение и сохраняем его в файл
if /i "%user_input%"=="1" (
    echo 1 > "%file%"
) else (
    if /i "%user_input%"=="0" (
        echo 0 > "%file%"
    ) else (
        @REM echo Введено неверное значение. Пожалуйста, введите "y" или "n". > "%file%"
        echo Введено неверное значение. Пожалуйста, введите "1" или "0".
        goto :question 
    )
)

echo Ответ сохранен в файле %file%

REM Завершаем фоновый таймер
@REM taskkill /f /im cmd.exe >nul 2>&1
exit /b

REM Продолжить выполнение программы или добавить дополнительный код здесь
@REM pause
