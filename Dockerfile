# Use Python 3.12 base image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y gcc libpq-dev

# Copy project files
COPY . .

# Install Python dependencies using Pipenv
# RUN pip install pipenv && pipenv install --system --deploy && pip install gunicorn

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose Flask port
EXPOSE 5000

# Run the app
CMD ["bash", "start.sh"]
