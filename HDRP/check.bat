@echo off
setlocal

:loop
echo --------------
@REM echo Checking the value in check.json...

rem Чтение значения из check.json
set "value="
for /f "tokens=2 delims=:" %%a in ('findstr "isActive" "%cd%\Dedoslavl\Dedoslavl_Data\StreamingAssets\check.json"') do (
    set "value=%%a"
)

rem Убираем кавычки и пробелы
set "value=%value:"=%"
set "value=%value: =%"
set "value=%value:}=%"

echo Raw value read from file: %value%

rem Проверка, равно ли значение true
if /i "%value%"=="true" (
    echo The value is true. Skipping..
    rem Если значение false, делаем окно Dedoslavl неактивным
    
) else (
    echo The value is false. Skipping PowerShell script...
    powershell -ExecutionPolicy Bypass -File "manage-window.ps1"
)

@REM echo Waiting for 5 seconds before the next check...
rem Ожидание перед следующей проверкой (например, 5 секунд)
timeout /t 5 /nobreak >nul

rem Повторение цикла
goto loop

endlocal
