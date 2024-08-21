@echo off

timeout /t 5 /nobreak
start explorer.exe

REM Запускаем необходимые скрипты
start "" "%~dp0T-34\run_exe.bat"
start "" "%~dp0T-34\result.bat"