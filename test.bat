REM **** CHECKS EVIRONMENT VARIABLES ****

IF %OFFICENAME% == scna GOTO LAN_ADMIN
IF %OFFICENAME% == safety GOTO OPS
IF %OFFICENAME% == ops GOTO OPS
IF %OFFICENAME% == mobility GOTO MOBILITY
IF %OFFICENAME% == orderlyroom GOTO ORDERLYROOM
IF %OFFICENAME% == plans_sched GOTO PLANS_SCHED
IF %OFFICENAME% == life_support GOTO LIFESUPPORT
IF %OFFICENAME% == debrief GOTO DEBRIEF
IF %OFFICENAME% == resource_advisor GOTO RESOURCE_ADVISOR
IF %OFFICENAME% == specialist GOTO MAINTENANCE
IF %OFFICENAME% == weapons GOTO MAINTENANCE
IF %OFFICENAME% == apg_a GOTO MAINTENANCE
IF %OFFICENAME% == apg_b GOTO MAINTENANCE
IF %OFFICENAME% == supply GOTO SUPPLY
IF %OFFICENAME% == support GOTO SUPPLY
GOTO END

:LAN_ADMIN
CALL "\\lfi-fs-94fsnt01\shared\LAN\Domain Admin\DRIVES.BAT"
GOTO END

:SUPPLY
CALL \\LFI-FS-94FSNT01\NETLOGON\SUPPLY.BAT
GOTO END

:MAINTENANCE
CALL \\LFI-FS-94FSNT01\NETLOGON\MAINT.BAT
GOTO END

:RESOURCE_ADVISOR
CALL \\LFI-FS-94FSNT01\NETLOGON\RA.BAT
CALL \\LFI-FS-94FSNT01\NETLOGON\ABSS_MAP.BAT
GOTO END

:DEBRIEF
CALL \\LFI-FS-94FSNT01\NETLOGON\DEBRIEF.BAT
GOTO END

:LIFE_SUPPORT
CALL \\LFI-FS-94FSNT01\NETLOGON\LIFE_SUP.BAT
GOTO END

:PLANS_SCHED
CALL \\LFI-FS-94FSNT01\NETLOGON\PLANSSCHED.BAT
GOTO END

:ORDERLYROOM
CALL \\LFI-FS-94FSNT01\NETLOGON\94FS_CSS.BAT
GOTO END

:MOBILITY
CALL \\LFI-FS-94FSNT01\NETLOGON\MOBILITY.BAT
GOTO END

:SAFETY
CALL \\LFI-FS-94FSNT01\NETLOGON\OPS.BAT
GOTO END

:OPS
CALL \\LFI-FS-94FSNT01\NETLOGON\OPS.BAT
GOTO END

:END
PAUSE