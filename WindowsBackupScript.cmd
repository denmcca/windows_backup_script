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


:backupDirs
    @rem Read directory file and do backup for each one.
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

:backupDir
    @rem Call backup executable.
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

:trim
    @rem Get rid of trailing whitespace.
    echo Trimming: %~1
    set %~1=%~1
    echo Trim result: %~1
goto :eof

:getLast
    @rem Get last directory of path.
    @rem %1 variable output.
    @rem %2 string path to get last token from.
    @rem If given string path ends with colon (drive root), then drop the colon.
    echo Getting last token from: %~2
    if "%~2:~-1"==":" (set "%~1=%~d2") else (set "%~1=%~n2%~x2")
goto :eof

:main
    call :backupDirs %inputFilePath% , %dest%
    pause
exit /b 0