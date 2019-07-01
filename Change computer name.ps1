# Sebastian Petersen
# sebastian@srmail.dk

# Elevate shell.
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit
}

# Gets user input.
Clear-Host
$name = Read-Host -Prompt "`Enter the new PC-name: "

# Change NETBIOS/PC name
Rename-Computer -NewName $name
Pause