REM Important information obfuscated (hostname, IP address, username, password, etc)

@echo off

REM ***************************************************************************
REM    Create AD Students, enable accounts, Reset password
REM    Create gmail account via Powershell script
REM    Auto move CSV and TXT file
REM    Updated; 20 June 2018, Darien Hawkins
REM    Version 8
REM ***************************************************************************


cls
color 0a


REM ********** DECLARE BATCH FILE VARIABLES ***********************************
set dirGSync=RunManualDirSyncGoogle.ps1
set rnMvFile=RenameAndMoveFiles.ps1
set srceFldr=\\SuperMicroDellGenericFileServer01\Temp_Shares\Student_Imports
set logsFldr=Logs
set scptFldr=Scripts
set oldFldr=Old
set addsSevr=DellADDSDCSevr3
set addsGrps="hustudents","all users","QPMRegistration","pirate wireless 1"
REM ********** AUTODISCOVER CSV AND TXT FILE AND SET VARIABLES  ***************
for /f %%i in ('dir /b "%srceFldr%\*.csv"') do set csvFile=%%i
for /f %%i in ('dir /b "%srceFldr%\*.txt"') do set pssFile=%%i
REM set csvFile=ad_import_file_New_FALL_061818.csv
REM set pssFile=ad_import_file_New_FALL_061818.txt


REM ********** IF NO CSV FILE, TERMINATE SCRIPT  ******************************
if "%csvFile%"=="" (
	@echo *************************************************************************
	@echo ***** Cannot locate CSV file to process.  Script will terminate. ********
	@echo *************************************************************************
	pause
	goto ENDBATCH
	) 


REM ********** CREATE USERS VIA CSV FILE FROM BANNER/TOAD *********************
csvde -s %addsSevr% -i -f %srceFldr%\%csvFile% -k -j %srceFldr%\%logsFldr%


REM ********** PROMPT USER TO CONTINUE ****************************************
@echo *************************************************************************
@echo *************************************************************************
@echo "If the AD Import FAILED to run correctly,"
@echo "press <CTRL>+<C> followed by 'Y' to terminate. Otherwise," && pause
cls
color 0e

repadmin /syncall DellADDSDCSevr3
REM pause
ping -n 10

REM ********** SET PASSWORD, ENABLE ACCOUNT ***********************************
for /f "tokens=1-2" %%a in (%srceFldr%\%pssFile%) do (
	net user %%a %%b /DOMAIN /ACTIVE:YES /LOGONPASSWORDCHG:NO
	REM ********** ADD GROUP MEMBERSHIPS **************************************
	for %%g in (%addsGrps%) do (
		net group %%g %%a /ADD /DOMAIN
	)
)


REM ********** PROMPT USER TO CONTINUE ****************************************
@echo *************************************************************************
@echo *************************************************************************
@echo "If the password, enable account process FAILED to run correctly,"
@echo "press <CTRL>+<C> followed by 'Y' to terminate. Otherwise, to process"
@echo "the Google Directory Sync," && pause
cls
color 0b


REM ********** MOVE PROCESSED FILES *******************************************
move %srceFldr%\%csvFile% %srceFldr%\%oldFldr%
move %srceFldr%\%pssFile% %srceFldr%\%oldFldr%


REM ********** CALL GOOGLE DIRSYNC POWERSHELL SCRIPT **************************
color 0f
powershell -ExecutionPolicy Unrestricted -file %srceFldr%\%scptFldr%\%dirGSync%


:ENDBATCH