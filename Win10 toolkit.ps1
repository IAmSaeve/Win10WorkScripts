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
if ($null -NE (Get-NetAdapter | Select-Object Name, Status | Where-Object { $_.Name -LIKE "Ethernet*" -AND $_.Status -NE "Not Present" -AND $_.Status -NE "Disabled" }).Name) {
    $adapter = (Get-NetAdapter | Select-Object Name, Status | Where-Object { $_.Name -LIKE "Ethernet*" -AND $_.Status -NE "Not Present" -AND $_.Status -NE "Disabled" }).Name
}
else {
    $adapter = (Get-NetAdapter | Select-Object Name, InterfaceDescription | Where-Object { $_.Name -LIKE "Ethernet*" -AND $_.InterfaceDescription -NOTLIKE "*Cisco*" })[0].Name
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
        Write-Host "1.   Set TEST IP '192.168.204.182' (Admin) `n"
        Write-Host "2.   Set IP to automatic `n"
        Write-Host "3.   Disable IPv6 (Admin) `n"
        Write-Host "4.   Change proxy config `n"
        Write-Host "5.   Open domain config `n"
        Write-Host "6.   Open network settings `n"
        Write-Host "7.   Show Ethernet config `n"
        Write-Host "8.   Initial prep (As user) `n"
        Write-Host "9.   Remove Edge (Admin) `n"
        Write-Host "10.  Remove OneDrive (Admin) `n"
        Write-Host "Q.   Quit `n" -ForegroundColor Yellow
        $Input = Read-Host -Prompt "Please select an option"

        switch ($Input) {
            # set IP to 192.168.204.182 and DNS 192.168.204.29.
            1 {
                Clear-Host
                Write-Host "Waiting for process to finish..."
                Start-Process -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `
                    netsh int ip set address name='$adapter' static 192.168.204.182 255.255.255.0 192.168.204.12 1; `
                    netsh interface ipv4 add dnsservers '$adapter' address=192.168.204.29 index=1; `
                    netsh interface ipv4 show config name='$adapter'; Pause" -Verb RunAs
            }
            # Set Ethernet settings DHCP and reset DNS settings.
            2 {
                Clear-Host
                Write-Host "Waiting for process to finish..."
                Start-Process -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `
                    netsh interface ip set address name='$adapter' dhcp; `
                    netsh interface ip set dns name='$adapter' dhcp;`
                    netsh interface ipv4 show config name='$adapter'; Pause" -Verb RunAs
            }
            # Disabled IPv6
            3 {
                try {
                    Clear-Host
                    if ((Get-NetAdapterBinding -ComponentID ms_tcpip6 -Name $adapter -ErrorAction Stop).Enabled -AND $adapter -IS "System.String") {
                        Write-Host "IPv6 is enabled"
                        Start-Sleep -Seconds 2
                        Start-Process -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `
                        Disable-NetAdapterBinding -Name '$adapter' -ComponentID ms_tcpip6; Get-NetAdapterBinding -ComponentID ms_tcpip6; Start-Sleep -Seconds 3" -Verb RunAs
                    }
                    elseif ($adapter -IS "System.Array") {
                        Write-Host "Too many adapters were found.`nPlease manually select the correct adapter"
                        timeout.exe 5
                        Start-Process ncpa.cpl
                    }
                    else {
                        Read-Host -Prompt "IPv6 is disabled on this system.`nPress any key to continue..."
                    }
                }
                catch {
                    Write-Host "Caught error when selecting adapter."
                    Write-Host "Please disable IPv6 manually."
                    Pause
                }
                
            }
            # Change proxy config
            4 {
                Clear-Host
                $internetSettingsPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
                New-ItemProperty -Path $internetSettingsPath -PropertyType "DWord" -Name "AutoDetect" -Value 0 –Force
                New-ItemProperty -Path $internetSettingsPath -PropertyType "DWord" -Name "ProxyEnable" -Value 1 –Force
                New-ItemProperty -Path $internetSettingsPath -PropertyType "String" -Name "AutoConfigURL" -Value "https://192.168.204.10/proxy.pac" –Force
                New-ItemProperty -Path $internetSettingsPath -PropertyType "String" -Name "ProxyServer" -Value "10.166.56.10" –Force
                New-ItemProperty -Path $internetSettingsPath -PropertyType "String" -Name "ProxyOverride" -Value "<local>" –Force # This prevents proxy for local addresses
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
                $edgeExists = Test-Path "'$edgePath'\MicrosoftEdge.exe"
                $edgecpExists = Test-Path "'$edgePath'\MicrosoftEdgeCP.exe"
                $edgepdfExists = Test-Path "'$edgePath'\MicrosoftPdfReader.exe"
                Remove-Item "$env:USERPROFILE\Desktop\Microsoft Edge.lnk" -ErrorAction SilentlyContinue

                if ($edgeExists -OR $edgecpExists -OR $edgepdfExists) {
                    Clear-Host
                    
                    Write-Host "Waiting for process to finish"
                    Start-Process -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `
                        takeown /R /F '$edgePath'\*; `
                        icacls '$edgePath'\* /grant ALLE:F; `
                        Remove-Item '$edgePath'\MicrosoftEdge_remove.exe -ErrorAction SilentlyContinue; `
                        Remove-Item '$edgePath'\MicrosoftEdgeCP_remove.exe -ErrorAction SilentlyContinue; `
                        Remove-Item '$edgePath'\MicrosoftPdfReader_remove.exe -ErrorAction SilentlyContinue; `
                        Rename-Item '$edgePath'\MicrosoftEdge.exe '$edgePath'\MicrosoftEdge_remove.exe -ErrorAction SilentlyContinue; `
                        Rename-Item '$edgePath'\MicrosoftEdgeCP.exe '$edgePath'\MicrosoftEdgeCP_remove.exe -ErrorAction SilentlyContinue; `
                        Rename-Item '$edgePath'\MicrosoftPdfReader.exe '$edgePath'\MicrosoftPdfReader_remove.exe -ErrorAction SilentlyContinue" -Verb RunAs
                    
                }
                else {
                    Write-Host "Edge is already removed"
                }
            }
            # Remove OneDrive
            10 {
                Clear-Host
                Start-Process -Wait "$env:SystemRoot\SYSWOW64\ONEDRIVESETUP.EXE" -ArgumentList "/UNINSTALL"

                Remove-Item -Path "$env:USERPROFILE\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
                Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -ErrorAction SilentlyContinue
                Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Recurse -ErrorAction SilentlyContinue
                Remove-Item -Path "$env:USERPROFILE\AppData\Local\Microsoft\OneDrive" -Recurse -ErrorAction SilentlyContinue
                Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -ErrorAction SilentlyContinue

                if ((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId -LE "1809") {
                    Write-Host "Addign registry keys to unpin..."
                    New-ItemProperty -Path "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -PropertyType "DWord" -Name "System.IsPinnedToNameSpaceTree" -Value 0 –Force
                    New-ItemProperty -Path "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -PropertyType "DWord" -Name "System.IsPinnedToNameSpaceTree" -Value 0 –Force
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
    until ($Input -EQ "q")
}

# Launch The MainMenu
MainMenu