Add-Type -AssemblyName System.Windows.Forms

# Создаем новую форму
$form = New-Object System.Windows.Forms.Form
# $form.Text = "OPEN"
$form.FormBorderStyle = "None"

# Устанавливаем размеры формы
$form.Width = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width
$form.Height = 100  # Высота кнопки

# Устанавливаем цвет фона через значения RGB
$bgColor = [System.Drawing.Color]::FromArgb(254,211,0)  # Желтый цвет
$form.BackColor = $bgColor

# Устанавливаем положение формы
$form.StartPosition = 'Manual'
$form.Location = New-Object System.Drawing.Point(0, 3740)

# Убираем рамку у окна
$form.FormBorderStyle = "None"

# Создаем изображение
$imagePath = "arrow.png"
$image = [System.Drawing.Image]::FromFile($imagePath)

# Создаем кнопку
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(0, 0)  # Положение кнопки внутри формы
$button.Size = New-Object System.Drawing.Size($form.Width, $form.Height)

# Устанавливаем изображение на кнопку
$button.Image = $image

$button.Add_Click({
    # Запускаем .bat файл
    Start-Process "start.bat"
})

# Добавляем кнопку на форму
$form.Controls.Add($button)

# Показываем форму поверх всех окон
$form.TopMost = $true

# Запускаем форму
$form.ShowDialog()
