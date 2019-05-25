# Sebastian Petersen
# sebastian@srmail.dk

# Importing a printer can be done with:
# pnputil.exe /add-driver INFFile.inf /install

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

Function MainMenu {
  Clear-Host
  Do {
      Clear-Host
      Write-Host "`nChoose location"
      Write-Host "**************************`n"
      Write-Host "1.  Greve `n"
      Write-Host "2.  WIP `n"
      Write-Host "3.  WIP `n"
      Write-Host "Q.  Quit `n" -ForegroundColor Yellow
      $Input = Read-Host -Prompt "Please select an option"

      switch ($Input) {
          1 {
              MenuGreve
              Pause
          }
          2 {
              Write-Host "You chose 2"
              Pause
          }
          3 {
              Write-Host "You chose 3"
              Pause
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