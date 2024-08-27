FROM python:3.12.5-alpine

WORKDIR /opt/dagster

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 3000
