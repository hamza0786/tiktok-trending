# Use a Node.js image as the base
FROM node:18

FROM 495519747063.dkr.ecr.us-east-2.amazonaws.com/awsfusionruntime-nodejs18-build:uuid-nodejs18-20240925-003710-44 AS pre-build-stage

# Install Chromium and any other dependencies
RUN apt-get update && apt-get install -y \
    chromium \
    && rm -rf /var/lib/apt/lists/*

COPY . /app
WORKDIR /app/

# The remaining stages
FROM pre-build-stage AS build-stage
# Your additional build commands

FROM 495519747063.dkr.ecr.us-east-2.amazonaws.com/awsfusionruntime-nodejs18:uuid-nodejs18-20240925-003710-44 AS packaging-stage
COPY --from=build-stage /app /app
WORKDIR /app/

RUN which chromium
    
# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json .
RUN npm install

# Copy the rest of the application code
COPY . .

# Set environment variable to use system Chrome
# Set environment variable to use Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV CHROMIUM_PATH=/usr/bin/chromium

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
