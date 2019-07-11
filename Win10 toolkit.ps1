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
    "Microsoft.MSPaint",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.Messaging",
    "Microsoft.GetHelp",
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

$adapter = (Get-NetAdapter | Select-Object Name, Status | Where-Object { $_.Name -Like "Ethernet*" -And $_.Status -EQ "Up" }).Name


Function MainMenu {
    Clear-Host
    Do {
        Clear-Host
        Write-Host "**************************`n"
        Write-Host "1.  Set TEST IP '192.168.204.182' (Admin) `n"
        Write-Host "2.  Set IP to automatic `n"
        Write-Host "3.  Disable IPv6 (Admin) `n"
        Write-Host "4.  Initial prep (As user) `n"
        Write-Host "Q.  Quit `n" -ForegroundColor Yellow
        $Input = Read-Host -Prompt "Please select an option"

        switch ($Input) {
            # Clear ethernet settings, if any exists, then,
            # set IP to 192.168.204.182 and DNS 192.168.204.29.
            1 {
                if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
                    Write-Host "Waiting for process to finish"
                    Start-Process -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `
                    Remove-NetIPAddress -InterfaceAlias $($adapter) -Confirm:0; `
                    Remove-NetRoute -InterfaceAlias $($adapter) -DestinationPrefix '0.0.0.0/0' -Confirm:0 `
                    New-NetIPAddress –InterfaceAlias $($adapter) –IPAddress '192.168.204.144' –PrefixLength 24 -DefaultGateway '192.168.204.12'; `
                    Get-DnsClient -InterfaceAlias $($adapter) | Set-DnsClientServerAddress -ServerAddresses ('192.168.204.29'); pause" -Verb RunAs
                }
            }
            # Set Ethernet settings DHCP and reset DNS settings.
            2 {
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
                } elseif ($adapter -is "System.Array") {
                    Write-Host "Too many adapters were found.`nPlease manually select the correct adapter"
                    timeout.exe 5
                    Start-Process ncpa.cpl
                } else {
                    Read-Host -Prompt "IPv6 is disabled on this system.`nPress any key to continue..."
                }
            }
            4 {
                # foreach ($app in $Apps) {
                #     Get-AppxPackage -User "$env:UserDomain\$env:UserName" *$app* | Remove-AppxPackage
                # }
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