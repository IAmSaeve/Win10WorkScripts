# Sebastian Petersen
# sebastian@srmail.dk

# Array of apps. Used to remove later
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

# Find default Ethernet adapter
$adapter = ""
if ($null -NE (Get-NetAdapter | Select-Object Name, Status | Where-Object { $_.Name -LIKE "Ethernet*" -AND $_.Status -NE "Not Present" -AND $_.Status -NE "Disabled" }).Name) {
    $adapter = (Get-NetAdapter | Select-Object Name, Status | Where-Object { $_.Name -LIKE "Ethernet*" -AND $_.Status -NE "Not Present" -AND $_.Status -NE "Disabled" }).Name
}
else {
    # This tries to grab the default adapter if the ethernet adapter is not initially found
    $adapter = (Get-NetAdapter | Select-Object Name, InterfaceDescription | Where-Object { $_.Name -LIKE "Ethernet*" -AND $_.InterfaceDescription -NOTLIKE "*Cisco*" })[0].Name
    
    if ($null -EQ $adapter) {
        Write-Host "Failed to find ethernet adapter." -ForegroundColor Red
        Get-NetAdapter
        $adapter = Read-Host -Prompt "Please manually write the adapter name from the list above"
    }
}

# Create path for HKEY_CLASSES_ROOT of it does not exist
if ($null -EQ (Get-PSDrive -PSProvider Registry | Where-Object { $_.Name -EQ "HKCR" })) {
    New-PSDrive -Name "HKCR" -PSProvider Registry -Root "HKEY_CLASSES_ROOT" | Out-Null
}

Function MainMenu {
    Clear-Host
    Do {
        Clear-Host
        Write-Host "**************************`n"
        Write-Host "1.   Set TEST IP '192.168.204.182' (Admin) `n"
        Write-Host "2.   Set IP to automatic `n"
        Write-Host "3.   Disable IPv6 (Admin) `n"
        Write-Host "4.   Configure Internet Settings `n"
        Write-Host "5.   Open domain config `n"
        Write-Host "6.   Open network settings `n"
        Write-Host "7.   Open Computeradministrator `n"
        Write-Host "8.   Show Ethernet config `n"
        Write-Host "9.   Initial prep (As user) `n"
        Write-Host "10.  Remove Edge (Admin) `n"
        Write-Host "11.  Remove OneDrive (Admin) `n"
        Write-Host "12.  Debloat (As user) `n"
        Write-Host "Q.   Quit `n" -ForegroundColor Yellow
        $Input = Read-Host -Prompt "Please select an option"

        switch ($Input) {
            # set IP to 192.168.204.182 and DNS 192.168.204.29
            1 {
                Clear-Host
                Write-Host "Waiting for process to finish..."
                Start-Process -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `
                    netsh int ip set address name='$adapter' static 192.168.204.182 255.255.255.0 192.168.204.12 1; `
                    netsh interface ipv4 add dnsservers '$adapter' address=192.168.204.29 index=1; `
                    netsh interface ipv4 show config name='$adapter'; Pause" -Verb RunAs
            }
            # Set Ethernet settings DHCP and reset DNS settings
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
                        Write-Host "IPv6 is enabled!`n"
                        Start-Sleep -Seconds 2
                        Write-Host "Waiting for process to finish..."
                        Start-Process -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `
                        Disable-NetAdapterBinding -Name '$adapter' -ComponentID ms_tcpip6; Get-NetAdapterBinding -ComponentID ms_tcpip6; Start-Sleep -Seconds 3" -Verb RunAs
                    }
                    elseif ($adapter -IS "System.Array") {
                        Write-Host "Too many adapters were found.`nPlease configure the correct adapter manually."
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
            # Configure Internet Settings
            4 {
                Clear-Host
                $internetSettingsPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
                $TabbedBrowsingPath = "HKCU:\Software\Microsoft\Internet Explorer\TabbedBrowsing"
                $MainPath = "HKCU:\Software\Microsoft\Internet Explorer\Main"

                # Proxy
                New-ItemProperty -Path $internetSettingsPath -PropertyType "DWord" -Name "AutoDetect" -Value 0 –Force
                New-ItemProperty -Path $internetSettingsPath -PropertyType "DWord" -Name "ProxyEnable" -Value 1 –Force
                New-ItemProperty -Path $internetSettingsPath -PropertyType "String" -Name "AutoConfigURL" -Value "https://192.168.204.10/proxy.pac" –Force
                New-ItemProperty -Path $internetSettingsPath -PropertyType "String" -Name "ProxyServer" -Value "10.166.56.10" –Force
                New-ItemProperty -Path $internetSettingsPath -PropertyType "String" -Name "ProxyOverride" -Value "<local>" –Force # This prevents proxy for local addresses

                # New tab open startpage
                New-ItemProperty -Path $TabbedBrowsingPath -PropertyType "DWord" -Name "NewTabPageShow" -Value 1 –Force
                New-ItemProperty -Path $TabbedBrowsingPath -PropertyType "DWord" -Name "OpenAllHomePages" -Value 0 –Force

                # Disable first run pop ups
                New-ItemProperty -Path $MainPath -PropertyType "DWord" -Name "IE10RunOncePerInstallCompleted" -Value 1 –Force
                New-ItemProperty -Path $MainPath -PropertyType "DWord" -Name "IE10TourShown" -Value 1 –Force

                # Set Google as start page
                New-ItemProperty -Path $MainPath -PropertyType "String" -Name "Start Page" -Value "https://www.google.dk/" –Force

            }
            # Open domain config
            5 {
                sysdm.cpl
            }
            # Open network settings
            6 {
                ncpa.cpl
            }
            # Open Computeradministrator
            7 {
                Start-Process CompMgmtLauncher.exe -Verb Runas
            }
            # Show Ethernet config
            8 {
                Clear-Host
                Get-NetIPConfiguration -InterfaceAlias $adapter
                Pause
            }
            # Initial preparations for new user
            9 {
                Clear-Host
                if ($env:USERNAME -NE "MANIT") {
                    foreach ($app in $Apps) {
                        Get-AppxPackage -User "$env:UserDomain\$env:UserName" *$app* | Remove-AppxPackage
                    }

                    New-Item -Path "C:\" -Name "Dokumenter" -ItemType "directory"
                    Copy-Item "C:\Software_DK\Shortcuts\*" -Destination "$env:USERPROFILE\Favorites\Links\" -Recurse
                    Copy-Item "C:\Software_DK\TeamViewerQS_da.exe" "$env:USERPROFILE\Desktop\"
                    Remove-item "$env:USERPROFILE\Favorites\Bing.url" -ErrorAction SilentlyContinue
                    Remove-Item "$env:USERPROFILE\Desktop\Microsoft Edge.lnk" -ErrorAction SilentlyContinue

                    Clear-Host
                    Write-Host "Finished preparing user."
                    Start-Sleep -Seconds 3
                }
                else {
                    Write-Host "Wrong user. Please only run this a standard user(Not MANIT)!" -ForegroundColor Red
                    Pause
                }
            }
            # Remove Edge
            10 {
                $edgePath = "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
                $edgeExists = Test-Path "'$edgePath'\MicrosoftEdge.exe"
                $edgecpExists = Test-Path "'$edgePath'\MicrosoftEdgeCP.exe"
                $edgepdfExists = Test-Path "'$edgePath'\MicrosoftPdfReader.exe"

                Remove-Item "$env:USERPROFILE\Desktop\Microsoft Edge.lnk" -ErrorAction SilentlyContinue

                if ($edgeExists -OR $edgecpExists -OR $edgepdfExists) {
                    Clear-Host
                    
                    Write-Host "Waiting for process to finish..."
                    Start-Process -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `
                        takeown /R /F '$edgePath'\*; `
                        icacls '$edgePath'\* /grant ALLE:F; `
                        Remove-Item '$edgePath'\MicrosoftEdge_remove.exe -ErrorAction SilentlyContinue; `
                        Remove-Item '$edgePath'\MicrosoftEdgeCP_remove.exe -ErrorAction SilentlyContinue; `
                        Remove-Item '$edgePath'\MicrosoftPdfReader_remove.exe -ErrorAction SilentlyContinue; `
                        Rename-Item '$edgePath'\MicrosoftEdge.exe '$edgePath'\MicrosoftEdge_remove.exe -ErrorAction SilentlyContinue; `
                        Rename-Item '$edgePath'\MicrosoftEdgeCP.exe '$edgePath'\MicrosoftEdgeCP_remove.exe -ErrorAction SilentlyContinue; `
                        Rename-Item '$edgePath'\MicrosoftPdfReader.exe '$edgePath'\MicrosoftPdfReader_remove.exe -ErrorAction SilentlyContinue" -Verb RunAs
                    Puase
                }
                else {
                    Clear-Host
                    Write-Host "Edge is already removed!"
                    Pause
                }
            }
            # Remove OneDrive
            11 {
                Clear-Host

                # Runs uninstaller for OneDrive
                Start-Process -Wait "$env:SystemRoot\SYSWOW64\ONEDRIVESETUP.EXE" -ArgumentList "/UNINSTALL"

                # Remove miscellaneous OneDrive paths
                Remove-Item -Path "$env:USERPROFILE\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
                Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -ErrorAction SilentlyContinue
                Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Recurse -ErrorAction SilentlyContinue
                Remove-Item -Path "$env:USERPROFILE\AppData\Local\Microsoft\OneDrive" -Recurse -ErrorAction SilentlyContinue
                Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -ErrorAction SilentlyContinue

                # Check for Windows versoin with "OneDrive pinned" registry keys, and try to unpin from Explorer
                if ((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId -LE "1809") {
                    Write-Host "Addign registry keys to unpin..."
                    if (test-path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}") {
                        New-ItemProperty -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -PropertyType "DWord" -Name "System.IsPinnedToNameSpaceTree" -Value 0 –Force
                    }
                    if (test-path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}") {
                        New-ItemProperty -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -PropertyType "DWord" -Name "System.IsPinnedToNameSpaceTree" -Value 0 –Force
                    }                    
                }

                Write-Host "Finished removing OneDrive."
                Read-Host -Prompt "Press any key to restart explorer."
                Stop-Process -ProcessName explorer
            }
            # Debloat
            12 {
                Clear-Host
                if ($env:USERNAME -NE "MANIT") {
                    foreach ($app in $Apps) {
                        Get-AppxPackage -User "$env:UserDomain\$env:UserName" *$app* | Remove-AppxPackage
                    }

                    Clear-Host
                    Write-Host "Finished removing apps."
                    Start-Sleep -Seconds 3
                }
                else {
                    Write-Host "Wrong user. Please only run this a standard user(Not MANIT)!" -ForegroundColor Red
                    Pause
                }
            }
            Q {
                Exit
            }
            default {
                Write-Host "`nInvalid input!"
                Start-Sleep -Seconds 2
            }
        }
    }
    until ($Input -EQ "q")
}

# Launch The MainMenu
MainMenu