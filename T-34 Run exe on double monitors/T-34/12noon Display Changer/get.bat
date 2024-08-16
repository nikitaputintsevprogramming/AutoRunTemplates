@echo off
setlocal enabledelayedexpansion

rem Выполняем команду и сохраняем результат в переменную
for /f "tokens=*" %%i in ('dc.exe -listmonitors') do (
    echo Monitor: %%i
)

endlocal
pause
