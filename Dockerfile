# Use Python 3.12 as the base image
FROM python:3.12-slim-bookworm

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    build-essential \
    libsqlite3-dev \
    libpq-dev \
    python3-dev \
    imagemagick \
    tesseract-ocr \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (for Prettier) and other dependencies
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install FastAPI, Uvicorn, and other required Python packages
RUN pip install --upgrade pip && \
    pip install fastapi uvicorn requests scipy python-dotenv pytesseract duckdb Pillow markdown openai

# Download and install `uv`
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

# Ensure the installed binary is on the `PATH`
ENV PATH="/root/.local/bin:$PATH"

# Set up the application directory
WORKDIR /app

# Copy application files into the container
COPY app.py /app
COPY tasksA.py /app
COPY tasksB.py /app

# Copy the .env file for environment variables
COPY .env /app/.env

# Set the default command to run the app using uv
CMD ["/root/.local/bin/uv", "run", "app.py"]
