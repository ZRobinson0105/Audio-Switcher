
#Check for admin, relaunch if not
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This scipt requires Administrator to run." -ForegroundColor Cyan
    if ((Read-Host "Do you wish to relaunch as administrator? (Y/N)") -match '^[Yy]$') {
        Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    }
    else {
        Write-Host "This scipt requires Administrator to run otherwise setup will not work." -ForegroundColor Red
        Start-Sleep -Seconds 10000
        exit
    }
}
Write-Host "Running as Administrator."-ForegroundColor Green
start-sleep 2
cls
start-sleep 2
$Block = @(" _______  __   __  ______   ___   _______    _______  _     _  ___   _______  _______  __   __  _______  ______",  
	"|   _   ||  | |  ||      | |   | |       |  |       || | _ | ||   | |       ||       ||  | |  ||       ||    _ |  ",
	"|  |_|  ||  | |  ||  _    ||   | |   _   |  |  _____|| || || ||   | |_     _||       ||  |_|  ||    ___||   | ||  ",
	"|       ||  |_|  || | |   ||   | |  | |  |  | |_____ |       ||   |   |   |  |       ||       ||   |___ |   |_||_ ",
	"|       ||       || |_|   ||   | |  |_|  |  |_____  ||       ||   |   |   |  |      _||       ||    ___||    __  |",
	"|   _   ||       ||       ||   | |       |   _____| ||   _   ||   |   |   |  |     |_ |   _   ||   |___ |   |  | |",
	"|__| |__||_______||______| |___| |_______|  |_______||__| |__||___|   |___|  |_______||__| |__||_______||___|  |_|")
foreach ($Segment in $Block) {
	write-host $Segment
	start-sleep -milliseconds 80
}
Write-Host "by Zack"
write-host "`n`n"


Write-Host "Installing necessary audio modules for powershell..." -ForegroundColor Cyan
Install-Module -Name AudioDeviceCmdlets -Force -Verbose
Install-Module -Name BurntToast -Force
start-sleep 3
Write-Host "Install complete.`n" -ForegroundColor Green
start-sleep 2

$CurrentDir = $PSScriptRoot
$Desktop    = [Environment]::GetFolderPath('Desktop')
$ws         = New-Object -ComObject WScript.Shell

# Settings shortcut
$sc = $ws.CreateShortcut((Join-Path $CurrentDir "Switcher_Settings.lnk"))
$sc.TargetPath       = "powershell.exe"
$sc.Arguments        = "-ExecutionPolicy Bypass -File `"$CurrentDir\Resources\settingsconfigurer.ps1`""
$sc.IconLocation     = "$CurrentDir\Resources\speaker.ico"
$sc.WorkingDirectory = "$CurrentDir\Resources"
$sc.Save()
Write-Host "Settings shortcut created.`n" -ForegroundColor Green

# App (this folder)
$sc = $ws.CreateShortcut((Join-Path $CurrentDir "Audio Switcher.lnk"))
$sc.TargetPath       = "powershell.exe"
$sc.Arguments        = "-ExecutionPolicy Bypass -WindowStyle hidden -File `"$CurrentDir\Resources\Switch.ps1`""
$sc.IconLocation     = "$CurrentDir\Resources\speaker.ico"
$sc.WorkingDirectory = "$CurrentDir\Resources"
$sc.Save()
Write-Host "App shortcut created in $CurrentDir.`n" -ForegroundColor Green

# App (Desktop)
$sc = $ws.CreateShortcut((Join-Path $Desktop "Audio Switcher.lnk"))
$sc.TargetPath       = "powershell.exe"
$sc.Arguments        = "-ExecutionPolicy Bypass -WindowStyle hidden -File `"$CurrentDir\Resources\Switch.ps1`""
$sc.IconLocation     = "$CurrentDir\Resources\speaker.ico"
$sc.WorkingDirectory = "$CurrentDir\Resources"
$sc.Save()
Write-Host "App shortcut created on Desktop.`n" -ForegroundColor Green

Write-Host "Adding trust to scripts..."

Write-Host "Unblocking all scripts in: $CurrentDir ...`n" -ForegroundColor Cyan

Get-ChildItem -Path $CurrentDir -Recurse -Include *.ps1,*.psm1,*.psd1 |
    ForEach-Object {
        try {
            Unblock-File -Path $_.FullName
            Write-Host "Unblocked: $($_.FullName)" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to unblock: $($_.FullName)"
        }
    }


Write-Host ("=" * 52) -ForegroundColor Cyan
Write-Host "Setup success! see rest of setup.txt for next steps.`nThis window will close in 10 seconds."-ForegroundColor Cyan
Write-Host ("=" * 52) -ForegroundColor Cyan
start-sleep 10