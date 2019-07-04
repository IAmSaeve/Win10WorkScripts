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
        Write-Host "4.  Fælles på mandknt (X)`n"
        Write-Host "5.  Fælles (F)`n"
        Write-Host "6.  Personlig (P)`n"
        Write-Host "7.  partsdk (T)`n"
        Write-Host "8.  busonew (Z)`n"
        Write-Host "9.  topused (H)`n"
        Write-Host "10.  orderoffice (O)`n"
        Write-Host "Q.  Quit `n" -ForegroundColor Yellow
        $Input = Read-Host -Prompt "Please select an option"
        Write-Host $Input

        switch ($Input) {
            1 {
                New-PSDrive -Name "Trucksales" -Root "\\192.168.204.28\Trucksales" -Persist -PSProvider "FileSystem"
                Start-Sleep -Seconds 2
            }
            2 {
                New-PSDrive -Name "servicedk" -Root "\\192.168.204.28\servicedk" -Persist -PSProvider "FileSystem"
                Start-Sleep -Seconds 2
            }
            3 {
                New-PSDrive -Name "produkt" -Root "\\192.168.204.28\produkt" -Persist -PSProvider "FileSystem"
                Start-Sleep -Seconds 2
            }
            4 {
                New-PSDrive -Name "Fælles" -Root "\\mandknt\Fælles" -Persist -PSProvider "FileSystem"
                Start-Sleep -Seconds 2
            }
            5 {
                New-PSDrive -Name "Fælles" -Root "\\192.168.204.28\Fælles" -Persist -PSProvider "FileSystem"
                Start-Sleep -Seconds 2
            }
            6 {
                Clear-Host
                Write-Host "You have to manually add this drive."
                Read-Host "Press any key to open network folder..."
                Invoke-Item "\\192.168.204.28\"
            }
            7 {
                New-PSDrive -Name "Partsdk" -Root "\\192.168.204.28\Partsdk" -Persist -PSProvider "FileSystem"
                Start-Sleep -Seconds 2
            }
            8 {
                New-PSDrive -Name "Busonew" -Root "\\192.168.204.28\Busonew" -Persist -PSProvider "FileSystem"
                Start-Sleep -Seconds 2
            }
            9 {
                New-PSDrive -Name "Topused" -Root "\\192.168.204.28\Topused" -Persist -PSProvider "FileSystem"
                Start-Sleep -Seconds 2
            }
            10 {
                New-PSDrive -Name "Orderoffice" -Root "\\192.168.204.28\Orderoffice" -Persist -PSProvider "FileSystem"
                Start-Sleep -Seconds 2
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