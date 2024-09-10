# Set WshShell = CreateObject("WScript.Shell")
# WshShell.Run "cmd.exe /k title Console & echo Switching to console...", 0, False
# ' WshShell.Run "cmd.exe /k echo Switching to console...", 0, False

# Функция для поиска окна по заголовку
function Find-WindowByTitle {
    param (
        [string]$title
    )
    $windows = Get-Process | ForEach-Object { $_.MainWindowTitle }
    foreach ($window in $windows) {
        if ($window -eq $title) {
            return (Get-Process | Where-Object { $_.MainWindowTitle -eq $title }).Id
        }
    }
    return $null
}

# Найти окно по заголовку
$windowId = Find-WindowByTitle "Dedoslavl"

if ($windowId) {
    # Использовать другой метод для управления фокусом (например, переключение на другое окно)
    # Это делает текущее окно неактивным
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class WindowManager {
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
}
"@
    [WindowManager]::SetForegroundWindow([WindowManager]::FindWindow([NullString]::Value, ""))
    
    Write-Output "Window 'Dedoslavl' is now inactive."
} else {
    Write-Output "Window 'Dedoslavl' not found."
}

