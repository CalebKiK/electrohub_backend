# Stage 1: Build dependencies
FROM python:3.12-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl \
 && rm -rf /var/lib/apt/lists/*

# Copy only requirements first (better caching)
COPY requirements.txt .

# Install to a staging prefix so we can copy clean site-packages later
RUN python -m pip install --upgrade pip \
 && pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: Final minimal image
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Minimal runtime OS deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Copy installed packages from builder stage
COPY --from=builder /install /usr/local

# Copy application code
COPY . .

# Expose Flask port
EXPOSE 5000

# Run the app
CMD ["bash", "start.sh"]

# # Use Python 3.12 base image
# FROM python:3.12-slim

# # Set working directory
# WORKDIR /app

# # Install system dependencies
# RUN apt-get update && apt-get install -y gcc libpq-dev

# # Copy project files
# COPY . .

# # Install Python dependencies using Pipenv
# # RUN pip install pipenv && pipenv install --system --deploy && pip install gunicorn

# # Install Python dependencies
# RUN pip install --no-cache-dir -r requirements.txt

# # Expose Flask port
# EXPOSE 5000

# # Run the app
# CMD ["bash", "start.sh"]
