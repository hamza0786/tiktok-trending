const express = require('express');
const puppeteer = require('puppeteer-core');
const NodeCache = require('node-cache');

// Cache configuration (time in seconds, here 24 hours)
const cache = new NodeCache({ stdTTL: 86400 }); // Cache TTL: 24 hours

const app = express();
const port = 3000;

// Function to scrape TikTok trending creators
const scrapeTikTokTrendingCreators = async () => {
    const browserFetcher = puppeteer.createBrowserFetcher({ path: '/tmp/puppeteer-cache' });
    await browserFetcher.download(puppeteer.PUPPETEER_REVISIONS.chromium);

    // Launch Puppeteer with the default Chromium
    const browser = await puppeteer.launch({
    headless: true,
    executablePath: '/usr/bin/google-chrome', // Explicitly point to the installed Chrome
    });
    const page = await browser.newPage();

    // Go to TikTok's trending page (adjust URL based on region if necessary)
    await page.goto('https://www.tiktok.com/trending', { waitUntil: 'networkidle2' });

    // Scrape trending creators
    const creators = await page.evaluate(() => {
        const creatorElements = document.querySelectorAll('div.creator-info'); // Adjust selector based on page structure

        const data = [];
        creatorElements.forEach((creatorElement) => {
            const name = creatorElement.querySelector('.creator-name')?.innerText;
            const avatar = creatorElement.querySelector('.creator-avatar img')?.src;

            if (name && avatar) {
                data.push({
                    name: name,
                    avatar: avatar,
                });
            }
        });
        return data;
    });

    await browser.close();
    return creators;
};

// Define API endpoint
app.get('/trending-creators', async (req, res) => {
    try {
        // Check if data is already in the cache
        const cachedData = cache.get('trendingCreators');
        if (cachedData) {
            console.log('Serving from cache');
            return res.json(cachedData);
        }

        // If not in cache, scrape the data
        console.log('Scraping TikTok trending creators...');
        const creators = await scrapeTikTokTrendingCreators();

        // Store the data in cache before responding
        cache.set('trendingCreators', creators);

        res.json(creators);
    } catch (error) {
        console.error('Error fetching trending creators:', error);
        res.status(500).json({ error: 'Failed to fetch trending creators' });
    }
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
