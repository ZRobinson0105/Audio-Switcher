Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
cd 
$Form = 					New-Object System.Windows.Forms.Form
$Form.Icon = 				".\speaker.ico"
$Form.FormBorderStyle = 	"2"
$Form.Size =				New-Object System.Drawing.Size(450,370)
$Form.Text =				"Audio Switcher - Settings"
$Form.MaximizeBox = 		$False
$Form.MinimizeBox = 		$False

$Settings = ".\Preferences.CFG"

Function GetVariables () {
	#Parse settings and import to list
	$SettingsFile = Get-Content $Settings
	$LineNo = 1
	Foreach ($Line in $SettingsFile) {
		if ($LineNo -ge 3) {
			$LineParsed = $Line -split " = "
			if ($LineParsed[0] -eq "Theme")    {$Global:Theme = $LineParsed[1]} 
			if ($LineParsed[0] -eq "Device_1") {$Global:Device_1 = 	$LineParsed[1]} 
			if ($LineParsed[0] -eq "Device_2") {$Global:Device_2 = 	$LineParsed[1]}
		}
		
		$LineNo ++
	}
	# Write-Host $Global:Theme
	# Write-Host $Global:Device_1
	# Write-Host $Global:Device_2
}

#Defined colours to minimize confusion
#Darkest
$Dark3 = "#262626"
$Dark2 = "#525252"
#Lightest
#========
#(inverse order for light mode
#Darkest
$White2 = "#b6bebf"
$White3 = "#798080"
#Lightest

$BackerButton = 				New-Object Windows.Forms.Button
$BackerButton.Location =		New-Object System.Drawing.Point(10,10)
$BackerButton.Size = 			New-Object System.Drawing.Size(410,90)
$backerButton.Enabled = 		$False
	
$Explanation = 					New-Object Windows.Forms.Label
$Explanation.Location =			New-Object System.Drawing.Point(13,17)
$Explanation.Size = 			New-Object System.Drawing.Size(396,74)
$Explanation.Text = 			"Set both output devices you wish to toggle between. If you have ran the Setup.ps1, you should have toggler tool on your desktop"
$Explanation.Font = 			"Microsoft Sans Serif,14"
$Explanation.TextAlign =    	"MiddleCenter"
	
$Device1Backer = 				New-Object Windows.Forms.Button
$Device1Backer.Location =		New-Object System.Drawing.Point(10,110)
$Device1Backer.Size = 			New-Object System.Drawing.Size(410,80)
$Device1Backer.Enabled = 		$False

$Device1Label = 				New-Object Windows.Forms.Label
$Device1Label.Location =		New-Object System.Drawing.Point(18,118)
$Device1Label.Size = 			New-Object System.Drawing.Size(100,25)
$Device1Label.Text = 			"Device 1"
$Device1Label.Font = 			"Microsoft Sans Serif,14"

$Device1List = 					New-Object System.Windows.Forms.ComboBox
$Device1List.Location = 		New-Object System.Drawing.Point(18, 145)
$Device1List.Size = 			New-Object System.Drawing.Size(386, 45)
$Device1List.Font = 			"Microsoft Sans Serif,12"
$Device1List.DropDownStyle = 	[System.Windows.Forms.ComboBoxStyle]::DropDownList #Not editable

$Device2Backer = 				New-Object Windows.Forms.Button
$Device2Backer.Location =		New-Object System.Drawing.Point(10,190)
$Device2Backer.Size = 			New-Object System.Drawing.Size(410,80)
$Device2Backer.Enabled = 		$False
	
	
$Device2Label = 				New-Object Windows.Forms.Label
$Device2Label.Location =		New-Object System.Drawing.Point(18,198)
$Device2Label.Size = 			New-Object System.Drawing.Size(100,25)
$Device2Label.Text = 			"Device 2"
$Device2Label.Font = 			"Microsoft Sans Serif,14"
	   
$Device2List = 					New-Object System.Windows.Forms.ComboBox
$Device2List.Location = 		New-Object System.Drawing.Point(18, 225)
$Device2List.Size = 			New-Object System.Drawing.Size(386, 45)
$Device2List.Font = 			"Microsoft Sans Serif,12"
$Device2List.DropDownStyle = 	[System.Windows.Forms.ComboBoxStyle]::DropDownList #Not editable

$ApplyButton = 					New-Object Windows.Forms.Button
$ApplyButton.Location =			New-Object System.Drawing.Point(10,280)
$ApplyButton.Size = 			New-Object System.Drawing.Size(180,35)
$ApplyButton.Text =				"Apply Changes"
$ApplyButton.TextAlign = 		"MiddleLeft"
$ApplyButton.Font = 			"Microsoft Sans Serif,12"
$ApplyButton.Enabled = 			$False

$ChangeTheme = 					New-Object Windows.Forms.Button
$ChangeTheme.Location =			New-Object System.Drawing.Point(240,280)
$ChangeTheme.Size = 			New-Object System.Drawing.Size(180,35)
$ChangeTheme.Text =				"Change theme"
$ChangeTheme.TextAlign = 		"Middleright"
$ChangeTheme.Font = 			"Microsoft Sans Serif,12"

$ChangeTheme.Add_Click({
	$SettingsFile = Get-Content $Settings
	$NewFile = @()
	Foreach ($Line in $SettingsFile) {
		if ($Line -like "*Theme*") {
			if ($Global:Theme -eq "Light")    {$NewFile = $NewFile + "Theme = Dark"}
			elseif ($Global:Theme -eq "Dark")    {$NewFile = $NewFile + "Theme = Light"}

		}
		else{
			$NewFile = $NewFile + $Line
		}
	}
	$NewFile | Out-File -File $Settings
	
	GetVariables 
	SetTheme
	$Form.Refresh()
})


$Device1List.add_SelectedIndexChanged({
	CheckApply
})

$Device2List.add_SelectedIndexChanged({
	CheckApply
})

$ApplyButton.Add_Click({
	$Device1before = $Device_1
	$Device2before = $Device_2
	$SettingsFile = Get-Content $Settings
	$NewFile = @()
	Foreach ($Line in $SettingsFile) {
		if ($Line -like "*Device_1*") {
			if (($Device1List.SelectedItem).Length -gt 0)    {$NewFile = $NewFile + "Device_1 = $($Device1List.SelectedItem)"}
		}
		elseif ($Line -like "*Device_2*") {
			if (($Device2List.SelectedItem).Length -gt 0)    {$NewFile = $NewFile + "Device_2 = $($Device2List.SelectedItem)"}
		}
		else{
			$NewFile = $NewFile + $Line
		}
	}
	$NewFile | Out-File -File $Settings
	
	GetVariables 
	CheckApply
	if ($Device_1 -ne $Device1before) {
		Write-Host "Device 1 updated!" -ForegroundColor DarkGreen
		Write-Host "$($Device1before) -> $($Device_1)`n" -ForegroundColor DarkGreen
	}
	if ($Device_2 -ne $Device2before) {
		Write-Host "Device 2 updated!" -ForegroundColor DarkGreen
		Write-Host "$($Device2before) -> $($Device_2)`n" -ForegroundColor DarkGreen
	}
})	
                           
Function CheckApply () {
	$Applicable = $False
	if (($Global:Device_1 -ne $Device1List.SelectedItem) -and ($Device1List.SelectedItem -ne "Choose a device")) {
		$Applicable = $True
	}
	if (($Global:Device_2 -ne $Device2List.SelectedItem) -and ($Device2List.SelectedItem -ne "Choose a device")) {
		$Applicable = $True
	}
	#If a change is detected
	if ($Applicable) {
		$ApplyButton.Enabled = $True
		$ApplyButton.BackColor = "#345e2a"
		$ApplyButton.ForeColor = "#30f205"
	}
	else {
		SetTheme
		$ApplyButton.Enabled = $False
	}
}

Function SetTheme () {
	if ($Global:Theme -eq "Dark") {
		$Form.BackColor = 			$Dark3
		$BackerButton.BackColor = 	$Dark2
		$Explanation.BackColor = 	$Dark2
		$Explanation.ForeColor = 	"#ffffff"
		$Device1Backer.BackColor = 	$Dark2
		$Device1Label.ForeColor = 	"#ffffff"
		$Device1Label.BackColor = 	$Dark2	
		$Device2Backer.BackColor = 	$Dark2
		$Device2Label.ForeColor = 	"#ffffff"
		$Device2Label.BackColor = 	$Dark2		
		$ApplyButton.BackColor = 	$Dark2	
		$ApplyButton.ForeColor = 	"#ffffff"
		$ChangeTheme.BackColor = 	$White2
		$ChangeTheme.ForeColor = 	$Dark3
	}
	elseif ($Global:Theme -eq "Light") {
		$Form.BackColor = 			$White2
		$BackerButton.BackColor = 	$White3
		$Explanation.BackColor = 	$White3
		$Explanation.ForeColor = 	$Dark3
		$Device1Backer.BackColor = 	$White3
		$Device1Label.BackColor = 	$White3
		$Device1Label.ForeColor = 	$Dark3
		$Device2Backer.BackColor = 	$White3
		$Device2Label.BackColor = 	$White3
		$Device2Label.ForeColor = 	$Dark3
		$ApplyButton.BackColor = 	$White3
		$ApplyButton.ForeColor = 	$Dark3
		$ChangeTheme.BackColor = 	$Dark2	
		$ChangeTheme.ForeColor = 	"#ffffff"
	}
	else{
		Write-Host "Theme was expected to be either `"Dark`" or `"Light`", but `"$($Global:Theme)`" was found." -ForegroundColor Red -BackgroundColor Black
		Start-Sleep 10000
	}
	
}

Function Populate ($Element) {
	if ($Element -eq $Device1List) {
		if ($Global:Device_1 -eq "ToBePicked") {
			[void]$Element.Items.Add("Choose a device")
			$Element.SelectedIndex = 0
		}
		else{
			[void]$Element.Items.Add($Global:Device_1)
			$Element.SelectedIndex = 0
		}
	}
	if ($Element -eq $Device2List) {
		if ($Global:Device_2 -eq "ToBePicked") {
			[void]$Element.Items.Add("Choose a device")
			$Element.SelectedIndex = 0
		}
		else{
			[void]$Element.Items.Add($Global:Device_2)
			$Element.SelectedIndex = 0
		}
	}
	
	$Devices = Get-AudioDevice -List
	# $Devices | format-table
	foreach ($Device in $Devices) {
		if ($Device.Type -eq "Playback") {
			if ($Element.items -notcontains $Device.Name) {
				[void]$Element.Items.Add($Device.Name)
			}
		}
	}
	
	
}

#Run functions
GetVariables
Populate $Device1List
Populate $Device2List
SetTheme

#Add all elements to form
$Elements = @($BackerButton, $Explanation, $Device1Backer, $Device1Label, $Device1List, $Device2Backer, $Device2Label, $Device2List, 
			$ApplyButton, $ChangeTheme)

$Form.Controls.AddRange($Elements)
$BackerButton.SendToBack()
$Device1Backer.SendToBack()
$Device2Backer.SendToBack()

$Form.ShowDialog()