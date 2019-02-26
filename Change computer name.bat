:: Sebastian Petersen
:: sebastian@srmail.dk

@ECHO OFF
CHCP 65001
CLS

:: Gets user input.
SET /p name="Enter PC-name: "

:: Variable to shorten command line.
SET "command=Rename-Computer -NewName '%name%' -PassThru; pause"

:: Runs the change NETBIOS name command as administrator.
powershell.exe -Command "Start-Process powershell.exe -Verb Runas -ArgumentList \"-Command %command%\""