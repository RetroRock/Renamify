[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
Add-Type -AssemblyName System.Windows.Forms
$folderName = "\Renamify"
$subfolder = "\src"
$browser = New-Object System.Windows.Forms.FolderBrowserDialog
$result = $browser.ShowDialog()
# $result
if ($result -eq "OK") {    
    Write-Host ("`nKopieren der Dateien nach " + $browser.SelectedPath + "...`n")  -ForegroundColor Green  
    $fullPath = $browser.SelectedPath + $folderName
    if (Test-Path $fullPath) {
        Remove-Item $fullPath -Recurse 
    }
    Get-ChildItem -Path . | Copy-Item -Destination ($fullPath + "/")
    $srcPath = $fullPath + $subfolder
    if (Test-Path $fullPath) {
        mkdir -Path $srcPath | Out-Null
        Get-ChildItem -Path .\src\ | Copy-Item -Destination $srcPath
        Set-Location -Path $fullPath
        $batValue = "@Echo Off`n PowerShell -NoProfile -ExecutionPolicy Bypass -Command `"& {. ${fullPath}\src\RenameFiles.ps1; RenameFiles '%cd%' '${fullPath}\src\UI.ps1'}`""
        New-Item -Path "${fullPath}\src\RenameFiles_INIT.bat" -Value $batValue | Out-Null

        Write-Host "Eintrag in Registrierung...`n" -ForegroundColor Green
        reg add "HKCU\Software\Classes\*\shell\Run script" /d "Dateien umbenennen" /t REG_SZ /f
        reg add "HKCU\Software\Classes\*\shell\Run script\command" /t REG_SZ /d "${fullPath}\src\RenameFiles_INIT.bat" /f
        Write-Host "`nInstallation erfolgreich" -ForegroundColor Green
    }
} 
else { Write-Host "Ups, etwas ist schief gelaufen!" -ForegroundColor Yellow } 