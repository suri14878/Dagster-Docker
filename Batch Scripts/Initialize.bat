@echo off

:: Sets the CURRENT_DIR variable to the current directory.
set "CURRENT_DIR=%~dp0"
:: Sets the PROJ_DIR variable to the parent directory.
FOR %%A IN ("%~dp0.") DO set "PROJ_DIR=%%~dpA"

:: Define the log file path and clear any existing log file
set "LOG_FILE=%CURRENT_DIR%\Initialize-log.txt"
if exist "%LOG_FILE%" del "%LOG_FILE%"

:: Change to the directory where the script is located
cd /d "%PROJ_DIR%"

:: Define the local directory to mount
set "LOCAL_DATA_DIR=%PROJ_DIR%\data"
if not exist "%LOCAL_DATA_DIR%" mkdir "%LOCAL_DATA_DIR%"

echo Building the Docker image with the tag dagster-docker...

:: Build Dagster image
docker build -t dagster-docker .
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to build the Dagster Docker image.
    pause
    exit /b %ERRORLEVEL%
)

echo Starting Docker Compose...

:: Check Docker service status
docker info >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Docker service is not running. Please start Docker and try again.
    pause
    exit /b %ERRORLEVEL%
)

:: Run docker-compose up with volume mapping
docker-compose up -d
if %ERRORLEVEL% neq 0 (
    echo Error: docker-compose up failed.
    pause
    exit /b %ERRORLEVEL%
)
echo docker-compose up ran successfully.

:: Check if the dagster webserver container is running
docker ps --filter "name=dagster-webserver" | findstr /C:"dagster-webserver" >nul
if %ERRORLEVEL% neq 0 (
    echo Error: Container dagster-webserver is not running.
    pause
    exit /b %ERRORLEVEL%
)
echo dagster-webserver Container is running. 

:: Check if the dagster-daemon container is running
docker ps --filter "name=dagster-daemon" | findstr /C:"dagster-daemon" >nul
if %ERRORLEVEL% neq 0 (
    echo Error: Container dagster-daemon is not running.
    pause
    exit /b %ERRORLEVEL%
)
echo dagster-daemon Container is running. 

:: Check if the postgres-db container is running
docker ps --filter "name=postgres-db" | findstr /C:"postgres-db" >nul
if %ERRORLEVEL% neq 0 (
    echo Error: Container postgres-db is not running.
    pause
    exit /b %ERRORLEVEL%
)
echo postgres-db Container is running. If this is your first run, give a moment for the database to initialize.

:: Check if the pgadmin container is running
docker ps --filter "name=pgadmin" | findstr /C:"pgadmin" >nul
if %ERRORLEVEL% neq 0 (
    echo Error: Container pgadmin is not running.
    pause
    exit /b %ERRORLEVEL%
)
echo pgadmin Container is running.

echo Docker Compose started successfully.
pause
exit /b 0