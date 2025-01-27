# Use the official Python 3.12.5 Alpine image
FROM python:3.12.5-alpine

# Set the working directory inside the container
WORKDIR /opt/dagster

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the project files into the container
COPY . .

# Create the `data` directory inside the container and set appropriate permissions
RUN mkdir -p /opt/dagster/data && chmod -R 777 /opt/dagster/data

# Expose the port for the Dagster web server
EXPOSE 3000
