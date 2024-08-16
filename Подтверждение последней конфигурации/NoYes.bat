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

:: Запрашиваем у пользователя ввод
set /p user_input=Введите "y" или "n": 

:: Проверяем введенное значение и сохраняем его в файл
if /i "%user_input%"=="y" (
    echo y > "%file%"
) else (
    if /i "%user_input%"=="n" (
        echo n > "%file%"
    ) else (
        echo Введено неверное значение. Пожалуйста, введите "y" или "n". > "%file%"
    )
)

echo Ответ сохранен в файле %file%

endlocal
pause
