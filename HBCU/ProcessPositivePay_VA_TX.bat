REM Important information obfuscated (hostname, IP address, username, password, etc)

REM ##########################################
REM 
REM   Process PositivePay Batch File
REM   Written by Darien Hawkins, Director
REM   Updated by Darien Hawkins, Director
REM   Update date: 28 Aug, 2020
REM   Version 2.3
REM 
REM   
REM   Use UNC paths instead of mapped drive
REM
REM ##########################################

REM Set variables, establish environment
@Echo off
cls
color 07
set counter=1
set prmpt="Enter V for Bofa Virgina or T for BofA Texas: "
SET serverBase=\\DellGenericFileServer01\systems
SET uncPath=%serverBase%\BannerProd\Positive_Pay
SET sendMailFolder=_Tools\SendEmail
SET scriptFolder=scripts
SET archiveFolder=archive
SET processFolder=Processs


REM Check for file to process before starting. Exit if not found.
:CheckForFile
if exist %uncPath%\pospay* GOTO start
cls
color 4f & echo . & echo .
Echo Cannot find positive pay file to process!  Exiting.  Good bye.
echo . & echo . & pause
goto End

:start
set /p id=%prmpt% 

REM Catch upper and lower case entries
if %id% == t GOTO texas
if %id% == T GOTO texas
if %id% == v GOTO virgina
if %id% == V GOTO virgina

REM Start counter for invalid entires, change prompt.
:count
cls
if %counter%==3 goto toomanytries
set /a counter=%counter%+1
set prmpt="Invalid entry.  Please enter V for BofA Virgina or T for BofA Texas: "
GOTO start

REM Red alert, exit after three invalid entries
:toomanytries
color 4e
cls
echo . & echo .
echo You entered three invalid entries!  Exiting.  Good bye.
echo . & echo . & pause
goto End

:texas
color 0e
REM Set variables for Texas
SET state=Texas
SET posPayFile=pospayTX.txt
SET winSCPArg=gxfpptx_send_sftp_uncpath.txt
goto ProcessPosPay

:virgina
color 0a
REM Set variables for Virginia
SET state=Virginia
SET posPayFile=pospayVA.txt
SET winSCPArg=gxfppva_send_sftp_uncpath.txt
goto ProcessPosPay


REM ===========================================================================

:ProcessPosPay
cls
Echo You selected %state%.
pause

REM Copy file to archive and process folders
	copy %uncPath%\pospay* %uncPath%\%archiveFolder%\ /y
	copy %uncPath%\pospay* %uncPath%\%processFolder%\ /y
REM Invoke commandline WinSCP and call script file
	%uncPath%\scripts\WinSCP\winscp.com /script=%uncPath%\%scriptFolder%\%winSCPArg%
REM Delete from UNC root
	DEL %uncPath%\pospay*

REM ===========================================================================

:sendmailMessage
REM Step 8: Send email
set msgEmailServer=aaa.bbb.11.46
set msgMessage="Postive pay file sent to BOFA in %state%.  Please call and confirm with BOFA approximately 15 minutes following recipient of this message."
set msgSubject="Positive Pay Sent to %state% Acknowledgement Message"
set msgRecipients=bannerjobs@higheredinstitutiondomain.edu,cecelia.hill@higheredinstitutiondomain.edu, mershelle.butler@higheredinstitutiondomain.edu
set msgFrom=FileSendAck-DoNotReply@higheredinstitutiondomain.edu
%serverBase%\%sendMailFolder%\sendEmail.exe -s %msgEmailServer% -m %msgMessage% -u %msgSubject% -t %msgRecipients% -f %msgFrom%
PING localhost -n 3 >NUL


cls
dir %uncPath%\%processFolder% /B 
Echo Positive Pay processed to Bank of America in %state%.
REM Wait about 6 seconds or so.
PING localhost -n 6 >NUL


REM Delete from process folder
DEL %uncPath%\%processFolder%\pospay*

GOTO End

rem transmissions support 1 855 515 6600 opt 2
rem user id for Virginia xxxxxxx
rem user id for Texas xxxxxxx

:End
color 07