REM @echo off
IF "%OS%"=="Windows_NT" goto NT

:95
IF EXIST "%WINDIR%\Application Data\Microsoft\Outlook\vbaproject.otm"
FC %LOGONSERVER%\NETLOGON\vbaproject.otm "%WINDIR%\Application Data\Microsoft\Outlook\vbaproject.otm"  | find "FC: no diff" > nul
IF errorlevel=1
copy %LOGONSERVER%\NETLOGON\vbaproject.otm "%WINDIR%\Application Data\Microsoft\Outlook\vbaproject.otm"
ECHO Installing Anti-Virus Macro
goto END

:NT
IF EXIST "%WINDIR%\Profiles\%USERNAME%\Application Data\Microsoft\Outlook\vbaproject.otm"
FC %LOGONSERVER%\NETLOGON\vbaproject.otm "%WINDIR%\Profiles\%USERNAME%\Application Data\Microsoft\Outlook\vbaproject.otm"  | find "FC: no diff" > nul
IF errorlevel=1
copy %LOGONSERVER%\NETLOGON\vbaproject.otm "%WINDIR%\Profiles\%USERNAME%\Application Data\Microsoft\Outlook\vbaproject.otm"
ECHO Installing Anti-Virus Macro

:END
@echo on
