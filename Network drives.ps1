# Sebastian Petersen
# sebastian@srmail.dk

Function MainMenu {
    Clear-Host
    Do {
        Clear-Host
        Write-Host "`nChoose drive to add"
        Write-Host "**************************`n"
        Write-Host "1.  Trucksales (X)`n"
        Write-Host "2.  servicedk (G)`n"
        Write-Host "3.  produkt (H)`n"
        Write-Host "4.  Trucksales på mandknt (X)`n"
        Write-Host "5.  Fælles (F)`n"
        Write-Host "6.  Personlig (P)`n"
        Write-Host "Q.  Quit `n" -ForegroundColor Yellow
        $Input = Read-Host -Prompt "Please select an option"
        Write-Host $Input

        switch ($Input) {
            1 {
                New-PSDrive -Name "Trucksales" -Root "\\192.168.204.28\Trucksales" -Persist -PSProvider "FileSystem"
                Start-Sleep -Seconds 2
                MainMenu
            }
            2 {
                New-PSDrive -Name "servicedk" -Root "\\192.168.204.28\servicedk" -Persist -PSProvider "FileSystem"
                Start-Sleep -Seconds 2
                MainMenu
            }
            3 {
                New-PSDrive -Name "produkt" -Root "\\192.168.204.28\produkt" -Persist -PSProvider "FileSystem"
                Start-Sleep -Seconds 2
                MainMenu
            }
            4 {
                # TODO: Check if this is correct server address
                New-PSDrive -Name "Trucksales" -Root "\\mandknt\Trucksales" -Persist -PSProvider "FileSystem"
                Start-Sleep -Seconds 2
                MainMenu
            }
            5 {
                New-PSDrive -Name "Fælles" -Root "\\192.168.204.28\Fælles" -Persist -PSProvider "FileSystem"
                Start-Sleep -Seconds 2
                MainMenu
            }
            6 {
                Clear-Host
                Write-Host "You have to manually add this drive."
                Read-Host "Press any key to open network folder..."
                Invoke-Item "\\192.168.204.28\"
                MainMenu
            }
            Q {
                Exit
            }
            default {
                Write-Host "`nInvalid input"
                Start-Sleep -Seconds 3
            }
        }
    }
    until ($Input -EQ "q")
}

# Launch The MainMenu
MainMenu