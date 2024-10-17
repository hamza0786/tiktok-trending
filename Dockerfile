# Use a Node.js image as the base
FROM node:18

# Install Chrome
RUN apt-get update && apt-get install -y \
    gconf-service \
    libasound2 \
    libatk1.0-0 \
    libcups2 \
    libgconf-2-4 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxi6 \
    libxtst6 \
    fonts-liberation \
    xdg-utils \
    wget \
    libappindicator3-1 \
    libgbm-dev

    # Install Puppeteer and necessary browser files
RUN npm install puppeteer

# Optionally, install a specific version of Chrome if needed
RUN npx puppeteer browsers install chrome

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json .
RUN npm install

# Copy the rest of the application code
COPY . .

# Set environment variable to use system Chrome
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV CHROMIUM_PATH=/usr/bin/google-chrome

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
