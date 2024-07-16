# Получить текущие дисплеи
$monitors = Get-WmiObject -Namespace root\wmi -Class WmiMonitorBasicDisplayParams

# Поменять основной дисплей (используйте нужные параметры для вашего случая)
# В этом примере мы просто выведем информацию о мониторах
foreach ($monitor in $monitors) {
    Write-Output "Monitor: $($monitor.InstanceName)"
}

# Пример команды для переключения дисплеев (не меняет основной монитор)
& 'C:\Windows\System32\DisplaySwitch.exe' /extend
