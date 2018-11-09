@ECHO off
cls

:Start
cls
ECHO.
ECHO  1. DRIVE 1
ECHO  2. DRIVE 2
ECHO  3. DRIVE 3
ECHO  4. DRIVE 4
ECHO  5. DRIVE 5
ECHO  6. DRIVE 6
ECHO  7. DRIVE 7
ECHO  8. DRIVE 8
ECHO  9. DRIVE 9
ECHO.
set choice=
set /p choice=Please select an option: 

if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto DRIVE 1
if '%choice%'=='2' goto DRIVE 2
if '%choice%'=='3' goto DRIVE 3
if '%choice%'=='4' goto DRIVE 4
if '%choice%'=='5' goto DRIVE 5
if '%choice%'=='6' goto DRIVE 6
if '%choice%'=='7' goto DRIVE 7
if '%choice%'=='8' goto DRIVE 8
if '%choice%'=='9' goto DRIVE 9
ECHO "%choice%" is not valid, try again
ECHO.
PING localhost -n 2 >NUL

goto Start