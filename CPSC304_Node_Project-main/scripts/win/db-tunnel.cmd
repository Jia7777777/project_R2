@echo off
setlocal enabledelayedexpansion

:: Change to the directory where the script is located
cd %~dp0

:: File path
set ENV_FILE_PATH=..\..\.env
set TMP_FILE_PATH=temp.env

:: Define a range
set START=50000
set END=55000
set chosen_port=

:: Variables to track if ORACLE_HOST and ORACLE_PORT are found
set found_host=0
set found_port=0


:: Delete temp file if it already exists
if exist %TMP_FILE_PATH% (
    del %TMP_FILE_PATH% >nul
)

:: Check if ORACLE_HOST and ORACLE_PORT variables exist in the .env file
findstr /B "ORACLE_HOST=" %ENV_FILE_PATH% >nul && SET found_host=1
findstr /B "ORACLE_PORT=" %ENV_FILE_PATH% >nul && SET found_port=1

:: Check if ORACLE_HOST and ORACLE_PORT were found, if not, exit 1
if not !found_host!==1 (
    goto handleError
)
if not !found_port!==1 (
    goto handleError
)
goto continue

:handleError
    echo "ERROR: ORACLE_HOST or ORACLE_PORT not found in the .env file."
    exit /b 1

:continue

:: Loop through the range and check if the port is in use
for /l %%i in (%START%,1,%END%) do (
    netstat -an | find "%%i" >nul
    if errorlevel 1 (
        :: Port is available
        set chosen_port=%%i
        goto foundPort
    )
)

:foundPort
if "%chosen_port%"=="" (
    echo No free port found in range 50000-55000.
    exit /b 1
)

:: Replace ORACLE_HOST and ORACLE_PORT in the .env file
for /F "tokens=1,* delims=:" %%l in ('findstr /n "^" %ENV_FILE_PATH%') do (
    set "line=%%m"
    if "%%m"=="" (
        echo. >> %TMP_FILE_PATH%
    ) else if "!line:~0,12!"=="ORACLE_HOST=" (
        echo ORACLE_HOST=localhost >> %TMP_FILE_PATH%
    ) else if "!line:~0,12!"=="ORACLE_PORT=" (
        echo ORACLE_PORT=%chosen_port% >> %TMP_FILE_PATH%
    ) else (
        echo !line! >> %TMP_FILE_PATH%
    )
)

:: Move temp file back to original .env file
move /Y %TMP_FILE_PATH% %ENV_FILE_PATH% >nul

:: Delete the temporary file
del %TMP_FILE_PATH% >nul

echo Building SSH tunnel on port %chosen_port% to your oracle database...

set /p cwl_name=Enter your CWL name:

:: Try to find ssh in the system's PATH
where /q ssh
if errorlevel 0 (
    ssh -L !chosen_port!:dbhost.students.cs.ubc.ca:1522 !cwl_name!@remote.students.cs.ubc.ca
    goto :end
)

:: Check for Plink availability and run the appropriate command
if exist "%ProgramFiles%"\PuTTY\plink.exe (
    "%ProgramFiles%"\PuTTY\plink.exe -L !chosen_port!:dbhost.students.cs.ubc.ca:1522 !cwl_name!@remote.students.cs.ubc.ca
    goto :end
) else if exist "%ProgramFiles(x86)%"\PuTTY\plink.exe (
    "%ProgramFiles(x86)%"\PuTTY\plink.exe -L !chosen_port!:dbhost.students.cs.ubc.ca:1522 !cwl_name!@remote.students.cs.ubc.ca
    goto :end
) else (
    echo Neither SSH nor PuTTY's Plink was found on your system.
    echo If you have SSH or PuTTY installed, please ensure they are in the expected paths or add them to your PATH variable.
    echo Otherwise, you might need to manually set up the SSH tunnel using your preferred SSH client.
    pause
    exit /b 1
)

:end
exit /b 0

