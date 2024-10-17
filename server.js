const express = require('express');
const puppeteer = require('puppeteer');
const NodeCache = require('node-cache');

// Cache configuration (time in seconds, here 24 hours)
const cache = new NodeCache({ stdTTL: 86400 }); // Cache TTL: 24 hours

const app = express();
const port = 3000;

// Function to scrape TikTok trending creators
const scrapeTikTokTrendingCreators = async () => {
    let browser;
    try {
        browser = await puppeteer.launch({ headless: true });
        const page = await browser.newPage();

        // Set the user-agent to avoid bot detection
        await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36');

        // Go to TikTok's trending page (adjust URL based on region if necessary)
        await page.goto('https://www.tiktok.com/trending', { waitUntil: 'networkidle2' });

        // Wait for trending creator elements to load
        await page.waitForSelector('div.creator-info');

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

        return creators;
    } catch (error) {
        console.error('Error scraping TikTok:', error);
        throw error;
    } finally {
        if (browser) {
            await browser.close();
        }
    }
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

        // Handle case where no creators were scraped
        if (!creators || creators.length === 0) {
            return res.status(404).json({ error: 'No trending creators found' });
        }

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
