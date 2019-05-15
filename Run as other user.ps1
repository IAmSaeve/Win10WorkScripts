# Sebastian Petersen
# sebastian@srmail.dk

$username = ""
$password = ""
$credentials = New-Object System.Management.Automation.PSCredential -ArgumentList @($username,(ConvertTo-SecureString -String $password -AsPlainText -Force))

Start-Process powershell.exe -Credential ($credentials) -ArgumentList "-Command Start-Process -Wait -filepath 'C:\Path\To\File\ChromeStandaloneSetup64.exe'"