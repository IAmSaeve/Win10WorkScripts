# Sebastian Petersen
# sebastian@srmail.dk
 

$username = ""
$password = ""


$credentials = New-Object System.Management.Automation.PSCredential -ArgumentList `
               @($username,(ConvertTo-SecureString -String $password -AsPlainText -Force))


# Audio alerts can be added to the command string with the following line
# [console]::beep(900,300); [console]::beep(900,300); [console]::beep(900,300);

$commandString = "-Command `
                  Write-Host -ForegroundColor Yellow -BackgroundColor Black '`
                  Attention! Citrix is downloading, do NOT close this window!!! `
                  The window will close automatically when the install process is done.'; `
                  Start-Process -Wait -filepath '\\192.168.204.28\sym_update\Citrixupd\CitrixReceiver.exe'"


Start-Process powershell.exe -Credential ($credentials) -ArgumentList $commandString