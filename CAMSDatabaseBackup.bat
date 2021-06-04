REM ***************************************************
REM       THIS BATCH FILE BACKS UP THE CFRS DATABASES
REM       TO AN ALTERNATE LOCATION
REM       DATE MODIFIED: 5 OCTOBER 2004
REM       BY TSGT DARIEN H HAWKINS
REM ***************************************************

SET MASTERDATA-SOURCE=\\ntfileserver03\wincfrs\server\Masterdata
SET LOCAL-SOURCE=\\ntfileserver03\wincfrs\server\LOCAL
SET CAMS-SOURCE=\\ntfileserver03\wincfrs\server\CAMS


SET DESTINATION=\\ntfileserver00\Backups\CFRS-Databases\"%DATE%"
 
REM IF EXIST %BACKUP-LOCATION% GOTO END
 
MD %DESTINATION%
 
COPY %MASTERDATA-SOURCE% %DESTINATION% /Y
COPY %LOCAL-SOURCE% %DESTINATION% /Y
COPY %CAMS-SOURCE% %DESTINATION% /Y
 
:END