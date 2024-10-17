# Use the official Python 3.11 image
FROM python:3.11-slim

# Install pip and essential build dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    build-essential \
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the requirements file to the container
COPY requirements.txt .

# Install the required Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app's source code to the container
COPY . .

# Expose the port on which the Flask app will run
EXPOSE 8080

# Command to run the Flask app
CMD ["python", "app.py"]
