@ECHO OFF

setlocal enabledelayedexpansion
:: This CMD script backs up and syncs the directories 
:: found in the given config file (argument 1) to the 
:: given directory (argument 2)

TITLE Windows Backup Script

ECHO Windows Backup initialized...

SET inputFilePath=%~1
SET dest=%~2

@REM Replacing backslashes with forwardslashes
SET "inputFilePath=%inputFilePath:\=/%"
SET "dest=%dest:\=/%"

@REM Ensure dest has trailing forwardslash
IF NOT %dest:~-1%==/ SET dest=%dest%/

ECHO Input File Path: %inputFilePath%
ECHO Backup path: %dest%

GOTO :MAIN

@REM Start function
:BackupDirs
ECHO Started backing up directories...

FOR /F "tokens=* delims=" %%d in (%inputFilePath%) DO (
    ECHO =========================
    ECHO %dest%
    ECHO %%~Nd
    CALL :BackupDir "%%d" "%dest%%%~Nd"
)

ECHO =========================

ECHO Finished backing up directories.

EXIT /B 0
@REM End function

@REM Start function
:BackupDir
IF %1=="" (
    ECHO No value for source.
    EXIT /B 1
)

IF %2=="" (
    ECHO No value for destination.
    EXIT /B 1
)

ECHO Backing up %~1 to %~2 ...

robocopy "%~1" "%~2" /MIR

ECHO Completed backing up %~1.

EXIT /B 0
@REM End function

@REM Start main
:MAIN

CALL :BackupDirs %inputFilePath% , %dest%

PAUSE

EXIT /B 0
@REM End main

