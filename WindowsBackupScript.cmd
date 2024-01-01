@ECHO OFF

@rem ***********************************************************************
@rem This batch/command script backs up and syncs the directories found in
@rem the given config file (argument 1) to the given directory (argument 2).
@rem call WindowsBackupScript -dirfile -destpath
@rem -dirfile File which contains the string of directories delimited by
@rem newline.
@rem -destpath Location where the target source directories will be stored
@rem using the target source directory name as a sub-directory.
@rem ***********************************************************************

setlocal enabledelayedexpansion

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

    SET sourceDir=%%~d
    SET "sourceDir=!sourceDir:\=/!"
    @REM Use exclamation marks instead of percent signs for variables set in loop??
    IF !sourceDir:~-1!==/ SET sourceDir=!sourceDir:~0,-1!
    CALL :TRIM !sourceDir!
    
    CALL :GETLAST subDestDir "!sourceDir!"
    IF "!subDestDir:~-1!"=="%:" SET subDestDir=!subDestDir:~0,-1!

    ECHO subDestDir: !subDestDir!
    SET destDir=%dest%!subDestDir!
    
    ECHO sourceDir: !sourceDir!
    ECHO destDir: !destDir!

    CALL :BackupDir "!sourceDir!" "!destDir!"
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

ECHO Backing up %1 to %2 ...

robocopy "%~1" "%~2" /MIR

ECHO Completed backing up %1.

EXIT /B 0
@REM End function

@REM Start main
:MAIN

CALL :BackupDirs %inputFilePath% , %dest%

PAUSE

EXIT /B 0
@REM End main

:TRIM
ECHO Trimming: %~1
SET %~1=%~1
ECHO Trim result: %~1
EXIT /B 0

:GETLAST
ECHO Getting last token from: %~2
IF "%~N2"=="" (SET "%~1=%~2") ELSE (SET "%~1=%~N2")
EXIT /B 0