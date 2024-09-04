# Dagster Docker

## Introduction
This Dagster project runs in a Docker container, utilizing a PostgreSQL database to manage Dagster processes and logs. The entire setup is defined in a single `docker-compose.yaml` file, which also includes PgAdmin for accessing the PostgreSQL database.

## How to Install the Project through Batch Scripts
Below are the steps to install and browse the project:

1. Clone the repository:
   ```git clone https://github.com/ULL-IR-Office/Dagster-Docker.git```
2. In the Batch Scripts folder run `Initialize.bat` file to build and run the containers. This will run Dagster webserver, Deamon, Postgres and PgAdmin
3. You can also utilize `Stop.bat` and `Stop & Remove.bat` files to remove or stop the containers.

## How to Install the Project manually
Below are the steps to install and browse the project:

1. Clone the repository:
   ```git clone https://github.com/ULL-IR-Office/Dagster-Docker.git```
2. In the root folder build the docker image for dagster using the command  
      ```bash
    docker build -t dagster-docker .
    ```
   **Note:** 'Do not change the tag name while building the docker image'.
3. Now build the docker compose file using the command
   ```bash
    docker-compose up
    ```
    This will build and run the Dagster Webserver, Dagster Daemon, Postgres and PgAdmin.
    
## How to use this project
After Successful setup of docker containers, Open `http://localhost:3000` to browse the dagster project. And for PgAdmin open `http://localhost:5050` using the credentials **username: admin@example.com** & **pswd: admin123**

## Development

### Adding new Python dependencies

You can specify new Python dependencies in `setup.py`.

### Unit testing

Tests are in the `dag_test_tests` directory and you can run tests using `pytest`:

```bash
pytest dag_test_tests
```

### Schedules and sensors

If you want to enable Dagster [Schedules](https://docs.dagster.io/concepts/partitions-schedules-sensors/schedules) or [Sensors](https://docs.dagster.io/concepts/partitions-schedules-sensors/sensors) for your jobs, the [Dagster Daemon](https://docs.dagster.io/deployment/dagster-daemon) process must be running. This is done automatically when you build and run the docker container.

Once your Dagster Daemon is running, you can start turning on schedules and sensors for your jobs.

## Deploy on Dagster Cloud

The easiest way to deploy your Dagster project is to use Dagster Cloud.

Check out the [Dagster Cloud Documentation](https://docs.dagster.cloud) to learn more.
