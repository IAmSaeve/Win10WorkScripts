# Sebastian Petersen
# sebastian@srmail.dk

# Check for, and install missing drivers
Write-Host "`nChecking for missing drivers"
$canonDriver = Get-PrinterDriver | Select-Object Name | Where-Object { $_.Name -EQ "Canon iR-ADV C5235/5240 UFR II" }
$lexmarkDriver = Get-PrinterDriver | Select-Object Name | Where-Object { $_.Name -EQ "Lexmark Universal v2 XL" }
if ($canonDriver.Name -NE "Canon iR-ADV C5235/5240 UFR II") {
  Write-Host "Canon driver not found"
  $I = Read-Host -Prompt "Do you want to install the Canon drivers? [y/n]"
  if ($I.ToUpper() -EQ "Y") {
    Start-Process -Wait Powershell.exe -ArgumentList "-File `"$PSScriptRoot.\Canon UFR-II\InstallDriver.ps1`""
  } else {
    Write-Host "Skipping`n";
  }
}
else {
  Write-Host "Canon driver: OK!"
}

if ($lexmarkDriver.Name -NE "Lexmark Universal v2 XL") {
  Write-Host "Lexmark driver not found"
  $I = Read-Host -Prompt "Do you want to install the Lexmark drivers? [y/n]"
  if ($I.ToUpper() -EQ "Y") {
    Start-Process -Wait Powershell.exe -ArgumentList "-File `"$PSScriptRoot.\Lexmark Universal\InstallDriver.ps1`""
  } else {
    Write-Host "Skipping`n";
  }
}
else {
  Write-Host "Lexmark driver: OK!"
}
Start-Sleep -Seconds 2

Function MenuGreve {
    Clear-Host
    Do {
        Clear-Host
        Write-Host "`nChoose a printer"
        Write-Host "**************************`n"
        Write-Host "1.  Canon 1. sal `n"
        Write-Host "2.  Canon 2. sal `n"
        Write-Host "3.  Canon Lager `n"
        Write-Host "4.  Canon Busafd. `n"
        Write-Host "5.  Lexmark Lager `n"
        Write-Host "6.  Lexmark kreditorbogholderiet `n"
        Write-Host "B.  Back to main menu `n" -ForegroundColor Green
        Write-Host "Q.  Quit `n" -ForegroundColor Yellow
        $Input = Read-Host -Prompt "Please select an option"

        switch ($Input) {
            1 {
                $IP = "192.168.204.177"
                Add-PrinterPort -Name "IP_$IP" -PrinterHostAddress $IP
                Add-Printer -DriverName "Canon iR-ADV C5235/5240 UFR II" -Name "Canon 1. sal" -PortName "IP_$IP"
                Write-Host "Canon 1. sal - Printer has been added"
                Start-Sleep -Seconds 2
            }
            2 {
                $IP = "192.168.204.43"
                Add-PrinterPort -Name "IP_$IP" -PrinterHostAddress $IP
                Add-Printer -DriverName "Canon iR-ADV C5235/5240 UFR II" -Name "Canon 2. sal" -PortName "IP_$IP"
                Write-Host "Canon 2. sal - Printer has been added"
                Start-Sleep -Seconds 2
            }
            3 {
                $IP = "192.168.204.247"
                Add-PrinterPort -Name "IP_$IP" -PrinterHostAddress $IP
                Add-Printer -DriverName "Canon iR-ADV C5235/5240 UFR II" -Name "Canon Mellemgang" -PortName "IP_$IP"
                Write-Host "Canon Lager - Printer has been added"
                Start-Sleep -Seconds 2
            }
            4 {
                $IP = "192.168.204.40"
                Add-PrinterPort -Name "IP_$IP" -PrinterHostAddress $IP
                Add-Printer -DriverName "Canon iR-ADV C5235/5240 UFR II" -Name "Canon Busafd." -PortName "IP_$IP"
                Write-Host "Canon Busafd. - Printer has been added"
                Start-Sleep -Seconds 2
            }
            5 {
                $IP = "192.168.204.189"
                Add-PrinterPort -Name "IP_$IP" -PrinterHostAddress $IP
                Add-Printer -DriverName "Lexmark Universal v2 XL" -Name "Lexmark Lager" -PortName "IP_$IP"
                Write-Host "Lexmark Lager - Printer has been added"
                Start-Sleep -Seconds 2
            }
            6 {
                $IP = "192.168.204.107"
                Add-PrinterPort -Name "IP_$IP" -PrinterHostAddress $IP
                Add-Printer -DriverName "Lexmark Universal v2 XL" -Name "Lexmark kreditorbogholderiet" -PortName "IP_$IP"
                Write-Host "Lexmark Lager - Printer has been added"
                Start-Sleep -Seconds 2
            }
            B {
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
    until ($Input -eq "b" -or $Input -eq "q")
}


Function MenuPadborg {
    Clear-Host
    Do {
        Clear-Host
        Write-Host "`nChoose a printer"
        Write-Host "**************************`n"
        Write-Host "1.  Canon topused `n"
        Write-Host "2.  Canon workshop `n"
        Write-Host "3.  Lexmark indskrivning `n"
        Write-Host "4.  Lexmark lager `n"
        Write-Host "B.  Back to main menu `n" -ForegroundColor Green
        Write-Host "Q.  Quit `n" -ForegroundColor Yellow
        $Input = Read-Host -Prompt "Please select an option"
  
        switch ($Input) {
            1 {
                $IP = "192.168.110.178"
                Add-PrinterPort -Name "IP_$IP" -PrinterHostAddress $IP
                Add-Printer -DriverName "Canon iR-ADV C5235/5240 UFR II" -Name "Canon topused" -PortName "IP_$IP"
                Write-Host "Canon topused - Printer has been added"
                Start-Sleep -Seconds 2
            }
            2 {
                $IP = "192.168.110.176"
                Add-PrinterPort -Name "IP_$IP" -PrinterHostAddress $IP
                Add-Printer -DriverName "Canon iR-ADV C5235/5240 UFR II" -Name "Canon Workshop" -PortName "IP_$IP"
                Write-Host "Canon workshop - Printer has been added"
                Start-Sleep -Seconds 2
            }
            3 {
                $IP = "192.168.110.175"
                Add-PrinterPort -Name "IP_$IP" -PrinterHostAddress $IP
                Add-Printer -DriverName "Lexmark Universal v2 XL" -Name "Lexmark indskrivning" -PortName "IP_$IP"
                Write-Host "Lexmark indskrivning - Printer has been added"
                Start-Sleep -Seconds 2
            }
            4 {
                $IP = "192.168.110.177"
                Add-PrinterPort -Name "IP_$IP" -PrinterHostAddress $IP
                Add-Printer -DriverName "Lexmark Universal v2 XL" -Name "Lexmark lager" -PortName "IP_$IP"
                Write-Host "Lexmark lager - Printer has been added"
                Start-Sleep -Seconds 2
            }
            B {
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
    until ($Input -eq "b" -or $Input -eq "q")
}

Function MenuKolding {
    Clear-Host
    Do {
        Clear-Host
        Write-Host "`nChoose a printer"
        Write-Host "**************************`n"
        Write-Host "1.  Lexmark teknikrum `n"
        Write-Host "2.  Lexmark Workshop - MNKDG001 `n"
        Write-Host "3.  Lexmark Workshop - MNKDG002 `n"
        Write-Host "4.  Lexmark parts - MNKDG003 `n"
        Write-Host "B.  Back to main menu `n" -ForegroundColor Green
        Write-Host "Q.  Quit `n" -ForegroundColor Yellow
        $Input = Read-Host -Prompt "Please select an option"

        switch ($Input) {
            1 {
                $IP = "192.168.112.178"
                Add-PrinterPort -Name "IP_$IP" -PrinterHostAddress $IP
                Add-Printer -DriverName "Lexmark Universal v2 XL" -Name "Lexmark teknikrum" -PortName "IP_$IP"
                Write-Host "Lexmark teknikrum - Printer has been added"
                Start-Sleep -Seconds 2
            }
            2 {
                $IP = "192.168.112.175"
                Add-PrinterPort -Name "IP_$IP" -PrinterHostAddress $IP
                Add-Printer -DriverName "Lexmark Universal v2 XL" -Name "Lexmark Workshop" -PortName "IP_$IP"
                Write-Host "Lexmark Workshop, MNKDG001 - Printer has been added"
                Start-Sleep -Seconds 2
            }
            3 {
                $IP = "192.168.112.176"
                Add-PrinterPort -Name "IP_$IP" -PrinterHostAddress $IP
                Add-Printer -DriverName "Lexmark Universal v2 XL" -Name "Lexmark Workshop" -PortName "IP_$IP"
                Write-Host "Lexmark Workshop, MNKDG002 - Printer has been added"
                Start-Sleep -Seconds 2
            }
            4 {
                $IP = "192.168.112.177"
                Add-PrinterPort -Name "IP_$IP" -PrinterHostAddress $IP
                Add-Printer -DriverName "Lexmark Universal v2 XL" -Name "Lexmark parts" -PortName "IP_$IP"
                Write-Host "Lexmark parts - MNKDG003 - Printer has been added"
                Start-Sleep -Seconds 2
            }
            B {
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
    until ($Input -eq "b" -or $Input -eq "q")
}

Function MainMenu {
    Clear-Host
    Do {
        Clear-Host
        Write-Host "`nChoose location"
        Write-Host "**************************`n"
        Write-Host "1.  Greve `n"
        Write-Host "2.  Padborg `n"
        Write-Host "3.  Kolding `n"
        Write-Host "Q.  Quit `n" -ForegroundColor Yellow
        $Input = Read-Host -Prompt "Please select an option"

        switch ($Input) {
            1 {
                MenuGreve
                # Pause
            }
            2 {
                MenuPadborg
                # Pause
            }
            3 {
                MenuKolding
                # Pause
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
    until ($Input -eq "q")
}

# Launch The MainMenu
MainMenu