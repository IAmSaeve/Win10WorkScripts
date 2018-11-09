@echo off
set /p name="Enter PC-name: "
set "command=runas /user:%computername%\MANIT wmic computersystem where caption='%COMPUTERNAME%' rename %name%"
set "msg=echo Please reboot your PC for the chagne to take effect!"
runas /user:%computername%\MANIT "cmd /C %command% & %msg% & pause"