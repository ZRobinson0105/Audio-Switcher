#Module for audio
try {Import-Module -Name AudioDeviceCmdlets -Force -Verbose  
	Import-Module BurntToast}
catch {Install-Module -Name AudioDeviceCmdlets -Force -Verbose 
	Install-Module BurntToast}


$Settings = ".\Preferences.CFG"

#Get device variables
$SettingsFile = Get-Content $Settings
$LineNo = 1
Foreach ($Line in $SettingsFile) {
	if ($LineNo -ge 3) {
		$LineParsed = $Line -split " = "
		if ($LineParsed[0] -eq "Theme")         {$Global:Theme =		$LineParsed[1]}
		if ($LineParsed[0] -eq "Notifications") {$Global:Notifications = $LineParsed[1]}
		if ($LineParsed[0] -eq "Device_1")      {$Global:Device_1 = 	$LineParsed[1]}
		if ($LineParsed[0] -eq "Device_2")      {$Global:Device_2 = 	$LineParsed[1]}
	}
	
	$LineNo ++
}


# Write-Host $Global:Theme
# Write-Host $Global:Device_1
# Write-Host $Global:Device_2
$Devices = Get-AudioDevice -List
# $Devices | format-table

#check selected device and get IDs from names

foreach ($Device in $Devices) {
	if (($Device.Type -eq "Playback") -and ($Device.Default -eq $true)) {
		$Selected = $Device.Name
	}
    if (($Device.Type -eq "Playback") -and ($Device.Name -eq $Global:Device_1)) {
        $ID1 = $Device.ID
		$Message1 = "Active device set to $($Global:Device_1)"
		# write-host "Device1 is $($Device.Name)"
    }
    elseif (($Device.Type -eq "Playback") -and ($Device.Name -eq $Global:Device_2)) {
        $ID2 = $Device.ID
		$Message2 = "Active device set to $($Global:Device_2)"
		# write-host "Device2 is $($Device.Name)"
    }
}
    

if ($Selected -ne $Global:Device_1) {
    #Set to 1
    Set-AudioDevice -ID $ID1
	if ($Global:Notifications -eq "True") {
        New-BurntToastNotification -Text "$Message1" -AppLogo ".\speaker.ico"
    }
}
else {
	#Otherwise set to 2
    Set-AudioDevice -ID $ID2
	if ($Global:Notifications -eq "True") {
        New-BurntToastNotification -Text "$Message2" -AppLogo ".\speaker.ico"
    }
}


