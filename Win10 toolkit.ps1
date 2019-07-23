# Array of apps. Used to remove later.
$Apps = (
    "Microsoft.SkypeApp",
    "Microsoft.SkypeApp",
    "Microsoft.WindowsStore",
    "Microsoft.XboxApp",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.Print3D",
    "Microsoft.People",
    "Microsoft.Office.OneNote",
    "Microsoft.OneConnect",
    "Microsoft.MSPaint",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.Messaging",
    "Microsoft.GetHelp",
    "Microsoft.BingWeather",
    "Microsoft.Getstarted",
    "Microsoft.WindowsCamera",
    "Microsoft.RemoteDesktop",
    "ActiproSoftwareLLC.562882FEEB491",
    "46928bounde.EclipseManager",
    "AdobeSystemIncorporated.AdobePhotoshop",
    "D5EA27B7.Duolingo",
    "Microsoft.NetworkSpeedTest",
    "Microsoft.BingNews",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxApp"
)

# Find default Ethernet adapter.
$adapter = ""
if ($null -NE (Get-NetAdapter | Select-Object Name, Status | Where-Object { $_.Name -Like "Ethernet*" -And $_.Status -EQ "Up" }).Name) {
    $adapter = (Get-NetAdapter | Select-Object Name, Status | Where-Object { $_.Name -Like "Ethernet*" -And $_.Status -EQ "Up" }).Name
}
else {
    $adapter = (Get-NetAdapter | Select-Object Name | Where-Object { $_.Name -Like "Ethernet*" })[0].Name
    if ($null -EQ $adapter) {
        Write-Host "Failed to find ethernet adapter." -ForegroundColor Red
        Get-NetAdapter
        $adapter = Read-Host -Prompt "Please manually write the adapter name from the list above"
    }
}


Function MainMenu {
    Clear-Host
    Do {
        Clear-Host
        Write-Host "**************************`n"
        Write-Host "1.  Set TEST IP '192.168.204.182' (Admin) `n"
        Write-Host "2.  Set IP to automatic `n"
        Write-Host "3.  Disable IPv6 (Admin) `n"
        Write-Host "4.  Change proxy config (WIP) `n"
        Write-Host "5.  Open domain config `n"
        Write-Host "6.  Open network settings `n"
        Write-Host "7.  Show Ethernet config `n"
        Write-Host "8.  Initial prep (As user) `n"
        Write-Host "9.  Remove Edge (Admin) `n"
        Write-Host "10.  Remove OneDrive (Admin) `n"
        Write-Host "Q.  Quit `n" -ForegroundColor Yellow
        $Input = Read-Host -Prompt "Please select an option"

        switch ($Input) {
            # Clear ethernet settings, if any exists, then,
            # set IP to 192.168.204.182 and DNS 192.168.204.29.
            1 {
                Clear-Host
                if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
                    Write-Host "Waiting for process to finish"
                    Start-Process -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `
                    Remove-NetIPAddress -InterfaceAlias $($adapter) -Confirm:0; `
                    Remove-NetRoute -InterfaceAlias $($adapter) -DestinationPrefix '0.0.0.0/0' -Confirm:0; `
                    New-NetIPAddress –InterfaceAlias $($adapter) –IPAddress '192.168.204.144' –PrefixLength 24 -DefaultGateway '192.168.204.12'; `
                    Get-DnsClient -InterfaceAlias $($adapter) | Set-DnsClientServerAddress -ServerAddresses ('192.168.204.29'); Pause" -Verb RunAs
                }
            }
            # Set Ethernet settings DHCP and reset DNS settings.
            2 {
                Clear-Host
                if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
                    Write-Host "Waiting for process to finish"
                    Start-Process -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `
                    Set-NetIPInterface -InterfaceAlias $($adapter) -Dhcp Enabled; `
                    Get-NetIPAddress -InterfaceAlias $($adapter) | Remove-NetRoute -Confirm:0; `
                    Set-DnsClientServerAddress -InterfaceAlias $($adapter) -ResetServerAddresses -Confirm:0; pause" -Verb RunAs
                }
            }
            # Disabled IPv6
            3 {
                Clear-Host
                if ((Get-NetAdapterBinding -ComponentID ms_tcpip6 -Name $adapter).Enabled -And $adapter -is "System.String") {
                    Write-Host "IPv6 is enabled"
                    Start-Sleep -Seconds 2
                    Start-Process -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `
                    Disable-NetAdapterBinding -Name $($adapter) -ComponentID ms_tcpip6; Get-NetAdapterBinding -ComponentID ms_tcpip6; Start-Sleep -Seconds 3" -Verb RunAs
                }
                elseif ($adapter -is "System.Array") {
                    Write-Host "Too many adapters were found.`nPlease manually select the correct adapter"
                    timeout.exe 5
                    Start-Process ncpa.cpl
                }
                else {
                    Read-Host -Prompt "IPv6 is disabled on this system.`nPress any key to continue..."
                }
            }
            # Change proxy config (WIP)
            4 {
                # TODO: Change reg-keys to do this automatically
                Clear-Host
                Write-Host "`nCopy and paste these into the LAN-Settings"
                Write-Host "https://192.168.204.10/proxy.pac`n10.166.56.10"
                inetcpl.cpl
            }
            # Open domain config
            5 {
                sysdm.cpl
            }
            # Open network settings
            6 {
                ncpa.cpl
            }
            # Show Ethernet config
            7 {
                Clear-Host
                Get-NetIPConfiguration -InterfaceAlias $adapter
                Pause
            }
            # Initial preparations for new user
            8 {
                Clear-Host
                if ($env:USERNAME -NE "MANIT") {
                    foreach ($app in $Apps) {
                        Get-AppxPackage -User "$env:UserDomain\$env:UserName" *$app* | Remove-AppxPackage
                    }

                    New-Item -Path "C:\" -Name "Dokumenter" -ItemType "directory"
                    Copy-Item "C:\Software_DK\Shortcuts\*" -Destination "$env:USERPROFILE\Favorites\Links\" -Recurse
                    Copy-Item "C:\Software_DK\TeamViewerQS_da.exe" "$env:USERPROFILE\Desktop\"
                    Remove-item "$env:USERPROFILE\Favorites\Bing.url" -ErrorAction SilentlyContinue
                    Write-Host "Done preparing user."
                    Start-Sleep -Seconds 3
                }
                else {
                    Write-Host "Wrong user. Please only run this a standard user(Not MANIT)" -ForegroundColor Red
                }
            }
            # Remove Edge
            9 {
                $edgePath = "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
                $edgeExists = Test-Path "$edgePath\MicrosoftEdge.exe"
                $edgecpExists = Test-Path "$edgePath\MicrosoftEdgeCP.exe"
                $edgepdfExists = Test-Path "$edgePath\MicrosoftPdfReader.exe"
                Remove-Item "$env:USERPROFILE\Desktop\Microsoft Edge.lnk" -ErrorAction SilentlyContinue

                if ($edgeExists -or $edgecpExists -or $edgepdfExists) {
                    Clear-Host
                    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
                        Write-Host "Waiting for process to finish"
                        Start-Process -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `
                        takeown /R /F $($edgePath)\*; `
                        icacls $($edgePath)\* /grant ALLE:F; `
                        Remove-Item $($edgePath)\MicrosoftEdge_remove.exe -ErrorAction SilentlyContinue; `
                        Remove-Item $($edgePath)\MicrosoftEdgeCP_remove.exe -ErrorAction SilentlyContinue; `
                        Remove-Item $($edgePath)\MicrosoftPdfReader_remove.exe -ErrorAction SilentlyContinue; `
                        Rename-Item $($edgePath)\MicrosoftEdge.exe $($edgePath)\MicrosoftEdge_remove.exe -ErrorAction SilentlyContinue; `
                        Rename-Item $($edgePath)\MicrosoftEdgeCP.exe $($edgePath)\MicrosoftEdgeCP_remove.exe -ErrorAction SilentlyContinue; `
                        Rename-Item $($edgePath)\MicrosoftPdfReader.exe $($edgePath)\MicrosoftPdfReader_remove.exe -ErrorAction SilentlyContinue" -Verb RunAs
                    }
                }
                else {
                    Write-Host "Edge is already removed"
                }
            }
            # Remove OneDrive
            10 {
                Clear-Host
                Start-Process -Wait "$env:SystemRoot\SYSWOW64\ONEDRIVESETUP.EXE" -ArgumentList "/UNINSTALL"

                Remove-Item -Path "$env:USERPROFILE\OneDrive" -Recurse -ErrorAction SilentlyContinue # TODO: Fix no permission. Maybe with -Force
                Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -ErrorAction SilentlyContinue
                Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Recurse -ErrorAction SilentlyContinue
                Remove-Item -Path "$env:USERPROFILE\AppData\Local\Microsoft\OneDrive" -Recurse -ErrorAction SilentlyContinue
                Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -ErrorAction SilentlyContinue

                if ((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId -le "1809") {
                    Write-Host "Addign registry keys to unpin..."
                    reg add "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0
                    reg add "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0
                }


                Read-Host -Prompt "Press any key to restart explorer"
                Stop-Process -ProcessName explorer
            }
            Q {
                Exit
            }
            default {
                Write-Host "`nInvalid input"
                Start-Sleep -Seconds 2
            }
        }
    }
    until ($Input -eq "q")
}

# Launch The MainMenu
MainMenu