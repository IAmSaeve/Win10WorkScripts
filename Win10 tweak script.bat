
@ECHO off
:: Setting list of apps to remove
set atr=(powershell.exe -NoExit -Command "& {Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.SkypeApp* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.WindowsStore* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.XboxApp* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.WindowsMaps* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.Print3D* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.People* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.Office.OneNote* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.MSPaint* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.Microsoft3DViewer* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.Messaging* | Remove-AppxPackage ; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.GetHelp* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.Getstarted* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.WindowsCamera* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.RemoteDesktop* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *ActiproSoftwareLLC.562882FEEB491* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *46928bounde.EclipseManager* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *AdobeSystemIncorporated.AdobePhotoshop* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *D5EA27B7.Duolingo* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.NetworkSpeedTest* | Remove-AppxPackage; Get-AppxPackage -User "$env:UserDomain\$env:UserName" *Microsoft.BingNews* | Remove-AppxPackage}; exit")

cls


:Start
cls
ECHO.
ECHO  1. Set TEST IP "192.168.204.182" (Admin)
ECHO  2. Set IP to automatic (Admin)
ECHO  3. Disable IPv6 (Admin)
ECHO  4. Initial prep (As user)
ECHO  5. Remove Edge (Admin)
ECHO  6. Open domain config
ECHO  7. Open proxy config
ECHO  8. Open network settings
ECHO  9. Show Ethernet config
ECHO  o. Remove OneDrive (Admin)
ECHO  c. Open Computeradministration (As admin)
ECHO  a. Debloat Windows (As user)
ECHO  e. Exit
ECHO.
set choice=
set /p choice=Please select an option: 

if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto SetTestIp
if '%choice%'=='2' goto SetAutomaticIp
if '%choice%'=='3' goto DisableIPv6
if '%choice%'=='4' goto Init
if '%choice%'=='5' goto RemoveEdge
if '%choice%'=='6' goto ConfigDomain
if '%choice%'=='7' goto ConfigProxy
if '%choice%'=='8' goto NetworkSettings
if '%choice%'=='9' goto ShowEthernetConfig
if '%choice%'=='o' goto RemoveOneDrive
if '%choice%'=='c' goto Compmgmt
if '%choice%'=='a' goto DeBloat
if '%choice%'=='e' goto End
ECHO "%choice%" is not valid, try again
ECHO.
PING localhost -n 2 >NUL

goto Start

:SetTestIp
cls

:: Set IP to 192.168.204.182 and gateway to 192.168.204.12 with 192.168.204.29 as DNS.
:: Only works for the Ethernet network adapter.
powershell.exe -Command "Start-Process powershell.exe -Verb Runas -ArgumentList \"-Command netsh int ip set address name='Ethernet' static 192.168.204.182 255.255.255.0 192.168.204.12 1; netsh interface ipv4 add dnsservers "Ethernet" address=192.168.204.29 index=1; netsh interface ipv4 show config name="Ethernet"; Start-Sleep -s 5; Exit\""
goto Start

:SetAutomaticIp
cls

:: Set IP and DNS to DHCP.
:: Only works for the Ethernet network adapter.
powershell.exe -Command "Start-Process powershell.exe -Verb Runas -ArgumentList \"-Command netsh interface ip set address name='Ethernet' dhcp; netsh interface ip set dns name='Ethernet' dhcp; netsh interface ipv4 show config name='Ethernet'; Start-Sleep -s 5; Exit\""
goto Start

:DisableIPv6
cls

:: Disables IPv6.
:: Only works for the Ethernet network adapter.
powershell.exe -Command "Start-Process powershell.exe -Verb Runas -ArgumentList \"-Command Disable-NetAdapterBinding -Name 'Ethernet' -ComponentID ms_tcpip6; Get-NetAdapterBinding -ComponentID ms_tcpip6; Start-Sleep -s 5; Exit\""
goto Start

:Init
cls
IF %username% NEQ MANIT (
:: atr variable can be found at the top of the script.
%atr%

mkdir C:\Dokumenter\
copy "C:\Software_DK\Shortcuts\*" "%UserProfile%\Favorites\Links\*.*"
copy C:\Software_DK\TeamViewerQS_da.exe %userprofile%\Desktop\TeamViewerQS_da.exe
del %UserProfile%\Favorites\Bing.url

ECHO Done
PING localhost -n 2 >NUL
goto Start
) ELSE (
ECHO Oops! An error occurred!
ECHO The registered user was: %username%.
ECHO.
ECHO This funktion is only available for normal users.
ECHO Are you running as Administrator or are you logged in as admin?
ECHO.
pause
goto End
)


:RemoveEdge
cls
:: TODO: Add statement to kill Edge process if running.
IF EXIST "%userprofile%\Desktop\Microsoft Edge.lnk" (
	del "%userprofile%\Desktop\Microsoft Edge.lnk"
)

Set _edge=0
Set _edgecp=0
Set _pdf=0

IF EXIST C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe (
	Set _edge=1
	)
	
IF EXIST C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdgeCP.exe (
	Set _edgecp=1
	)
	
IF EXIST C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftPdfReader.exe (
	Set _pdf=1
	)

IF %_edge% EQU 1 (
	IF %_edgecp% EQU 1 (
		IF %_pdf% EQU 1 (
			ECHO Detected new install!
			ECHO Removing all Microsoft Edge features.
			PING localhost -n 3 >NUL
			powershell.exe -Command "Start-Process powershell.exe -Verb Runas -ArgumentList \"-Command takeown /R /F C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\*; icacls C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\* /grant ALLE:F; Rename-Item C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge_remove.exe; Rename-Item C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdgeCP.exe C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdgeCP_remove.exe; Rename-Item C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftPdfReader.exe C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftPdfReader_remove.exe\"
			Set _edge=0
			Set _edgecp=0
			Set _pdf=0
			goto Start
		)
	)
)

ECHO One or more files was not found!
ECHO Trying to remove the individual features.
PING localhost -n 3 >NUL

ECHO.
ECHO Looking for MicrosoftEdge.exe
IF %_edge% EQU 1 (
	ECHO MicrosoftEdge.exe found!
	ECHO Removing...
	PING localhost -n 2 >NUL
	powershell.exe -Command "Start-Process powershell.exe -Verb Runas -ArgumentList \"-Command takeown /R /F C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\*; icacls C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\* /grant ALLE:F; del C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge_remove.exe; Rename-Item C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge_remove.exe\"
) ELSE (
ECHO MicrosoftEdge.exe not found!
PING localhost -n 2 >NUL )

ECHO.
ECHO Looking for MicrosoftEdgeCP.exe
IF %_edgecp% EQU 1 (
	ECHO MicrosoftEdgeCP.exe found!
	ECHO Removing...
	PING localhost -n 2 >NUL
	powershell.exe -Command "Start-Process powershell.exe -Verb Runas -ArgumentList \"-Command takeown /R /F C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\*; icacls C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\* /grant ALLE:F; del C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdgeCP_remove.exe; Rename-Item C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdgeCP.exe C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdgeCP_remove.exe\"
) ELSE (
ECHO MicrosoftEdgeCP.exe not found!
PING localhost -n 2 >NUL )

ECHO.
ECHO Looking for MicrosoftPdfReader.exe
IF %_pdf% EQU 1 (
	ECHO MicrosoftPdfReader.exe found!
	ECHO Removing...
	PING localhost -n 2 >NUL
	powershell.exe -Command "Start-Process powershell.exe -Verb Runas -ArgumentList \"-Command takeown /R /F C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\*; icacls C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\* /grant ALLE:F; del C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftPdfReader_remove.exe; Rename-Item C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftPdfReader.exe C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftPdfReader_remove.exe\"
) ELSE (
ECHO MicrosoftPdfReader.exe not found!
PING localhost -n 2 >NUL )

IF %_edge% EQU 0 (
	IF %_edgecp% EQU 0 (
		IF %_pdf% EQU 0 (
			ECHO.
			ECHO No files to remove.
			PING localhost -n 4 >NUL
			goto Start
		)
	)
)
ECHO.
ECHO The removal process is now complete.
ECHO To make sure Edge is disabled try opening Edge from the start menu.
pause
goto Start

:ConfigDomain
cls

:: Opens Properties for the system.
control sysdm.cpl
goto Start

:ConfigProxy
cls

ECHO Copy and paste these into the LAN-Settings
ECHO.
ECHO https://192.168.204.10/proxy.pac
ECHO 10.166.56.10

:: Opens the internetsettings proxy tab.
inetcpl.cpl ,4
pause
goto Start

:NetworkSettings
cls

:: Opens Network settings from controlpanel.
ncpa.cpl
goto Start

:ShowEthernetConfig
cls

:: Flush DNS and shows config for Ethernet.
ipconfig /flushdns
netsh interface ip show config name='Ethernet'
Pause
goto Start

:RemoveOneDrive
cls

echo Uninstalling OneDrive...

:: Run unintaller.
start /wait "" "%SYSTEMROOT%\SYSWOW64\ONEDRIVESETUP.EXE" /UNINSTALL

:: Remove directories and files.
:: Put this behind a command to make it silent: >NUL 2>&1
rd "C:\OneDriveTemp" /Q /S
rd "%USERPROFILE%\OneDrive" /Q /S
rd "%LOCALAPPDATA%\Microsoft\OneDrive" /Q /S
rd "%PROGRAMDATA%\Microsoft OneDrive" /Q /S
rd "%UserProfile%\AppData\Local\Microsoft\OneDrive\" /Q /S
del "%AppData%\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"
powershell.exe -Command "Start-Process powershell.exe -Verb Runas -ArgumentList \"-Command Rename-Item 'C:\Program Files (x86)\Microsoft Office\Office16\GROOVE.exe' 'C:\Program Files (x86)\Microsoft Office\Office16\GROOVE.exe.disabled'; Exit\""
:: del "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OneDrive for Business.lnk"
:: Rename-Item "C:\Program Files (x86)\Microsoft Office\Office16\GROOVE.exe" "C:\Program Files (x86)\Microsoft Office\Office16\GROOVE.exe.disabled"


:: Unpin from Explorer.
reg add "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0
reg add "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0

ECHO.
ECHO Press any key to restart the Windows shell.
pause

:: Restart Windows shell.
start /wait TASKKILL /F /IM explorer.exe
start explorer.exe
goto Start

:Compmgmt
cls

:: Opens Computeradministrator with admin rights.
powershell.exe -Command "Start-Process CompMgmtLauncher.exe -Verb Runas"
goto Start

:DeBloat
cls
IF %username% NEQ MANIT (
:: atr variable can be found at the top of the script.
%atr%

ECHO Done
PING localhost -n 2 >NUL
goto Start
) ELSE (
ECHO Oops! An error occurred!
ECHO The registered user was: %username%.
ECHO.
ECHO This funktion is only available for normal users.
ECHO Are you running as Administrator or are you logged in as admin?
ECHO.
pause
goto End
)
goto Start

:End
exit
::TIMEOUT /T 5