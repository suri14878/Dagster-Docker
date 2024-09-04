@echo off

:: Check Docker service status
docker info >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Dagster Docker service is not running. Container is already stopped.
    pause
    exit /b 0
)

:: Stop container and network
docker-compose stop
if %ERRORLEVEL% neq 0 (
    echo Error: docker-compose stop failed.
    pause
    exit /b %ERRORLEVEL%
)
echo docker-compose stop executed successfully.

pause
exit /b 0