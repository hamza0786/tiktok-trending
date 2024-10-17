# Use Python 3.11 slim as the base image
FROM python:3.11-slim

# Install pip and other essential tools
RUN apt-get update && apt-get install -y \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the requirements file to the container
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the app source code to the container
COPY . .

# Expose the port on which the app will run
EXPOSE 8080

# Command to run the Flask app
CMD ["python", "app.py"]
