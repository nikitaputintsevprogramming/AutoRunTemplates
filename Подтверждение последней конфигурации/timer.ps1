# Функция для установки таймера
function Start-Timer {
    Start-Sleep -Seconds 4
    if (-not $global:answered) {
        Write-Output "нет ответа"
        $global:answered = $true
    }
}

# Инициализация глобальной переменной
$global:answered = $false

# Запуск таймера в фоновом потоке
Start-Job -ScriptBlock { Start-Timer }

# Запрос ввода
$userInput = Read-Host "Введите 'да' или 'нет'"

# Установка флага, что ответ получен
$global:answered = $true

# Вывод результата
if ($userInput -eq 'да' -or $userInput -eq 'нет') {
    Write-Output "Вы ввели: $userInput"
} else {
    Write-Output "Неверный ввод"
}

# Ожидание завершения таймера
Get-Job | Wait-Job | Out-Null
