@echo off
:: Define the path to the GitHub directory
setlocal enabledelayedexpansion

rem Set the location to the folder where you want to start
set "githubDir=%USERPROFILE%\Documents\GitHub"

rem Loop through all subdirectories
for /r "%githubDir%" %%d in (.) do (
    rem Check if the directory is a git repository by looking for the .git folder
    if exist "%%d\.git" (
        echo Pulling in repository: %%d
        cd "%%d"
        git pull
        cd ..
    )
)

echo Finished pulling updates in all repositories.
pause
