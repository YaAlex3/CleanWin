# This file is a part of the CleanWin software
# Copyright (c) 2021 Pratyaksh Mehrotra <pratyakshm@protonmail.com>
# All rights reserved.

# Default preset
$tasks = @(

### Maintenance Tasks ###
	"CleanWin",
	"OSBuildInfo",
	"CreateSystemRestore",
	"Activity",

### Apps & Features ###
	"AppsFeatures",
	"UninstallApps", "Activity", 
	"UnpinStartTiles", "Activity", 
	"UnpinAppsFromTaskbar", "Activity", 
	"InstallFrameworks",
	# "UninstallFrameworks",
	"InstallWinGet", 
	"UninstallOneDrive", "Activity",
	# "InstallOneDrive",
	# "DisableBrowserRestoreAd",
	# "EnableBrowserRestoreAd",
	# "DisableM365OnValueBanner", 
	# "RevertM365OnValueBanner",
	"UninstallFeatures", "Activity", 
	# "InstallFeatures", "Activity", 
	"DisableSuggestions",		    
	# "EnableSuggestions",
	"EnableWSL", "Activity", 
	# "DisableWSL",
	"EnabledotNET3.5", "Activity", 
	# "DisabledotNET3.5",
	"EnableSandbox",
	# "DisableSandbox",
	"Install7zip", 
	# "Uninstall7zip",
	"Winstall", 
	"Activity",
	"EnableExperimentsWinGet",
	# "DisableExperimentsWinGet",
	"WinGetImport",
	"Activity",
	"InstallHEVC", 
	# "UninstallHEVC",
	"Widgets",
	"InstallFonts", 
	# "UninstallFonts",
	"SetPhotoViewerAssociation",
	# "UnsetPhotoViewerAssociation",
	"ChangesDone",

### Privacy & Security ###
	"PrivacySecurity",
	"DisableActivityHistory",	
	# "EnableActivityHistory",
	"DisableAdvertisingID",			
	# "EnableAdvertisingID",
	"DisableBackgroundApps",        
	# "EnableBackgroundApps",
	"DisableFeedback",		       
	# "EnableFeedback",
	"DisableInkHarvesting",			
	# "EnableInkHarvesting",
	"DisableLangAccess",  		    
	# "EnableLangAccess",
	"DisableLocationTracking",      
	# "EnableLocationTracking",
	"DisableMapUpdates",			
	# "EnableMapsUpdates",
	"DisableSpeechRecognition",		
	# "EnableSpeechRecognition",
	"DisableTailoredExperiences",	
	# "EnableTailoredExperiences",
	"DisableTelemetry",				
	# "EnableTelemetry",
	"EnableClipboard",				
	# "DisableClipboard",
	"AutoLoginPostUpdate", 		    
	# "StayOnLockscreenPostUpdate",
	"ChangesDone",
	# To revert all privacy changes, use CleanWin GUI -> "Enable data collection".

### Tasks & Services ###
	"TasksServices",
	"DisableStorageSense",		   
	# "EnableStorageSense",
	"DisableReservedStorage",	   
	# "EnableReservedStorage",
	"DisableAutoplay",             
	# "EnableAutoplay",
	"DisableAutorun",              
	# "EnableAutorun",
	"SetBIOSTimeUTC",              
	# "SetBIOSTimeLocal",
	"EnableNumLock",			   
	# "DisableNumLock",
	"DisableServices",			   
	# "EnableServices",
	"DisableTasks",				   
	# "EnableTasks",
	"SetupWindowsUpdate",		   
	# "ResetWindowsUpdate",
	"EnablePowerdownAfterShutdown",
	# "DisablePowerdownAfterShutdown",
	"ChangesDone",

### Windows Explorer ###
	"PrintExplorerChanges",
	"EnablePrtScrToSnip",		   
	# "DisablePrtScrSnip",
	"DisableStickyKeys",           
	# "EnableStickyKeys",
	"SetExplorerThisPC",           
	# "SetExplorerQuickAccess",
    "Hide3DObjects",      		   
	# "Restore3DObjects",
	"HideSearchBar",			   
	# "RestoreSearchBar"
	"HideTaskView",                
	# "RestoreTaskView",
	"HideCortana",			       
	# "RestoreCortana",
	"HideMeetNow",				   
	# "RestoreMeetNow",
	"DisableTaskbarFeed",		   
	# "EnableTaskbarFeed",  (News and Interests)
	"ChangesDone",

###  Tasks after successful run ###
	"Activity",
	"Success"
)

# Core functions 
Function Log($text) {
	Start-Sleep -Milliseconds 200
    Write-Host $text
}

Function check($test) {
    if ($test -like "y" -or $test -like "yeah" -or $test -like "yes" -or $test -like "yep" -or $test -like "yea" -or $test -like "yah") { 
		return $true
	}
	elseif ($test -like "n" -or $test -like "nope" -or $test -like "no" -or $test -like "nada" -or $test -like "nah" -or $test -like "naw") {
		return $false
	}
}

Function cwexit {
	Write-Host "CleanWin will now exit."
	Start-Sleep -Milliseconds 200
	exit
}

Function ask($question) {
	Read-Host $question
}

Function space {
	Write-Host " "
}

Function print($text) {
	Write-Host $text
}
if (!(Test-Path C:\CleanWin)) {
	New-Item C:\CleanWin -ItemType Directory | Out-Null 
}
Start-Transcript -OutputDirectory "C:\CleanWin" | Out-Null 

### Pre-execution tasks ###

Clear-Host
print "CleanWin pre-execution environment"
Start-Sleep -Milliseconds 100
space
print "Copyright (c) Pratyaksh Mehrotra and contributors"
Start-Sleep -Milliseconds 100
print "https://github.com/pratyakshm/CleanWin"
space
Start-Sleep 1

# Did you read the docs? (Funny stuff).
$hasReadDoc = ask "Have you read the documentation? [y/n]"
if (check($hasReadDoc)) {
	$knowWinstall = ask "Cool! You know Winstall?"
	if (check($knowWinstall)) {
		log "Aight good job." 
	}
	elseif (!(check($knowWinstall))) {
		log "Read the documentation properly this time?"
		log "Ctrl + left click https://github.com/pratyakshm/CleanWin/blob/main/README.md"
		log "You're welcome."
		exit 
	}
}
elseif (!(check($hasReadDoc))) {
	log "I didn't write the documentation for nothing."
	log "Go ahead, read it."
	log "Ctrl + left click https://github.com/pratyakshm/CleanWin/blob/main/README.md"
	log "You're welcome."
	exit
}

# Store values, create PSDrives and get current window title.
$CurrentVersionPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
$CurrentBuild = Get-ItemPropertyValue $CurrentVersionPath -Name CurrentBuild
$DisplayVersion = Get-ItemPropertyValue $CurrentVersionPath -Name DisplayVersion
$ProductName = Get-ItemPropertyValue $CurrentVersionPath -Name ProductName
New-PSDrive -Name "HKU" -PSProvider "Registry" -Root "HKEY_Users" | Out-Null
$currenttitle = $(Get-Process | Where-Object {$_.MainWindowTitle -like "*PowerShell*" }).MainWindowTitle
# Source: https://github.com/farag2/Windows-10-Sophia-Script/blob/master/Sophia/PowerShell%207/Module/Sophia.psm1#L825.
$hkeyuser = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq $env:USERNAME}).SID


####### BEGIN CHECKS #########

# Check if supported OS build.
space
Write-Host "Checking if CleanWin supports this version of Windows..." -NoNewline
if ($CurrentBuild -lt 19042) {
	Write-Host "  Unsupported." -ForegroundColor DarkRed
	cwexit
}
elseif ($CurrentBuild -ge 19042) {
	Write-Host "  Supported." -ForegroundColor Green
}

# Check if session is elevated.
Write-Host "Checking if current PowerShell session is elevated..." -NoNewline
Start-Sleep -Milliseconds 250 
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$admin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($admin -like "False") {
	Write-Host " Not elevated." -ForegroundColor DarkRed
	cwexit
}
elseif ($admin -like "True") {
	Write-Host "  Elevated." -ForegroundColor Green
}

# Exit CleanWin if PC is not connected.
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
Write-Host "Checking if this device is connected..." -NoNewline
Import-Module BitsTransfer
Start-BitsTransfer https://raw.githubusercontent.com/CleanWin/Files/main/File.txt
if (Test-Path File.txt) {
	Remove-Item File.txt
	Write-Host "  Connected." -ForegroundColor Green
}
elseif (!(Test-Path File.txt)) {
	Write-Host "  Not connected." -ForegroundColor DarkRed
	cwexit
}

# Check for updates and exit if found (part of code used here is picked from https://gist.github.com/Grimthorr/44727ea8cf5d3df11cf7).
Write-Host "Checking if device is up-to-date..." -NoNewline
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
$Updates = @($UpdateSearcher.Search("IsHidden=0 and IsInstalled=0 and AutoSelectOnWebSites=1").Updates)
$Title = $($Updates).Title
if (!($Title)) {
	Write-Host "  Passed." -ForegroundColor Green
}
else {
	Write-Host "  Updates found." -ForegroundColor DarkRed
	Write-Host "Ensure your device is up to date before executing CleanWin."
	space
	cwexit
}

# Check for pending restart (part of code used here was picked from https://thesysadminchannel.com/remotely-check-pending-reboot-status-powershell).
Write-Host "Checking for pending restarts..." -NoNewline
Start-Sleep -Milliseconds 100
param (
    [Parameter(
    Mandatory = $false,
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    Position=0
    )]
    [string[]]  $ComputerName = $env:COMPUTERNAME
    )
ForEach ($Computer in $ComputerName) {
    $PendingReboot = $false
    $HKLM = [UInt32] "0x80000002"
    $WMI_Reg = [WMIClass] "\\$Computer\root\default:StdRegProv"
    if ($WMI_Reg) {
        if (($WMI_Reg.EnumKey($HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\")).sNames -contains 'RebootPending') {$PendingReboot = $true}
        if (($WMI_Reg.EnumKey($HKLM,"SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\")).sNames -contains 'RebootRequired') {$PendingReboot = $true}
     
        # Check for SCCM namespace.
        $SCCM_Namespace = Get-WmiObject -Namespace ROOT\CCM\ClientSDK -List -ComputerName $Computer -ErrorAction Ignore
        if ($SCCM_Namespace) {
            if (([WmiClass]"\\$Computer\ROOT\CCM\ClientSDK:CCM_ClientUtilities").DetermineIfRebootPending().RebootPending -eq $true) {$PendingReboot = $true}
        }
     
        if ($PendingReboot -eq $true) {
            Write-Host "  Pending." -ForegroundColor DarkRed
			cwexit
        }
        else {
            Write-Host "  None." -ForegroundColor Green
			Start-Sleep -Milliseconds 100
        }
        # Clear variables.
        $WMI_Reg        = $null
        $SCCM_Namespace = $null
    }   
}

# Check PowerShell version and import required modules.
if ((($PSVersionTable).PSVersion).Major -eq "7") { 
$WarningPreference = 'SilentlyContinue'
	Write-Host "PowerShell 7 detected, loading required modules..." -NoNewLine
	Import-Module -Name Appx, Microsoft.PowerShell.Management, PackageManagement -UseWindowsPowerShell | Out-Null
	Write-Host "  Loaded." -ForegroundColor Green
} 
elseif ((($PSVersionTable).PSVersion).Major -eq "5") { 
	print "Windows PowerShell 5 detected."
}
else {
	print "An error occured."
	cwexit
}

Start-Sleep 2

Clear-Host

# Take user configs.
print "Please take your time to answer the questions below in order to save user config."
space
print "Press Enter to proceed after answering a question."
$systemrestore = Read-Host "Create a system restore point? [y/N]"
$uninstallapps = Read-Host "Uninstall Windows apps?"
if ($CurrentBuild -ge 22000) {
	$widgets = Read-Host "Remove Widgets?"
}
$onedrive = ask "Uninstall Microsoft OneDrive?"
$uninstallfeatures = ask "Uninstall unnecessary optional features?"
$wsl = ask "Enable Windows Subsystem for Linux?"
$netfx3 = ask "Enable dotNET 3.5?"
$winstall = ask "Use Winstall? (bit.ly/Winstall)"
$wingetimport = ask "Use winget import?"
$enableexperimentswinget = ask "Enable experimental features in WinGet?"
space 

Start-Sleep -Milliseconds 200
print "Choices saved, starting CleanWin..."
Start-Sleep -Milliseconds 1500

# Intro.
Function CleanWin {
	$host.UI.RawUI.WindowTitle = "pratyakshm's CleanWin"
	Clear-Host
	space
	print "pratyakshm's CleanWin"
	Start-Sleep -Milliseconds 100
	space
	print "Copyright (c) Pratyaksh Mehrotra (a.k.a. pratyakshm) and contributors"
	Start-Sleep -Milliseconds 100
	print "https://github.com/pratyakshm/CleanWin"
	Start-Sleep 1
}

# OS Build.
Function OSBuildInfo {
	space
	$CurrentVersionPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
	$CurrentBuild = Get-ItemPropertyValue $CurrentVersionPath -Name CurrentBuild
	$BuildBranch = Get-ItemPropertyValue $CurrentVersionPath -Name BuildBranch
	$OSBuild = Get-ItemPropertyValue $CurrentVersionPath -Name CurrentBuild
	$DisplayVersion = Get-ItemPropertyValue $CurrentVersionPath -Name DisplayVersion
	if ($CurrentBuild -lt 22000) {
		print "This PC is running Windows 10."
		print "Version $DisplayVersion, OS Build $OSBuild in $BuildBranch branch."
	}
	elseif ($CurrentBuild -ge 22000) {
		print "This PC is running Windows 11."
		print "Version $DisplayVersion, OS Build $OSBuild in $BuildBranch branch."
		print "Note that CleanWin's Windows 11 support is experimental and you might face issues."
	}
	Start-Sleep -Milliseconds 500
	space
	space
}

# Changes performed.
Function ChangesDone {
	space
	print "---------------------------"
	print "     CHANGES PERFORMED     "
	print "---------------------------"
	space
	Start-Sleep 1
}

# Create a system restore point with type MODIFY_SETTINGS.
Function CreateSystemRestore {
$ProgressPreference = 'SilentlyContinue'
	if ($systemrestore -like "y") {
		space
		print "Creating a system restore point with type MODIFY_SETTINGS..."
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -Type DWord -Value 0 -Force
		Enable-ComputerRestore -Drive $env:SystemDrive
		Checkpoint-Computer -Description "CleanWin" -RestorePointType "MODIFY_SETTINGS" -WarningAction SilentlyContinue
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -Type DWord -Value 1440 -Force
		Disable-ComputerRestore -Drive $env:SystemDrive
		print "Created system restore point."
	}
}

# Prevent the console output from freezing by emulating backspace key. (https://github.com/farag2/Windows-10-Sophia-Script/blob/master/Sophia/PowerShell%205.1/Module/Sophia.psm1#L728-L767)
Function Activity {
	# Sleep for 500ms.
	Start-Sleep -Milliseconds 500

	Add-Type -AssemblyName System.Windows.Forms

	$SetForegroundWindow = @{
		Namespace = "WinAPI"
		Name = "ForegroundWindow"
		Language = "CSharp"
		MemberDefinition = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool SetForegroundWindow(IntPtr hWnd);
"@
	}

	if (-not ("WinAPI.ForegroundWindow" -as [type]))
	{
		Add-Type @SetForegroundWindow
	}

	Get-Process | Where-Object -FilterScript {$_.MainWindowTitle -like "pratyakshm's CleanWin*"} | ForEach-Object -Process {
		# Show window if minimized.
		[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 10) | Out-Null 

		Start-Sleep -Milliseconds 100

		# Move the console window to the foreground.
		[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle) | Out-Null

		Start-Sleep -Milliseconds 100

		# Emulate Backspace key.
		[System.Windows.Forms.SendKeys]::SendWait("{BACKSPACE 1}")
	}
}




###################################
######### APPS & FEATURES #########
###################################

# Update status
Function AppsFeatures {
	space
	print "-------------------------"
	print "     APPS & FEATURES     "
	print "-------------------------"
	space
}

# Debloat apps.
Function UninstallApps {
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
	if (!(check($uninstallapps))) { 
		return 
	}
	# Remove Windows inbox apps.
	print "Uninstalling Windows apps..."
	$InboxApps = @(
		"Microsoft.549981C3F5F10"
		"Microsoft.BingNews"
		"Microsoft.BingWeather"
		"Microsoft.GamingApp"
		"Microsoft.GetHelp" 
		"Microsoft.Getstarted" 
		"Microsoft.Messaging"
		"Microsoft.Microsoft3DViewer" 
		"Microsoft.MicrosoftStickyNotes"  
		"Microsoft.MSPaint"
		"Microsoft.MicrosoftOfficeHub"
		"Microsoft.Office.OneNote"
		"Microsoft.MixedReality.Portal"
		"Microsoft.MicrosoftSolitaireCollection" 
		"Microsoft.NetworkSpeedTest" 
		"Microsoft.News" 
		"Microsoft.Office.Sway" 
		"Microsoft.OneConnect"
		"Microsoft.People" 
		"Microsoft.PowerAutomateDesktop"
		"Microsoft.Print3D" 
		"Microsoft.SkypeApp"
		"Microsoft.Todos"
		"Microsoft.WindowsAlarms"
		"Microsoft.WindowsCommunicationsApps" 
		"Microsoft.WindowsFeedbackHub" 
		"Microsoft.WindowsMaps" 
		"Microsoft.WindowsSoundRecorder"
		"Microsoft.XboxApp"
		"Microsoft.YourPhone"
		"Microsoft.ZuneMusic"
		"Microsoft.ZuneVideo"
	)
	ForEach ($InboxApp in $InboxApps) {
		if (Get-AppxPackage $InboxApp) {
			print "     Uninstalling $InboxApp..."
			Get-AppxPackage -Name $InboxApp| Remove-AppxPackage 
			Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $InboxApp | Remove-AppxProvisionedPackage -Online | Out-Null
		}
	}

	if (!(Get-CimInstance -ClassName Win32_PnPEntity | Where-Object -FilterScript {($_.PNPClass -eq "Camera") -or ($_.PNPClass -eq "Image")})) {
		print "     Uninstalling Microsoft.WindowsCamera"
		Get-AppxPackage "Microsoft.WindowsCamera" | Remove-AppxPackage
		Get-AppxProvisionedPackage -Online "Microsoft.WindowsCamera" | Remove-AppxProvisionedPackage 
	}

	# Remove Sponsored apps.
	$SponsoredApps = @(
		"*AdobePhotoshopExpress*"
		"*CandyCrush*"
		"*BubbleWitch3Saga*"
		"*Twitter*"
		"*Facebook*"
		"*Spotify*"
		"*Minecraft*"
		"*Dolby*"
	)
	ForEach ($SponsoredApp in $SponsoredApps) {
		if (Get-AppxPackage $SponsoredApp) {
			print "     Uninstalling $SponsoredApp.."
			Get-AppxPackage -Name $SponsoredApp| Remove-AppxPackage 
			Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $SponsoredApp | Remove-AppxProvisionedPackage -Online | Out-Null
		}
	}

	# Remove Office webapps shortcuts.
	if (Test-Path "%appdata%\Microsoft\Windows\Start Menu\Programs\Excel.lnk") {
		print "     Uninstalling Office web-apps..."
		Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Excel.lnk"
		Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Outlook.lnk"
		Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk"
		Remove-Item "%appdata%\Microsoft\Windows\Start Menu\Programs\Word.lnk"
		print "     Uninstalled Office web-apps."
	}

	# Uninstall Connect app.
	if (Get-AppxPackage Microsoft-PPIProjection-Package) {
		Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/install_wim_tweak.exe
		Start-BitsTransfer https://raw.githubusercontent.com/CleanWin/Files/main/connect.cmd
		./connect.cmd | Out-Null
		Remove-Item install_wim_tweak.exe
		Remove-Item connect.cmd
		Remove-Item Packages.txt
	}
	print "Uninstalled Windows apps."
}


# Unpin all start menu tiles.
Function UnpinStartTiles {
	space
	if ($CurrentBuild -lt 22000) {
		print "Unpinning all tiles from Start Menu..."
		Set-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -Value '<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '  <LayoutOptions StartTileGroupCellWidth="6" />'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '  <DefaultLayoutOverride>'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '    <StartLayoutCollection>'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '      <defaultlayout:StartLayout GroupCellWidth="6" />'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '    </StartLayoutCollection>'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '  </DefaultLayoutOverride>'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '    <CustomTaskbarLayoutCollection>'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '      <defaultlayout:TaskbarLayout>'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '        <taskbar:TaskbarPinList>'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '          <taskbar:UWA AppUserModelID="Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge" />'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '          <taskbar:DesktopApp DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk" />'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '        </taskbar:TaskbarPinList>'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '      </defaultlayout:TaskbarLayout>'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '    </CustomTaskbarLayoutCollection>'
		Add-Content -Path 'C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml' -value '</LayoutModificationTemplate>'
		$START_MENU_LAYOUT = @"
		<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
			<LayoutOptions StartTileGroupCellWidth="6" />
			<DefaultLayoutOverride>
				<StartLayoutCollection>
					<defaultlayout:StartLayout GroupCellWidth="6" />
				</StartLayoutCollection>
			</DefaultLayoutOverride>
		</LayoutModificationTemplate>
"@
		$layoutFile="C:\Windows\StartMenuLayout.xml"
		# Delete layout file if it already exists.
		if(Test-Path $layoutFile)
		{
			Remove-Item $layoutFile
		}
		# Creates a blank layout file.
		$START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII
		$regAliases = @("HKLM", "HKCU")
		# Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level.
		foreach ($regAlias in $regAliases){
			$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
			$keyPath = $basePath + "\Explorer" 
			IF(!(Test-Path -Path $keyPath)) { 
				New-Item -Path $basePath -Name "Explorer" | Out-Null
			}
			Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
			Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
		}
		# Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process.
		Stop-Process -name explorer -Force
		Start-Sleep -s 5
		$wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
		Start-Sleep -s 5
		# Enable the ability to pin items again by disabling "LockedStartLayout".
		foreach ($regAlias in $regAliases){
			$basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
			$keyPath = $basePath + "\Explorer" 
			Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
		}
		# Restart Explorer and delete the layout file.
		Stop-Process -name explorer -Force
		# Uncomment the next line to make clean start menu default for all new users.
		Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
		Remove-Item $layoutFile
		print "Unpinned all tiles from Start Menu."
	}
	elseif ($CurrentBuild -ge 22000) {
		print "This device is currently on Windows 11"
		print "CleanWin does not support unpinning apps from Start menu in Windows 11 yet."
	}
}

# Unpin Apps from taskbar (https://docs.microsoft.com/en-us/answers/questions/214599/unpin-icons-from-taskbar-in-windows-10-20h2.html).
Function UnpinAppsFromTaskbar {
	space
	print "Unpinning apps from taskbar..."
	$AppNames = @(
		"Mail"
		"Microsoft Edge"
		"Microsoft Store"
		"Microsoft Teams"
		"Office"
		"Xbox"
	)
	ForEach ($AppName in $AppNames) {
		if ( $App = ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object { $_.Name -eq $AppName })) {
			$App.Verbs() | Where-Object { $_.Name.replace('&', '') -match 'Unpin from taskbar' } | ForEach-Object {$_.DoIt()} -ErrorAction SilentlyContinue | Out-Null
		}	
	}
	print "Unpinned apps from taskbar."
	Start-Sleep 1
}

# Uninstall Microsoft OneDrive (supports 64-bit versions).
Function UninstallOneDrive {
$ErrorActionPreference = 'SilentlyContinue'
	if (!(check($onedrive))) { 
		return 
	}
	space
	if (!(Get-Command winget)) {
		print "WinGet is not installed. Microsoft OneDrive could not be uninstalled."
		return
	}
	print "Uninstalling Microsoft OneDrive..."

	# Uninstall using WinGet.
	winget uninstall Microsoft.OneDrive --silent | Out-Null

	# Cleanup leftover folders.
	Remove-Item "$env:USERPROFILE\OneDrive" -Recurse -Force
	Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Recurse -Force
	Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force
	Remove-Item "$env:LOCALAPPDATA\OneDrive" -Recurse -Force

	print "Uninstalled Microsoft OneDrive."
}

# Install Microsoft OneDrive 
Function InstallOneDrive {
	if (!(Get-Command winget)) {
		print "WinGet is not installed. Could not install Microsoft OneDrive."
		return
	}
	print "Installing Microsoft OneDrive."
	winget install Microsoft.OneDrive --silent | Out-Null
	$check = winget list Microsoft.OneDrive
	if ($check -like "No installed package found matching input criteria.") {
		print "Could not install Microsoft OneDrive."
		return
	}
	print "Installed Microsoft OneDrive."
}

# Enable Startup boost in Microsoft Edge.
Function EnableEdgeStartupBoost {
	space
	print "Enabling Startup boost for Microsoft Edge..."
	$EdgeStartupBoost = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
	if (!(Test-Path $EdgeStartupBoost )) {
		New-Item -Path $EdgeStartupBoost -Force | Out-Null
		}
	New-ItemProperty -Path $EdgeStartupBoost -Name "StartupBoostEnabled" -Type DWord -Value 1 | Out-Null
	print "Turned on Startup Boost in Microsoft Edge."
}	

# Disable Startup boost in Microsoft Edge.
Function DisableEdgeStartupBoost {
	Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Recurse
}

# Disable "Web Browsing - Restore recommended promo in Settings".
Function DisableBrowserRestoreAd {
$ProgressPreference = 'SilentlyContinue'
	space
	print "Turning off 'Web browsing: Restore recommended' suggestion in Settings..."
    Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Albacore.ViVe.dll
	Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/ViVeTool.exe
	./ViVeTool.exe delconfig 23531064 1 | Out-Null
	Remove-Item ViVeTool.exe
	Remove-Item Albacore.ViVe.dll
    print "Turned off 'Web browsing: Restore recommended' suggestion in Settings."
}

# Enable "Web Browsing - Restore recommended promo in Settings".
Function EnableBrowserRestoreAd {
$ProgressPreference = 'SilentlyContinue'
	space
	print "Turning on 'Web browsing: Restore recommended' suggestion in Settings..."
    Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Albacore.ViVe.dll
	Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/ViVeTool.exe
	./ViVeTool.exe addconfig 23531064 0 | Out-Null
	Remove-Item ViVeTool.exe
	Remove-Item Albacore.ViVe.dll
    print "Turned on 'Web browsing: Restore recommended' suggestion in Settings."
}

# Disable the Microsoft 365 banner in Settings app header (Windows 11 only as of now).
Function DisableM365OnValueBanner {
$ProgressPreference = 'SilentlyContinue'
	if ($CurrentBuild -ge 22000) {
		space
		print "Turning off Microsoft 365 suggestion banner in Settings..."
		Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/mach2.exe
		Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/msdia140.dll
		./mach2.exe disable 29174495 | Out-Null
		Remove-Item mach2.exe -Force; Remove-Item msdia140.dll -Force
		print "Turned off Microsoft 365 suggestion banner in Settings."
	}
}

# Revert Microsoft 365 banner in Settings app header to the default configuration (Windows 11 only as of now).
Function RevertM365OnValueBanner {
$ProgressPreference = 'SilentlyContinue'
	if ($CurrentBuild -ge 22000) {
		space
		print "Turning on Microsoft 365 suggestion banner in Settings..."
		Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/mach2.exe
		Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/msdia140.dll
		./mach2.exe revert 29174495 | Out-Null
		Remove-Item mach2.exe -Force; Remove-Item msdia140.dll -Force
		print "Turned on Microsoft 365 suggestion banner in Settings."
	}
}

# Uninstall Windows Optional Features and Windows Capabilities.
Function UninstallFeatures {
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
	if (!(check($uninstallfeatures))) { 
		return 
	}
	space
	print "Removing capabilites and features..."
	# Uninstall capabilities.
	$Capabilities = @(
		"App.StepsRecorder*"
		"MathRecognizer*"
		"Media.WindowsMediaPlayer*"
		"Microsoft-Windows-SnippingTool*"
		"Microsoft.Windows.MSPaint*" 
		"Microsoft.Windows.PowerShell.ISE*"
		"Microsoft.Windows.WordPad*"
		"Print.Fax.Scan*"
		"XPS.Viewer*"
	)
	ForEach ($Capability in $Capabilities) {
		Get-WindowsCapability -Online | Where-Object {$_.Name -like $Capability} | Remove-WindowsCapability -Online | Out-Null
	}
	if (!(Get-CimInstance -ClassName Win32_PnPEntity | Where-Object -FilterScript {($_.PNPClass -eq "Camera") -or ($_.PNPClass -eq "Image")})) {
		print "    - Uninstalled Windows Hello Face"
		Get-WindowsCapability -Online "Hello.Face*" | Remove-WindowsCapability -Online | Out-Null
	}
	# Print user friendly list of capabilities uninstalled.
	$CapLists =@(
		"Math Recognizer"
		"Microsoft Paint"
		"Snipping Tool"
		"Steps Recorder"
		"Windows Fax & Scan"
		"Windows Media Player"
		"Windows Hello Face"
		"Windows PowerShell ISE"
		"Windows XPS Features"
		"WordPad"
	)
	ForEach ($CapList in $CapLists) {
		Start-Sleep -Milliseconds 70
		print "    - Uninstalled $CapList"
	}

	$OptionalFeatures = @(
		"WorkFolders-Client*"
		"Printing-XPSServices-Feature*"
	)
	ForEach ($OptionalFeature in $OptionalFeatures) {
		Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like $OptionalFeature} | Disable-WindowsOptionalFeature -Online -NoRestart | Out-Null
	}
	# Print user friendly list of features uninstalled.
	print "    - Disabled Work Folders Client."
	
	print "Removed capabilities and features."
}

# Install Windows Optional Features and Windows Capabilities.
Function InstallFeatures {
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$ErrorActionPreference = 'SilentlyContinue'
	space
	print "Adding capabilites and features..."
	# Install capabilities.
	$Capabilities = @(
		"App.StepsRecorder*"
		"Hello.Face*"
		"MathRecognizer*"
		"Media.WindowsMediaPlayer*"
		"Microsoft-Windows-SnippingTool*"
		"Microsoft.Windows.MSPaint*" 
		"Microsoft.Windows.PowerShell.ISE*"
		"Microsoft.Windows.WordPad*"
		"Print.Fax.Scan*"
		"XPS.Viewer*"
	)
	ForEach ($Capability in $Capabilities) {
		Get-WindowsCapability -Online | Where-Object {$_.Name -like $Capability} | Add-WindowsCapability -Online | Out-Null
	}
	# Print user friendly list of capabilities installed.
	$CapLists =@(
		"Math Recognizer"
		"Microsoft Paint"
		"Snipping Tool"
		"Steps Recorder"
		"Windows Fax & Scan"
		"Windows Media Player"
		"Windows Hello Face"
		"Windows PowerShell ISE"
		"Windows XPS Features"
		"WordPad"
	)
	ForEach ($CapList in $CapLists) {
		Start-Sleep -Milliseconds 70
		print "    - Installed $CapList"
	}

	$OptionalFeatures = @(
		"WorkFolders-Client*"
		"Printing-XPSServices-Feature*"
	)
	ForEach ($OptionalFeature in $OptionalFeatures) {
		Get-WindowsOptionalFeature -Online | Where-Object {$_.FeatureName -like $OptionalFeature} | Enable-WindowsOptionalFeature -Online -NoRestart | Out-Null
	}
	# Print user friendly list of features uninstalled.
	print "    - Enabled Work Folders Client."
	
	print "Added capabilities and features."
}

# Disable app suggestions and automatic installation.
Function DisableSuggestions {
	space
	print "Turning off app suggestions and automatic app installation..."
	if (!(Test-Path "C:\CleanWin\Suggestions.reg")) {
		reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "C:\CleanWin\Suggestions.reg" | Out-Null
	}
	else {
		reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "C:\CleanWin\SuggestionsThisMustWork.reg" | Out-Null
	}
	$SyncNotification = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
	Set-ItemProperty -Path $SyncNotification -Name "ShowSyncProviderNotifications" -Type DWord -Value 0
	Remove-ItemProperty -Path $Suggestions -Name "SilentInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SystemPaneSuggestionsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SoftLandingEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent"
	Remove-ItemProperty -Path $Suggestions -Name "ContentDeliveryAllowed"
	Remove-ItemProperty -Path $Suggestions -Name "OemPreInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "PreInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "PreInstalledAppsEverEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SilentInstalledAppsEnabled"
	Remove-ItemProperty -Path $Suggestions -Name "SubscribedContent*"
	Remove-Item -Path "HKU:\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps"
	print "Turned off app suggestions and automatic app installation."
}

# Enable app suggestions and automatic installation.
Function EnableSuggestions {
	space
	print "Turning on app suggestions and automatic app installation..."
	if (Test-Path "C:\CleanWin\Suggestions.reg") {
		reg import "C:\CleanWin\Suggestions.reg" | Out-Null
		print "Turned on app suggestions and automatic app installation."
	}
	elseif (Test-Path "C:\CleanWin\SuggestionsThisMustWork.reg") {
		reg import "C:\CleanWin\SuggestionsThisMustWork.reg" | Out-Null
		print "Turned on app suggestions and automatic app installation."
	}
	else {
		print "Could not turn on suggestions and automatic app installation because the exported registry key was likely deleted."
	}
}

# Enable Windows Subsystem for Linux
Function EnableWSL {
$ProgressPreference = 'SilentlyContinue'
	if (!(check($wsl))) { 
		return 
	}
	space
	if ($CurrentBuild -lt 22000) {
		print "Enabling Windows Subsystem for Linux..."
		Enable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux" -Online -All -NoRestart -WarningAction Ignore | Out-Null
		Enable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -Online -All -NoRestart -WarningAction Ignore | Out-Null
		if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}) {
			Enable-WindowsOptionalFeature -FeatureName "Microsoft-Hyper-V" -Online -All -NoRestart -WarningAction Ignore | Out-Null
		}
		else {
			print "Could not enable Hyper-V since $ProductName does not support it."
		}
		print "Enabled Windows Subsystem for Linux."
	}
	elseif ($CurrentBuild -ge 22000) {
		print "Enabling Windows Subsystem for Linux version 2 along with GUI App support..."
		wsl --install | Out-Null
		print "Enabled Windows Subsystem for Linux."
	}
}

# Disable Windows Subsystem for Linux.
Function DisableWSL {
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
	space
	$wslstate = (Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux").State
	$vmpstate = (Get-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform").State
	if ($wslstate -like "Disabled" -and $vmpstate -like "Disabled") {
		print "Windows Subsystem for Linux may have already been disabled."
		return
	}
	print "Disabling Windows Subsystem for Linux..."
	Disable-WindowsOptionalFeature -FeatureName "Microsoft-Windows-Subsystem-Linux" -Online -All -NoRestart | Out-Null
	Disable-WindowsOptionalFeature -FeatureName "VirtualMachinePlatform" -Online -All -NoRestart | Out-Null 
	if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"}) {
		$hypervstate = (Get-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V").State
		if ($hypervstate -like "Disabled") {
			Disable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Hyper-V"
		}
	}
	print "Disabled Windows Subsystem for Linux."
}

# Enable Sandbox.
Function EnableSandbox {
$ProgressPreference = 'SilentlyContinue'
	space
	if (!(Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"})) {
		print "Could not enable Windows Sandbox since $ProductName does not support it."
		return
	}
	print "Enabling Windows Sandbox..."
	Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart -WarningAction Ignore | Out-Null
	print "Enabled Windows Sandbox."
}

# Disable Sandbox
Function DisableSandbox {
$ProgressPreference = 'SilentlyContinue'
	space
	if (!(Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"})) {
		print "Windows Sandbox can't be toggled in $ProductName."
		return
	}
	print "Disabling Windows Sandbox..."
	Disable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online -NoRestart -WarningAction Ignore | Out-Null
	print "Disabled Windows Sandbox."
}

# Enable dotNET 3.5.
Function EnabledotNET3.5 {
$ProgressPreference = 'SilentlyContinue'
	if (!(check($netfx3))) { 
		return 
	}
	$netfx3state = (Get-WindowsOptionalFeature -Online -FeatureName "NetFx3").State
	if ($netfx3state -like "Enabled"){
		Write-Host "dotNET 3.5 is already enabled."
		return
	}
	space
	print "Enabling dotNET 3.5..."
	Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -NoRestart
	print "Enabled dotNET 3.5."
}

Function DisabledotNET3.5 {
$ProgressPreference = 'SilentlyContinue'
	space
	$netfx3state = (Get-WindowsOptionalFeature -Online -FeatureName "NetFx3").State
	if ($netfx3state -like "Disabled"){
		print "dotNET 3.5 is already disabled."
		return
	}
	print "Disabling dotNET 3.5..."
	Disable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -NoRestart
	print "Disabled dotNET 3.5."
}

# Install runtime packages 
Function InstallFrameworks {
	if (Get-AppxPackage "Microsoft.VCLibs.*.UWPDesktop") {
		return
	}
	space
	print "Preparing download..."
	# Create new folder and set location.
	if (!(Test-Path CleanWin)) {
		New-Item CleanWin -ItemType Directory | out-Null
		$currentdir = $(Get-Location).Path; $dir = "$currentdir/CleanWin"; Set-Location $dir
	}
	else {
		Set-Location CleanWin
	}
	# Download frameworks.
	print "Downloading app frameworks..."
	$VCLibs1 = "https://github.com/CleanWin/Files/raw/main/Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x64__8wekyb3d8bbwe.Appx"
	$VCLibs2 = "https://github.com/CleanWin/Files/raw/main/Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x86__8wekyb3d8bbwe.Appx"
	$VCLibs3 = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx"
	$VCLibs4 = "https://aka.ms/Microsoft.VCLibs.x86.14.00.Desktop.appx"
	Start-BitsTransfer $VCLibs1; Start-BitsTransfer $VCLibs2; Start-BitsTransfer $VCLibs3; Start-BitsTransfer $VCLibs4

	# Install frameworks.
	print "Installing app frameworks..."
	$VCLibs1 = "Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x64__8wekyb3d8bbwe.Appx"
	$VCLibs2 = "Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x86__8wekyb3d8bbwe.Appx"
	$VCLibs3 = "Microsoft.VCLibs.x64.14.00.Desktop.appx"
	$VCLibs4 = "Microsoft.VCLibs.x86.14.00.Desktop.appx"
	Add-AppxPackage $VCLibs1; Add-AppxPackage $VCLibs2; Add-AppxPackage $VCLibs3; Add-AppxPackage $VCLibs4

	# Cleanup installers.
	Set-Location ..
	Remove-Item CleanWin -Recurse -Force
		
	# Get-Command VCLibs, if it works then print success message.
	if (Get-AppxPackage "Microsoft.VCLibs.*.UWPDesktop") {
		print "Installed app frameworks."
	}
	elseif (!(Get-AppxPackage "Microsoft.VCLibs.*.UWPDesktop")) {
		print "Could not install app frameworks."
	}

}

Function UninstallFrameworks {
	space
	if (!(Get-AppxPackage "Microsoft.VCLibs.140.00.UWPDesktop" -or Get-AppxPackage "Microsoft.VCLibs.x64.14.00.Desktop")) {
		print "Frameworks are not present on this device."
		return
	}
	print "Uninstalling frameworks..."
	$Apps = @(
		"Microsoft.VCLibs.140.00.UWPDesktop"
		"Microsoft.VCLibs.x64.14.00.Desktop"
		"Microsoft.VCLibs.x86.14.00.Desktop"
	)
	ForEach ($App in $Apps) {
		print "     Uninstalling $App."
		Get-AppxPackage $App | Remove-AppxPackage
	}
	if (!(Get-AppxPackage "Microsoft.VCLibs.140.00.UWPDesktop")) {
		print "Could not uninstall one or more frameworks."
		return
	}
	print "Uninstalled frameworks."
}

# Install WinGet (Windows Package Manager).
Function InstallWinGet {
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
	space
	if (Get-Command winget) {
		print "WinGet is already installed on this device."
		return 
	}
	print "Preparing download..."
	# Create new folder and set location.
	if (!(Test-Path CleanWin)) {
		New-Item CleanWin -ItemType Directory | Out-Null
		$currentdir = $(Get-Location).Path
		$dir = "$currentdir/CleanWin"
		Set-Location $dir
	}
	else {
		Set-Location CleanWin
	}

	# Download the packages.
	$WinGetURL = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
	print "Downloading WinGet installation packages..."
	Start-BitsTransfer $WinGetURL.assets.browser_download_url

	# Install WinGet.
	print "Installing WinGet..."
	Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
		
	# Cleanup installers.
	Set-Location ..
	Remove-Item CleanWin -Recurse -Force

	# Get-Command winget, if it works then print success message.
	if (Get-Command winget) {
		print "Installed WinGet."
	}
	else {
		print "WinGet could not be installed."
	}
}

# Install 7zip.
Function Install7zip {
	space
	if (!(Get-Command winget)) {
		print "WinGet is not installed. Couldn't install 7-zip."
		return 
	}
	$7zip = "HKLM:\SOFTWARE\7-Zip"
	if (!(Test-Path $7zip)) {
		print "Installing 7-zip..."
		winget install 7zip --silent
	}
	else {
		print "7-zip is already installed on this device."
	}
}

# Uninstall 7zip
Function Uninstall7zip {
	space
	$7zip = "HKLM:\SOFTWARE\7-Zip"
	if (!(Test-Path $7zip)) {
		print "7-zip is not present on this device."
		return
	}
	print "Uninstalling 7-zip..."
	winget uninstall 7zip.7zip | Out-Null
	if (Test-Path $7zip) {
		print "Could not uninstall 7-zip."
		return
	}
	print "Uninstalled 7-zip."
}

# Install apps from Winstall file (the Winstall.txt file must be on the same directory as CleanWin).
Function Winstall {
$ErrorActionPreference = 'Continue'
	# Check if WinGet installed - otherwise return.
	if (!(check($winstall))) { 
		return 
	}
	space
	if (!(Get-Command winget)) { 
		print "WinGet is not installed. Please install WinGet first before using Winstall."
		Start-Process "https://bit.ly/Winstall" 
		return
	}
	# Try Winstall.txt
	if (Test-Path Winstall.txt) {
		print "Starting Winstall..."
		# Get each line from the text file and use winget install command on it.
		Get-Content 'Winstall.txt' | ForEach-Object {
			$App = $_.Split('=')
			print "    Installing $App..."
			winget install "$App" --silent | Out-Null
		}
		print "Winstall has successfully installed the app(s)."
	}
	# Try winstall.txt
	elseif (Test-Path winstall.txt) {
		print "Starting Winstall..."
		# Get each line from the text file and use winget install command on it.
		Get-Content 'winstall.txt' | ForEach-Object {
			$App = $_.Split('=')
			print "    Installing $App..."
			winget install "$App" --silent | Out-Null
		}
		print "Winstall has successfully installed the app(s)."
	}
	else {
		[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
		print "Select Winstall text file from File Picker UI"
		$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
		$OpenFileDialog.InitialDirectory = $initialDirectory
		$OpenFileDialog.Filter = "Text file (*.txt)| *.txt"
		$OpenFileDialog.ShowDialog() | Out-Null
		if ($OpenFileDialog.FileName) {
			print "Starting Winstall..."
			Get-Content $OpenFileDialog.FileName | ForEach-Object {					$App = $_.Split('=')
				print "    Installing $App..."
				winget install "$App" --silent | Out-Null
			}
			print "Winstall has successfully installed the app(s)."
		}
		else {
			print "No text file was picked."
		}
	}
}

# Enable all experimental features in WinGet.
Function EnableExperimentsWinGet {
	if (!(check($enableexperimentswinget))) { 
		return 
	}
	elseif (!(Get-Command winget)) {
		print "WinGet is not installed."
		return
	}
	space
	print "Turning on experimental features in WinGet..."
	$currentdir = $(Get-Location).Path
	Set-Location "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\"
	Rename-Item settings.json settings.json.backup
	Start-BitsTransfer "https://raw.githubusercontent.com/CleanWin/Files/main/settings.json"
	Set-Location $currentdir
	print "Turned on experimental features in WinGet."
}

Function DisableExperimentsWinGet {
	if (!(Get-Command winget)) {
		print "WinGet is not installed, couldn't turn off its experimental features."
		return
	}
	print "Turning off experimental features in WinGet."
	$currentdir = $(Get-Location).Path
	Set-Location "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\"
	Remove-Item settings.json
	Rename-Item settings.json.backup settings.json
	Set-Location $currentdir
	print "Turned off experimental features in WinGet."
}


# Use winget import (optional) (part of code used here was picked from https://devblogs.microsoft.com/scripting/hey-scripting-guy-can-i-open-a-file-dialog-box-with-windows-powershell/)
Function WinGetImport {
	if (!($wingetimport)) {
		return
	}
	if (!(Get-Command winget)) {
		print "WinGet is not installed. Please install WinGet first before using winget import."
		return
	}
	[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
	print "Select the exported JSON from File Picker UI"
	$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
	$OpenFileDialog.InitialDirectory = $initialDirectory
	$OpenFileDialog.Filter = "JSON (*.json)| *.json"
	$OpenFileDialog.ShowDialog() | Out-Null
	if ($OpenFileDialog.FileName) {
		print "Initializing JSON file..."
		Start-Sleep -Milliseconds 200
		winget import $OpenFileDialog.FileName
	}
	elseif (!($OpenFileDialog.FileName)) {
		print "No JSON selected."
	}
}

# Install HEVC.
Function InstallHEVC {
$ProgressPreference = 'SilentlyContinue'
	space
	if (Get-AppxPackage -Name Microsoft.HEVCVideoExtension) {
		print "HEVC Video Extensions are already installed on this device."
		return
	}
	$OSArchitecture = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
	if ($OSArchitecture -like "64-bit") {
		print "Downloading HEVC Video Extensions..."
		Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Microsoft.HEVCVideoExtension_1.0.41483.0_x64__8wekyb3d8bbwe.Appx
		print "Installing HEVC Video Extensions..."
		Add-AppxPackage Microsoft.HEVCVideoExtension_1.0.41483.0_x64__8wekyb3d8bbwe.Appx
		Remove-Item Microsoft.HEVCVideoExtension_1.0.41483.0_x64__8wekyb3d8bbwe.Appx
		print "Installed HEVC Video Extensions."
	}
	elseif ($OSArchitecture -like "32-bit") {
		print "Downloading HEVC Video Extensions..."
		Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/Microsoft.HEVCVideoExtension_1.0.41483.0_x86__8wekyb3d8bbwe.Appx
		print "Installing HEVC Video Extensions..."
		Add-AppxPackage Microsoft.HEVCVideoExtension_1.0.41483.0_x86__8wekyb3d8bbwe.Appx
		Remove-Item Microsoft.HEVCVideoExtension_1.0.41483.0_x86__8wekyb3d8bbwe.Appx
		print "Installed HEVC Video Extensions."
	}
	else {
		# Error out.
		print "Could not install HEVC Video Extensions."
	}
}

# Uninstall HEVC 
Function UninstallHEVC {
$ProgressPreference = 'SilentlyContinue'
	space
	if (!(Get-AppxPackage "Microsoft.HEVCVideoExtension")) {
		print "HEVC Video Extensions may have already been uninstalled."
		return
	}
	print "Uninstalling HEVC Video Extensions..."
	Get-AppxPackage "Microsoft.HEVCVideoExtension" | Remove-AppxPackage
	if (!(Get-AppxPackage "Microsoft.HEVCVideoExtension")) {
		print "Uninstalled HEVC Video Extensions."
	}
	else {
		print "Could not uninstall HEVC Video Extensions."
	}
}

# Unfinished function.
Function Widgets {
$ProgressPreference = 'SilentlyContinue'
	space
	if ($widgets -like "n") {
		if ($CurrentBuild -lt 22000) {
			print "This device is not running Windows 11. Widgets can't be updated on older versions of Windows."
			return
		}
		print "Checking if Widgets are updated..."
		$version = (Get-AppxPackage "MicrosoftWindows.Client.WebExperience").Version
			if ($version -lt 421.17400.0.0) {
			print "Updating Widgets..."
			Start-BitsTransfer https://github.com/CleanWin/Files/raw/main/MicrosoftWindows.Client.WebExperience_421.17400.0.0_neutral___cw5n1h2txyewy.AppxBundle
			Add-AppxPackage MicrosoftWindows.Client.WebExperience_421.17400.0.0_neutral___cw5n1h2txyewy.AppxBundle
			$version = (Get-AppxPackage "MicrosoftWindows.Client.WebExperience").Version
			Remove-Item MicrosoftWindows.Client.WebExperience_421.17400.0.0_neutral___cw5n1h2txyewy.AppxBundle
			if ($version -ge 421.17400.0.0) {
				print "Updated Widgets."
			}
			else {
				print "Could not update Widgets."
			}
		}
		elseif ($version -ge 421.17400.0.0) {
			print "Widgets are already updated."
		}
	}
	elseif ($widgets -like "y") {
		if (!(Get-AppxPackage "MicrosoftWindows.Client.WebExperience")) {
			print "Widgets may have already been removed."
			return
		}
		print "Removing Widgets..."
		Get-AppxPackage "MicrosoftWindows.Client.WebExperience" | Remove-AppxPackage
		if (Get-AppxPackage "MicrosoftWindows.Client.WebExperience"){
			print "Could not remove Widgets."
		}
		else {
			print "Removed Widgets."
		}
	}
}

# Install fonts (part of code here was picked from https://github.com/code-rgb/CleanWin).
Function InstallFonts {
$ProgressPreference = 'SilentlyContinue'
	space
	# Check if Cascadia Code is installed and inform user.
	$installed = "C:\Windows\Fonts\CascadiaCodePL.ttf"
	if (Test-Path -Path $installed) {
		print "Cascadia Code is already installed on this device."
		return
	}
	# Install Cascadia Code if not already installed.
	print "Downloading the latest release of Cascadia Code..."
	$response = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/cascadia-code/releases/latest"
	Start-BitsTransfer -Source $response.assets.browser_download_url -Destination "CascadiaCode.zip"
	print "Installing Cascadia Code..."
	Expand-Archive CascadiaCode.zip
	$font = $(Get-ChildItem "CascadiaCode\ttf\CascadiaCodePL.ttf").FullName
	$installed = "C:\Windows\Fonts\CascadiaCodePL.ttf"
	Move-Item $font $installed
	Remove-Item CascadiaCode.zip
	Remove-Item CascadiaCode -Recurse -Force
	print "Installed Cascadia Code."
}

Function UninstallFonts {
	space
	$fontfile = "C:\Windows\Fonts\CascadiaCodePL.ttf"
	if (!($fontfile)) {
		print "Fonts may have already been uninstalled."
		return
	}
	print "Uninstalling fonts..."
	Remove-Item $fontfile
	if (!($fontfile)) {
		print "Uninstalled fonts."
	}
	else {
		print "Could not uninstall fonts."
	}
}

# Set Windows Photo Viewer association for bmp, gif, jpg, png and tif.
Function SetPhotoViewerAssociation {
	space
	Write-Output "Adding Windows Photo Viewer (classic) to the 'Open with' menu..."
	if (!(Test-Path "HKCR:")) {
		New-PSDrive -Name "HKCR" -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" | Out-Null
	}
	ForEach ($type in @("Paint.Picture", "giffile", "jpegfile", "pngfile")) {
		New-Item -Path $("HKCR:\$type\shell\open") -Force | Out-Null
		New-Item -Path $("HKCR:\$type\shell\open\command") | Out-Null
		Set-ItemProperty -Path $("HKCR:\$type\shell\open") -Name "MuiVerb" -Type ExpandString -Value "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"
		Set-ItemProperty -Path $("HKCR:\$type\shell\open\command") -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
	}
	Write-Output "Added Windows Photo Viewer (classic) to the 'Open with' menu."

}

# Unset Windows Photo Viewer association for bmp, gif, jpg, png and tif.
Function UnsetPhotoViewerAssociation {
	Write-Output "Removing Windows Photo Viewer (classic) from the 'Open with' menu..."
	if (!(Test-Path "HKCR:")) {
		New-PSDrive -Name "HKCR" -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" | Out-Null
	}
	Remove-Item -Path "HKCR:\Paint.Picture\shell\open" -Recurse -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "MuiVerb" -ErrorAction SilentlyContinue
	Set-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "CommandId" -Type String -Value "IE.File"
	Set-ItemProperty -Path "HKCR:\giffile\shell\open\command" -Name "(Default)" -Type String -Value "`"$env:SystemDrive\Program Files\Internet Explorer\iexplore.exe`" %1"
	Set-ItemProperty -Path "HKCR:\giffile\shell\open\command" -Name "DelegateExecute" -Type String -Value "{17FE9752-0B5A-4665-84CD-569794602F5C}"
	Remove-Item -Path "HKCR:\jpegfile\shell\open" -Recurse -ErrorAction SilentlyContinue
	Remove-Item -Path "HKCR:\pngfile\shell\open" -Recurse -ErrorAction SilentlyContinue
	print "Removed Windows Photo Viewer association."
}



######################################
######### PRIVACY & SECURITY #########
######################################

# Update status
Function PrivacySecurity {
	space
	print "-------------------------"
	print "    PRIVACY & SECURITY   "
	print "-------------------------"
	space
}


# Disable Activity History.
Function DisableActivityHistory {
	space
	print "Turning off Activity History..."
	$ActivityFeed = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityFeed -Name "EnableActivityFeed" -Type DWord -Value 0
	Set-ItemProperty -Path $ActivityFeed -Name "PublishUserActivities" -Type DWord -Value 0
	Set-ItemProperty -Path $ActivityFeed -Name "UploadUserActivities" -Type DWord -Value 0	
	print "Turned off Activity History."
}

# Enable Activity History.
Function EnableActivityHistory {
	print "Turning on Activity History..."
	$ActivityHistory = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
	Set-ItemProperty -Path $ActivityHistory -Name "EnableActivityFeed" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "PublishUserActivities" -Type DWord -Value 1
	Set-ItemProperty -Path $ActivityHistory -Name "UploadUserActivities" -Type DWord -Value 1
	print "Turned on Activity History."
}

# Disable Advertising ID.
Function DisableAdvertisingID {
	space
	print "Turning off Advertising ID..."
	$AdvertisingID = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
	if (!(Test-Path $AdvertisingID)) {
		New-Item -Path $AdvertisingID | Out-Null
	}
	Set-ItemProperty -Path $AdvertisingID -Name "DisabledByGroupPolicy" -Type DWord -Value 1
	print "Turned off Advertising ID."
}

# Enable Advertising ID.
Function EnableAdvertisingID {
	print "Turning on Advertising ID..."
	$Advertising = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
	Remove-ItemProperty -Path $Advertising -Name "DisabledByGroupPolicy" -ErrorAction SilentlyContinue
	print "Turned on Advertising ID."
}

# Disable Background apps (https://github.com/farag2/Windows-10-Sophia-Script/blob/master/Sophia/PowerShell%205.1/Sophia.psm1#L8988-L9033).
Function DisableBackgroundApps {
	space
	Write-Output "Turning off Background apps..."
	Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process {
		Remove-ItemProperty -Path $_.PsPath -Name * -Force
	}
	$ExcludedApps = @(
		"Microsoft.LockApp",
		"Microsoft.Windows.ContentDeliveryManager",
		"Microsoft.549981C3F5F10",
		"Microsoft.Windows.Search",
		"Microsoft.Windows.SecHealthUI",
		"Microsoft.Windows.ShellExperienceHost",
		"Microsoft.Windows.StartMenuExperienceHost",
		"Microsoft.WindowsStore"
		)
		$OFS = "|"
		Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | Where-Object -FilterScript {$_.PSChildName -notmatch "^$($ExcludedApps.ForEach({[regex]::Escape($_)}))"} | ForEach-Object -Process {
			New-ItemProperty -Path $_.PsPath -Name Disabled -PropertyType DWord -Value 1 -Force | Out-Null
			New-ItemProperty -Path $_.PsPath -Name DisabledByUser -PropertyType DWord -Value 1 -Force | Out-Null
		}
		$OFS = " "
	print "Turned off Background apps."
}

# Enable Background apps.
Function EnableBackgroundApps {
	print "Turning on Background apps..."
	Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process {
		Remove-ItemProperty -Path $_.PsPath -Name * -Force
	}
	print "Turned on Background apps."
}

# Disable Feedback.
Function DisableFeedback {
$ErrorActionPreference = 'SilentlyContinue'
	space
	print "Turning off Feedback notifications..."
	$Feedback1 = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	$Feedback2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	$Feedback3 = "Microsoft\Windows\Feedback\Siuf\DmClient"
	$Feedback4 = "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
	if (!(Test-Path $Feedback1)) {
		New-Item -Path $Feedback1 -Force | Out-Null
		}
	Set-ItemProperty -Path $Feedback1 -Name "NumberOfSIUFInPeriod" -Type DWord -Value 1
	if (!(Test-Path $Feedback2)) {
		New-Item -Path $Feedback2 -Force | Out-Null
		}
	Set-ItemProperty -Path $Feedback2 -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
	Disable-ScheduledTask -TaskName $Feedback3 | Out-Null
	Disable-ScheduledTask -TaskName $Feedback4 | Out-Null
	print "Turned off Feedback notifications."
}

# Enable Feedback.
Function EnableFeedback {
	print "Turning on Feedback notifications..."
	$Feedback = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
	if (!(Test-Path $Feedback )) {
		New-Item $Feedback -Force | Out-Null
		}
	Remove-ItemProperty -Path $Feedback -Name "NumberOfSIUFInPeriod"
	print "Turned on Feedback notifications."
}

# Disable inking personalization.
Function DisableInkHarvesting {
	space
	print "Turning off Inking & typing personalization..."
	$Ink1 = "HKCU:\Software\Microsoft\InputPersonalization"
	$Ink2 = "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore"
	$Ink3 = "HKCU:\Software\Microsoft\Personalization\Settings"
	if (!(Test-Path $Ink1)) {
		New-Item -Path $Ink1 -Force | Out-Null
	}
	New-ItemProperty -Path $Ink1 -Name "RestrictImplicitInkCollection" -Type DWord -Value 1 -Force | Out-Null 
	Set-ItemProperty -Path $Ink2 -Name "HarvestContacts" -Type DWord -Value 0
	Set-ItemProperty -Path $Ink3 -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
	print "Turned off Inking & typing personalization."
}

# Enable inking personalization. 
Function EnableInkHarvesting {
	space
	print "Turning on Inking & typing personalization..."
	$Ink1 = "HKCU:\Software\Microsoft\InputPersonalization"
	$Ink2 = "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore"
	$Ink3 = "HKCU:\Software\Microsoft\Personalization\Settings"
	if (!(Test-Path $Ink1)) {
		New-Item -Path $Ink1 -Force | Out-Null
	}
	New-ItemProperty -Path $Ink1 -Name "RestrictImplicitInkCollection" -Type DWord -Value 0 -Force | Out-Null 
	Set-ItemProperty -Path $Ink2 -Name "HarvestContacts" -Type DWord -Value 1
	Set-ItemProperty -Path $Ink3 -Name "AcceptedPrivacyPolicy" -Type DWord -Value 1
	print "Turned on Inking & typing personalization."
}

# Disable "Let websites provide locally relevant content by accessing my language list".
Function DisableLangAccess {
	space
	print "Turning off websites' ability to provide you with locally relevant content by accessing your language list..."
	$LangAccess = "HKCU:\Control Panel\International\User Profile"
	Remove-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -ErrorAction SilentlyContinue | Out-Null
	New-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 1 | Out-Null
	print "Turned off websites' ability to provide you with locally relevant content by accessing your language list."
}

# Enable "Let websites provide locally relevant content by accessing my language list".
Function EnableLangAccess {
	print "Turning on websites' ability to provide you with locally relevant content by accessing your language list..."
	$LangAccess = "HKCU:\Control Panel\International\User Profile"
	Set-ItemProperty -Path $LangAccess -Name "HttpAcceptLanguageOptOut" -Type DWord -Value 0
	print "Turned on websites' ability to provide you with locally relevant content by accessing your language list."
}

# Disable Location Tracking.
Function DisableLocationTracking {
	space
	print "Turning off location tracking..."
	$Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
	$Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
	if (!(Test-Path $Location1)) {
		New-Item -Path $Location1 -Force | Out-Null
		}
	Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Deny"
	Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 0
	print "Turned off Location tracking."
}

# Enable location tracking.
Function EnableLocationTracking {
	space
	print "Turning on Location tracking..."
	$Location1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
	$Location2 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
	if (!(Test-Path )) {
		New-Item -Path $Location1 -Force | Out-Null
		}
	Set-ItemProperty -Path $Location1 -Name "Value" -Type String -Value "Allow"
	Set-ItemProperty -Path $Location2 -Name "SensorPermissionState" -Type DWord -Value 1
	print "Turned on Location tracking."
}

# Disable automatic Maps updates.
Function DisableMapUpdates {
	space
	print "Turning off automatic Maps updates..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -Type DWord -Value 0
	print "Turned off automatic Maps updates."
}

# Enable maps updates.
Function EnableMapsUpdates {
	space
	print "Turning on automatic Maps updates..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled"
	print "Turned on automatic Maps updates."
}

# Disable Speech Recognition.
Function DisableSpeechRecognition {
	space
	print "Turning off Online Speech recognition..."
	$Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	if (!(Test-Path $Speech)) {
		New-Item -Path $Speech -ErrorAction SilentlyContinue | Out-Null
	}
	Remove-ItemProperty -Path $Speech -Name "HasAccepted" -ErrorAction SilentlyContinue
	New-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 0 -ErrorAction SilentlyContinue | Out-Null
	print "Turned off Online Speech recognition."
}

# Enable speech recognition. 
Function EnableSpeechRecognition {
	space
	print "Turning on Speech recognition..."
	$Speech = "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
	if (!(Test-Path )) {
		New-Item -Path $Speech | Out-Null
		}
	Set-ItemProperty -Path $Speech -Name "HasAccepted" -Type DWord -Value 1
	print "Turned on Online Speech recognition"
}

# Disable Tailored experiences.
Function DisableTailoredExperiences {
	space
	print "Turning off Tailored experiences..."
	$CloudContent = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	if (!(Test-Path $CloudContent )) {
		New-Item $CloudContent -Force | Out-Null
		}
	Set-ItemProperty -Path $CloudContent -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1
	print "Turned off Tailored experiences."
}

# Enable Tailored experiences.
Function EnableTailoredExperiences {
	space
	print "Turning on Tailored experiences..."
	$TailoredExp1 = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
	$TailoredExp2 = "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting"
	$TailoredExp3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Remove-ItemProperty -Path $TailoredExp1 -Name "DisableTailoredExperiencesWithDiagnosticData" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $TailoredExp2 -Name "Disabled" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path $TailoredExp3 -Name "DoNotShowFeedbackNotifications" -ErrorAction SilentlyContinue
	print "Turned on Tailed experiences."
}

# Disable Telemetry. 
Function DisableTelemetry {
	space
	print "Turning off telemetry..."
	$DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$DataCollection2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$DataCollection3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Set-ItemProperty -Path $DataCollection1 -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path $DataCollection2 -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path $DataCollection3 -Name "AllowTelemetry" -Type DWord -Value 0
	print "Turned off telemetry."
}

# Enable Telemetry.
Function EnableTelemetry {
	space
	print "Turning on Telemetry..."
	$Telemetry1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
	$Telemetry3 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
	Set-ItemProperty -Path $Telemetry1  -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path $Telemetry2 -Name "AllowTelemetry" -Type DWord -Value 3
	Set-ItemProperty -Path $Telemetry3 -Name "AllowTelemetry" -Type DWord -Value 3
	print "Turned off telemetry."
}

# Enable Clipboard History.
Function EnableClipboard {
	space
	print "Turning on Clipboard History..."
	$Clipboard = "HKU:\$hkeyuser\Software\Microsoft\Clipboard"
	Set-ItemProperty -Path $Clipboard -Name "EnableClipboardHistory" -Value 1 -ErrorAction SilentlyContinue
	print "Turned on Clipboard History."
    Start-Sleep 1
    Set-Clipboard "Demo text by CleanWin."
	print "You can now copy multiple items to your clipboard."
    print "Access your clipboard now using Windows key + V."
}

# Disable Clipboard History.
Function DisableClipboard {
	space
	print "Turning off Clipboard History..."
	$Clipboard = "HKU:\$hkeyuser\Software\Microsoft\Clipboard"
	Set-ItemProperty -Path $Clipboard -Name "EnableClipboardHistory" -Value 0 -ErrorAction SilentlyContinue
	print "Turned off Clipboard History."
}

Function AutoLoginPostUpdate {
	space
	print "Turning on automatic login post updates..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent" -Type DWord -Value 1
	print "Turned on Automatic login applying updates"
} 

Function StayOnLockscreenPostUpdate {
	space
	print "Turning off automatic login post updates..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "ARSOUserConsent"
	print "Turned off Automatic login after applying updates."
}



####################################
######### TASKS & SERVICES #########
####################################

# Update status.
Function TasksServices {
	space
	space
	print "---------------------------"
	print "      TASKS & SERVICES     "   
	print "---------------------------"
	space
}

# Disable Autoplay.
Function DisableAutoplay {
	space
	print "Turning off AutoPlay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
	print "Turned off AutoPlay."
}

# Enable Autoplay.
Function EnableAutoplay {
	space
	print "Turning on Autoplay..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
	print "Turned on AutoPlay."
}

# Disable Autorun for all drives.
Function DisableAutorun {
	space
	print "Turning off Autorun for all drives..."
	$Autorun = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
	if (!(Test-Path $Autorun)) {
		New-Item -Path $Autorun | Out-Null
		}
	Set-ItemProperty -Path $Autorun -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
	print "Turned off Autorun for all drives."
}

# Enable Autorun for removable drives.
Function EnableAutorun {
	space
	print "Turning on Autorun for all drives..."
	Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
	print "Turned on Autorun for all drives."
}

# Set BIOS time to UTC.
Function SetBIOSTimeUTC {
	space
	print "Setting BIOS time to UTC..."
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1
	print "BIOS Time is set to UTC."
}

# Set BIOS time to local time.
Function SetBIOSTimeLocal {
	space
	print "Setting BIOS time to Local time..."
	Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -ErrorAction SilentlyContinue
	print "BIOS Time is set to Local time."
}

# Enable Num lock on startup.
Function EnableNumLock {
	space
	print "Setting Num lock to turn on autoamtically on Startup..."
	New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483650 -Force | Out-Null
	print "Num lock will turn on automatically on Startup."
}

# Disable Num lock on startup.
Function DisableNumLock {
	space
	New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483648 -Force | Out-Null
	print "Num lock will no longer turn on automatically on Startup."
}

# Enable Storage Sense. 
Function EnableStorageSense {
	space
	print "Turning on Storage Sense..."
	$EnableStorageSense = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
	New-Item -Path $EnableStorageSense -ItemType Directory -Force | Out-Null
	New-ItemProperty -Path $EnableStorageSense -Name 01 -PropertyType DWord -Value 1 -Force | Out-Null
	print "Turned on Storage Sense."
}

# Disable Storage Sense.
Function DisableStorageSense {
	space
	print "Turning off Storage Sense..."
	$DisableStorageSense = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"
	New-Item -Path $DisableStorageSense -ItemType Directory -Force | Out-Null
	New-ItemProperty -Path $DisableStorageSense -Name 01 -PropertyType DWord -Value 0 -Force | Out-Null
	print "Turned off Storage Sense."
}

# Disable Reserved Storage. 
Function DisableReservedStorage {
	space
	print "Turning off Reserved Storage..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" -Name "ShippedWithReserves" -Type DWord -Value 0
	print "Turned off Reserved Storage."
}

# Enable Reserved Storage. 
Function EnableReservedStorage {
	space
	print "Turning on Reserved Storage..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" -Name "ShippedWithReserves" -Type DWord -Value 1
	print "Turned on Reserved Storage."
}

# Disable unnecessary services.
Function DisableServices {
$ErrorActionPreference = 'SilentlyContinue'
	space
	print "Turning off unnecessary services..."
    	$Services = @(
		"DiagTrack"
		"SysMain"
    )
    ForEach ($Service in $Services) {
		Stop-Service $Service | Out-Null
		Set-Service $Service -StartupType Disabled
		print "    Stopped service: $Service."
	}
	print "Turned off unnecesarry services."
}

# Enable unnecessary services.
Function EnableServices {
$ErrorActionPreference = 'SilentlyContinue'
	space
	print "Turning on unnecessary services..."
    	$Services = @(
		"DiagTrack"
		"SysMain"
    )
    ForEach ($Service in $Services) {
		Start-Service $Service | Out-Null
		Set-Service $Service -StartupType Automatic
		print "    Started service: $Service."
	}
	print "Turned on redundant services."
}

# Disable unnecessary scheduled tasks.
Function DisableTasks {
	space
	print "Turning off unnecessary tasks..."
	$Tasks = @(
		"Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
		"Microsoft\Windows\Application Experience\ProgramDataUpdater"
        "Microsoft\Windows\Application Experience\PcaPatchDbTask"
		"Microsoft\Windows\Autochk\Proxy"
        "Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
		"Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 
		"Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" 
		"Microsoft\Windows\Windows Error Reporting\QueueReporting" 
		"Microsoft\Windows\Feedback\Siuf\DmClient"
		"Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
    )
    ForEach ($Task in $Tasks) {
		Disable-ScheduledTask -TaskName $Task | Out-Null -ErrorAction SilentlyContinue
		print "    Turned off task: $Task."
	}
    print "Turned off unnecessary tasks."
}

# Enable unnecessary scheduled tasks.
Function EnableTasks {
	$Tasks = @(
		"Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
		"Microsoft\Windows\Application Experience\ProgramDataUpdater"
		"Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
		"Microsoft\Windows\Autochk\Proxy"
		"Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 
		"Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" 
		"Microsoft\Windows\Windows Error Reporting\QueueReporting" 
		"Microsoft\Windows\Feedback\Siuf\DmClient"
		"Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
    )
    ForEach ($Task in $Tasks) {
		Enable-ScheduledTask -TaskName $Task | Out-Null -ErrorAction SilentlyContinue
		print "    Turned on task: $Task."
	}
    print "Turned on redundant tasks."
}

# Intelligently setup Windows Update policies.
Function SetupWindowsUpdate {
	space
	if ($CurrentBuild -ge 22000) {
		print "CleanWin currently cannot set up Windows Update policies on Windows 11."
		return 
	}
	# Get Windows Edition, if its Professional, Education, or Enterprise.
    if (!(Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education" -or $_.Edition -eq "Professional"})) {
		print "$ProductName does not support setting up Windows Update policies."
		return
	}
	print "Setting up Windows Update policies..."

	# Declare registry keys locations.
	$Update1 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
	$Update2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
	if (!(Test-Path $Update1)) {
		New-Item -Path $Update1 | Out-Null
		New-Item -Path $Update2 | Out-Null
	}

	# Write registry values.
	Set-ItemProperty -Path $Update1 -Name DeferQualityUpdates -Type DWord -Value 1
	Set-ItemProperty -Path $Update1 -Name DeferQualityUpdatesPeriodInDays -Type DWord -Value 4
	Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdates -Type DWord -Value 1
	Set-ItemProperty -Path $Update1 -Name DeferFeatureUpdatesPeriodInDays -Type DWord -Value 20
	Set-ItemProperty -Path $Update2 -Name NoAutoUpdate -Type DWord -Value 1
	Set-ItemProperty -Path $Update2 -Name NoAutoRebootWithLoggedOnUsers -Type Dword -Value 1

	# Print user message; policies applied.
	$WinUpdatePolicies =@(
		"Turned off automatic updates"
		"Device will no longer auto restart if users are signed in"
		"Turned off re-installation of apps after Windows Updates"
		"Delayed quality updates by 4 days"
		"Delayed feature updates by 20 days"
	)
	ForEach ($WinUpdatePolicy in $WinUpdatePolicies) {
		print "    - $WinUpdatePolicy"
	}

	print "Set up Windows Update policies."
}

# Reset all Windows Update policies
Function ResetWindowsUpdate {
    space
    Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Recurse
    print "All Windows Update policies were reset."
}

# A simple registry edit that fixes an issue where a small batch of devices turn back on after powering down.
Function EnablePowerdownAfterShutdown {
	space
	print "Enabling full powerdown on shut down..."
	print "This is known to fix issues where some PCs might boot up without user input after shutdown."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name PowerdownAfterShutdown -Type DWord -Value 1
	print "Enabled full power down on shut down."
}

# Revert the EnablePowerdownAfterShutdown edit.
Function DisablePowerdownAfterShutdown {
	space
	print "Disabling full powerdown on shut down..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name PowerdownAfterShutdown -Type DWord -Value 0
	print "Disabled full powerdown on shut down."
}



####################################
######### WINDOWS EXPLORER #########
####################################

# Update status: Explorer Changes.
Function PrintExplorerChanges {	
	space
	space
	print "----------------------------------"
	print "          WINDOWS EXPLORER        "
	print "----------------------------------"
	space
}

# Use Print screen button to open screen skipping.
Function EnablePrtScrToSnip {
	space
	print "Binding Print Screen key to launch Snip overlay..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 1
	print "Bound Print Screen key to launch Snip overlay."
	Start-Sleep -Milliseconds 200
}
	
# Don't use Print screen button to open screen skipping.
Function DisablePrtScrSnip {
	space
	print "Unbinding Snip overlay launch from Print screen key...."
	Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "PrintScreenKeyForSnippingEnabled" -Type DWord -Value 0
	print "Unbound Snip overlay launch from Print screen key."
}

# Disable Sticky keys.
Function DisableStickyKeys {
	space
	print "Turning off Sticky keys..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
	print "Turned off Sticky keys."
	Start-Sleep -Milliseconds 200
}

# Enable Sticky keys.
Function EnableStickyKeys {
	space
	print "Turning on Sticky keys..."
	Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
	print "Turned on Sticky keys."
}

# Change default File Explorer view to This PC.
Function SetExplorerThisPC {
	space
	print "Setting default File Explorer view to This PC..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
	print "Set default File Explorer view to This PC."
	Start-Sleep -Milliseconds 200
}

# Change default File Explorer view to Quick Access.
Function SetExplorerQuickAccess {
	space
	print "Setting default File Explorer view to Quick Access..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -ErrorAction SilentlyContinue
	print "Set default File Explorer view to Quick Access."
}

# Hide 3D Objects.
Function Hide3DObjects {
	if ($CurrentBuild -lt 22000) {
		space
		print "Turning off 3D Objects..."
		Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue
		$Hide3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
		$Hide3DObjects2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
		if (!(Test-Path $Hide3DObjects1)) {
			New-Item -Path $Hide3DObjects1 -Force | Out-Null
			}
		Set-ItemProperty -Path $Hide3DObjects1 -Name "ThisPCPolicy" -Type String -Value "Hide"
		if (!(Test-Path $Hide3DObjects2)) {
			New-Item -Path $Hide3DObjects2 -Force | Out-Null
			}
		Set-ItemProperty -Path $Hide3DObjects2 -Name "ThisPCPolicy" -Type String -Value "Hide"
		print "Turned off 3D Objects."
		Start-Sleep -Milliseconds 200
	}
}

# Restore 3D Objects.
Function Restore3DObjects {
	if ($CurrentBuild -lt 22000) {
		space
		print "Turning on 3D Objects..."
		$Restore3DObjects1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
		$Restore3DObjects2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
		$Restore3DObjects3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"
		if (!(Test-Path $Restore3DObjects1)) {
			New-Item -Path $Restore3DObjects1 | Out-Null
		}
		Remove-ItemProperty -Path $Restore3DObjects2 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
		Remove-ItemProperty -Path $Restore3DObjects3 -Name "ThisPCPolicy" -ErrorAction SilentlyContinue
		print "Turned on 3D Objects."
	}
}

# Hide Search bar from taskbar.
Function HideSearchBar {
	if ($CurrentBuild -lt 22000) {
		space
		print "Turning off Search bar..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
		print "Turned off Search bar."
		Start-Sleep -Milliseconds 200
	}
	elseif ($CurrentBuild -ge 22000) {
		space
		print "Turning off Search icon..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
		print "Turned off Search icon."
		Start-Sleep -Milliseconds 200
	}
}

# Restore Search bar to taskbar.
Function RestoreSearchBar {
	if ($CurrentBuild -lt 22000) {
		space
		print "Turning on Search bar..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 2
		print "Turned on Search bar."
		Start-Sleep -Milliseconds 200
	}
	elseif ($CurrentBuild -ge 22000) {
		space
		print "Turning off Search icon..."
		Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 1
		print "Turned off Search icon."
		Start-Sleep -Milliseconds 200
	}
}

# Hide Task View.
Function HideTaskView {
	space
	print "Turning off Task view icon..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
	print "Turned off Task view icon."
	Start-Sleep -Milliseconds 200
}

# Restore Task View button.
Function RestoreTaskView {
	space
	print "Turning on Task view icon..."
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -ErrorAction SilentlyContinue
	print "Turned on Task view icon."
}

# Hide Cortana icon from taskbar.
Function HideCortana {
	if ($CurrentBuild -ge 22000) {
		return
	}
	space
	print "Turning off Cortana icon..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 0
	print "Turned off Cortana icon."
	Start-Sleep -Milliseconds 200
}

# Restore Cortana button in taskbar.
Function RestoreCortana {
	if ($CurrentBuild -ge 22000) {
		return
	}
	print "Turning on Cortana icon..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Type DWord -Value 1
	print "Turned on Cortana icon."
	Start-Sleep -Milliseconds 200
}

# Hide Meet Now icon from tray.
Function HideMeetNow {
	if ($CurrentBuild -ge 22000) {
		return
	}
	space
	print "Turning off Meet now..."
    $Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    $Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 1
    Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 1
	print "Turned off Meet now."
	Start-Sleep -Milliseconds 200
}

# Restore Meet Now icon on tray.
Function RestoreMeetNow {
	if ($CurrentBuild -ge 22000) {
		return
	}
	space
	print "Turning on Meet now..."
    $Meet1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    $Meet2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    Set-ItemProperty -Path $Meet1 -Name "HideSCAMeetNow" -Type DWord -Value 0
    Set-ItemProperty -Path $Meet2 -Name "HideSCAMeetNow" -Type DWord -Value 1
	print "Turned on Meet now."
	Start-Sleep -Milliseconds 200
}

# Turn off News and interests feed.
Function DisableTaskbarFeed {
	if ($CurrentBuild -ge 22000) {
		return
	}
	space
	print "Turning off News and interests..."
	$Feed1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
	$Feed2 = "HKU:\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Feeds"
	Set-ItemProperty -Path $Feed1 -Name ShellFeedsTaskbarViewMode -Type DWord -Value 2 | Out-Null
	Set-ItemProperty -Path $Feed2 -Name ShellFeedsTaskbarViewMode -Type Dword -Value 2 | Out-Null
	print "Turned off News and interests."
	Start-Sleep 2
}

# Turn on News and interests feed.
Function EnableTaskbarFeed {
	if ($CurrentBuild -ge 22000) {
		return
	}
	print "Turning on News and interests..."
	$Feed1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
	$Feed2 = "HKU:\$hkeyuser\Software\Microsoft\Windows\CurrentVersion\Feeds"
	Set-ItemProperty -Path $Feed1 -Name ShellFeedsTaskbarViewMode -Type DWord -Value 0 | Out-Null
	Set-ItemProperty -Path $Feed2 -Name ShellFeedsTaskbarViewMode -Type Dword -Value 0 | Out-Null
	print "Turned on News and interests."
	Start-Sleep 2
}

# Remove created PSDrives
Remove-PSDrive -Name HKCR
Remove-PSDrive -Name HKU
$host.UI.RawUI.WindowTitle = $currenttitle

######### Tasks after successful run #########

# Update status: CleanWin execution successful.
Function Success {
	Stop-Process -Name explorer -Force
	Start-Sleep 3
	print "CleanWin has finished working."
	print "This PC is set to restart in 10 seconds, please close this window if you want to halt the restart."
	print "Thank you for using CleanWin."
	Start-Sleep 10
	Stop-Transcript
	Restart-Computer
}

# Call the desired functions.
$tasks | ForEach-Object { Invoke-Expression $_ }
