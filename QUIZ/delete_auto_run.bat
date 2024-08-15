@echo off
chcp 65001 >nul
set shortcutName="QuizLauncher.lnk"
set startupFolder=%AppData%\Microsoft\Windows\Start Menu\Programs\Startup

echo Удаление ярлыка %shortcutName% из папки автозагрузки...

if exist "%startupFolder%\%shortcutName%" (
    del "%startupFolder%\%shortcutName%"
    echo Ярлык успешно удален.
) else (
    echo Ярлык не найден в папке автозагрузки.
)

pause
