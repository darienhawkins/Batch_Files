REM Important information obfuscated (hostname, IP address, username, password, etc)

REM **** TEST TO SEE IF OS IS WINNT ****
REM IF %OS%==Windows_NT GOTO CHECK

:CHECK
IF EXIST \\ntfileserver01\SHARED\REGFILES\%USERNAME%.REG GOTO MIGRATE

REM **** EXITS IF OS IS OTHER THAN WINNT ****
GOTO END

REM **** MIGRATES OUTLOOK PROFILE TO COMPUTER ****
:MIGRATE
regedit /s /U \\ntfileserver01\SHARED\REGFILES\%USERNAME%.REG

:END
