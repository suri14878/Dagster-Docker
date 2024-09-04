@echo off
:: Save the current directory
set "CURRENT_DIR=%~dp0"
:: sets the PROJ_DIR variable to the parent directory. 
FOR %%A IN ("%~dp0.") DO set "PROJ_DIR=%%~dpA"

:: Change to the directory where the script is located
cd /d "%PROJ_DIR%"

:: Check Docker service status
docker info >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Docker service is not running. Please start Docker and try again.
    pause
    exit /b %ERRORLEVEL%
)

:: Stop and remove the container and network
docker-compose down
if %ERRORLEVEL% neq 0 (
    echo Error: docker-compose down failed.
    pause
    exit /b %ERRORLEVEL%
)
echo docker-compose down executed successfully.

:: Remove the named volume
docker volume rm dagster-docker_postgres_data
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to remove volume dagster-docker_postgres_data
    pause
    exit /b %ERRORLEVEL%
)
echo volume removed successfully.

echo Docker Compose stopped and volume removed successfully.
pause
exit /b 0