# Elevate script
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# Install driver
Write-Host "Installing Canon UFR-II driver..."
pnputil.exe /add-driver "$PSScriptRoot\cnlb0da64.inf" /install
Add-PrinterDriver -Name "Canon IR-ADV C5235/5240 UFR II"
Pause