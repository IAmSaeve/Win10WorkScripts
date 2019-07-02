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
            1 {
                MenuGreve
                # Pause
            }
            2 {
                Write-Host "WIP"
            }
            3 {
                Clear-Host
                $adapter = (Get-NetAdapter | Select-Object Name, Status | Where-Object { $_.Name -Like "*Ethernet*" -And $_.Status -EQ "Up" }).Name
                if ((Get-NetAdapterBinding -ComponentID ms_tcpip6 -Name $adapter).Enabled) {
                    Write-Host "IPv6 is enabled"
                    Start-Sleep -Seconds 2
                    Start-Process powershell.exe "-NoProfile -Command `
                    Disable-NetAdapterBinding -Name $($adapter) -ComponentID ms_tcpip6; Get-NetAdapterBinding -ComponentID ms_tcpip6; Start-Sleep -Seconds 3" -Verb RunAs
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