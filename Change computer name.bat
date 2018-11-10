:: TODO: This should be reworked to use UAC promt.

@echo off

:: Gets user input.
set /p name="Enter PC-name: "

:: Variables to shorten 'runas' command line.
set "command=runas /user:%COMPUTERNAME%\MANIT wmic computersystem where caption='%COMPUTERNAME%' rename %name%"
set "msg=echo Please reboot your PC for the chagne to take effect!"

:: Runs the change NETBIOS name command as administrator.
runas /user:%COMPUTERNAME%\MANIT "cmd /C %command% & %msg% & pause"