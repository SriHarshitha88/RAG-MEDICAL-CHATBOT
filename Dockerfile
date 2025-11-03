## Parent image
FROM python:3.10-slim

## Essential environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

## Work directory inside the docker container
WORKDIR /app

## Installing system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

## Copy requirements first for better caching
COPY requirements.txt .

## Install Python dependencies with optimizations
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir --no-deps -r requirements.txt || \
    pip install --no-cache-dir -r requirements.txt

## Copy the rest of the application
COPY . .

## Install the application
RUN pip install --no-cache-dir -e .

## Expose only flask port
EXPOSE 5000

## Run the Flask app
CMD ["python", "app/application.py"]




