:: Sebastian Petersen
:: sebastian@srmail.dk

@ECHO off
CHCP 65001
CLS

:Start
CLS
ECHO Dette script fungerer kun i MAN Greve.
ECHO.
ECHO  1. Trucksales (192.168.204.28) (X)
ECHO  2. Servicedk (192.168.204.28) (G)
ECHO  3. Produkt (192.168.204.28) (H)
ECHO  4. Fælles (mandknt) (F)
ECHO  5. Fælles (192.168.204.3) (F)
ECHO  6. Personlig (192.168.204.28) (P)
ECHO.
set choice=
set /p choice=Please select an option: 

if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto X
if '%choice%'=='2' goto G
if '%choice%'=='3' goto H
if '%choice%'=='4' goto mandknt
if '%choice%'=='5' goto F
if '%choice%'=='6' goto P
ECHO "%choice%" is not valid, try again
ECHO.
PING localhost -n 2 >NUL

goto Start


:X
net use X: \\192.168.204.28\Trucksales /PERSISTENT:YES
PING localhost -n 3 >NUL
goto Start

:G
net use G: \\192.168.204.28\servicedk /PERSISTENT:YES
PING localhost -n 3 >NUL
goto Start

:H
net use H: \\192.168.204.28\produkt /PERSISTENT:YES
PING localhost -n 3 >NUL
goto Start

:mandknt
net use X: \\192.168.204.28\Trucksales /PERSISTENT:YES
PING localhost -n 3 >NUL
goto Start

:F
net use F: \\192.168.204.3\Fælles /PERSISTENT:YES
PING localhost -n 3 >NUL
goto Start

:P
start \\192.168.204.28\
goto Start