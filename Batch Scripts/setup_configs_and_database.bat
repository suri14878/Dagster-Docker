@echo off

rem sets the PROJ_DIR variable to the parent directory. 
FOR %%A IN ("%~dp0.") DO set "PROJ_DIR=%%~dpA"

cd "%PROJ_DIR%"

REM Activate virtual environment if needed
call venv_eventTrack\Scripts\activate.bat

REM Creating default configurations for logger and main project
echo Setting up the default configurations for Logger and main databases...
python Setup/create_configs.py

echo Default configurations for Logger and databases setup complete.

REM Setting up Postgres schema and inserting input records
echo Setting up the database schema with some sample input data...
python Setup/setup_schema.py

echo Database setup complete.
pause
