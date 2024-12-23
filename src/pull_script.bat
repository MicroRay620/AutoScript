@echo off
setlocal enabledelayedexpansion

REM Check if config file exists and create if needed
if not exist "repo_path.txt" (
    echo Config file repo_path.txt not found! Let's create it.
    :input_path
    set /p USER_PATH="Please enter the root repository path: "
    
    REM Validate entered path exists
    if not exist "!USER_PATH!" (
        echo Error: Entered path does not exist: !USER_PATH!
        echo Please enter a valid path.
        goto input_path
    )
    
    REM Save path to config file
    echo !USER_PATH!> repo_path.txt
    echo Path saved to repo_path.txt
)

REM Read root path from config
set /p ROOT_PATH=<repo_path.txt

REM Validate path exists
if not exist "%ROOT_PATH%" (
    echo Error: Path from repo_path.txt does not exist: %ROOT_PATH%
    pause
    exit /b 1
)

echo Starting git pull operations from: %ROOT_PATH%
echo ---------------------------------------------

REM Find all .git directories and process them
for /f "delims=" %%A in ('dir /b /s /ad "%ROOT_PATH%\.git" 2^>nul') do (
    set "REPO_DIR=%%~dpA"
    pushd "!REPO_DIR!"
    
    echo.
    echo Processing: !REPO_DIR!
    
    REM Check if git is available
    git --version >nul 2>&1
    if !errorlevel! neq 0 (
        echo Error: Git is not available in this directory
        goto :continue
    )
    
    REM Perform git pull
    git pull
    if !errorlevel! neq 0 (
        echo Warning: Git pull failed in !REPO_DIR!
    )
    
    :continue
    popd
)

echo.
echo ---------------------------------------------
echo All git repositories have been updated

endlocal