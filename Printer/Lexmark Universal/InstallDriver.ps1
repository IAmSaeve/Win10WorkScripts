# Elevate script
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit
}

# Install driver
Write-Host "Installing Lexmark Universal v2 XL driver..."
pnputil.exe /add-driver "$PSScriptRoot\LMUD1p40.inf" /install
Add-PrinterDriver -Name "Lexmark Universal v2 XL"