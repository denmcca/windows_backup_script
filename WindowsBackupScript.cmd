@echo off

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

title Windows Backup Script

echo Windows Backup initialized...

set inputFilePath=%~1
set dest=%~2

@rem Replacing backslashes with forwardslashes
set "inputFilePath=%inputFilePath:\=/%"
set "dest=%dest:\=/%"

@rem Ensure dest has trailing forwardslash
if not %dest:~-1%==/ set dest=%dest%/

echo Input File Path: %inputFilePath%
echo Backup path: %dest%

goto :main

@rem Start function
:backupDirs
    echo Started backing up directories...

    for /F "tokens=* delims=" %%d in (%inputFilePath%) DO (
        echo =========================

        set sourceDir=%%~d
        set "sourceDir=!sourceDir:\=/!"
        @rem Use exclamation marks instead of percent signs for variables set in loop??
        if !sourceDir:~-1!==/ set sourceDir=!sourceDir:~0,-1!
        call :trim !sourceDir!
        
        call :getLast subDestDir "!sourceDir!"
        if "!subDestDir:~-1!"=="%:" set subDestDir=!subDestDir:~0,-1!

        echo subDestDir: !subDestDir!
        set destDir=%dest%!subDestDir!
        
        echo sourceDir: !sourceDir!
        echo destDir: !destDir!

        call :backupDir "!sourceDir!" "!destDir!"
    )

    echo =========================

    echo Finished backing up directories.

exit /b 0
@rem End function

@rem Start function
:backupDir
if %1=="" (
    echo No value for source.
    exit /b 1
)

if %2=="" (
    echo No value for destination.
    exit /b 1
)

echo Backing up %1 to %2 ...

robocopy "%~1" "%~2" /MIR

echo Completed backing up %1.

exit /b 0
@rem End function

@rem Start main
:main

call :backupDirs %inputFilePath% , %dest%

pause

exit /b 0
@rem End main

:trim
echo Trimming: %~1
set %~1=%~1
echo Trim result: %~1
exit /b 0

:getLast
echo Getting last token from: %~2
if "%~N2"=="" (set "%~1=%~2") else (set "%~1=%~N2")
exit /b 0