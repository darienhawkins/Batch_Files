REM Important information obfuscated (hostname, IP address, username, password, etc)

@Echo off
cls

REM ##########################################
REM 
REM   Process TouchNet ACH Batch File
REM   Written by Darien Hawkins, Director
REM   Updated by Darien Hawkins, Director
REM   Update date: 28 Aug, 2020
REM   Version 2.3
REM 
REM   Script devired from Positive Pay Batch
REM   File
REM   Use UNC paths instead of mapped drive
REM
REM ##########################################

REM Set variables, establish environment

cls
color 07
set counter=1
SET serverBase=\\DellGenericFileServer01\systems
SET uncPath=%serverBase%\BannerProd\touchnet\ach
SET sendMailFolder=_Tools\SendEmail
SET scriptFolder=scripts
SET archiveFolder=archive
SET processFolder=Process
SET winSCPArg=gxfach_send_sftp_uncpath.txt


REM Check for file to process before starting. Exit if not found.
:CheckForFile
if exist %uncPath%\tpgc* GOTO start
cls
color 4f & echo . & echo .
Echo Cannot find ACH file to process!  Exiting.  Good bye.
echo . & echo . & pause
goto End

REM Start
goto ProcessPosPay


REM ===========================================================================

:ProcessPosPay
REM Copy file to archive and process folders
	copy %uncPath%\tpgc* %uncPath%\%archiveFolder%\ /y
	copy %uncPath%\tpgc* %uncPath%\%processFolder%\ /y
REM Invoke commandline WinSCP and call script file
	%uncPath%\scripts\WinSCP\winscp.com /script=%uncPath%\%scriptFolder%\%winSCPArg%
REM Delete from UNC root
	DEL %uncPath%\tpgc*

REM ===========================================================================

:sendmailMessage
REM Step 8: Send email
set msgEmailServer=aaa.bbb.ccc.ddd
set msgMessage="Touchnet ACH file sent to BOFA.  Please call and confirm with BOFA approximately 15 minutes following recipient of this message."
set msgSubject="Touchnet ACH File Sent Acknowledgement Message"
set msgRecipients=darien.hawkins@higheredinstitutiondomain.edu,princess.lipscomb@higheredinstitutiondomain.edu,bannerjobs@higheredinstitutiondomain.edu
set msgFrom=FileSendAck-DoNotReply@higheredinstitutiondomain.edu
%serverBase%\%sendMailFolder%\sendEmail.exe -s %msgEmailServer% -m %msgMessage% -u %msgSubject% -t %msgRecipients% -f %msgFrom%
PING localhost -n 3 >NUL

REM ===========================================================================

cls
dir %uncPath%\%processFolder% /B
Echo Touchnet ACH processed to Bank of America
REM Wait about 6 seconds or so.
PING localhost -n 6 >NUL


REM Delete from process folder
DEL %uncPath%\%processFolder%\tpgc*

GOTO End

:End
color 07