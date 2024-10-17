const express = require('express');
const axios = require('axios');
const cheerio = require('cheerio');
const NodeCache = require('node-cache');

// Cache configuration (time in seconds, here 24 hours)
const cache = new NodeCache({ stdTTL: 86400 }); // Cache TTL: 24 hours

const app = express();
const port = 3000;

// Function to scrape TikTok trending creators
const scrapeTikTokTrendingCreators = async () => {
    try {
        // Fetch the TikTok trending page
        const { data } = await axios.get('https://www.tiktok.com/trending');
        
        // Load the HTML into Cheerio
        const $ = cheerio.load(data);
        
        // Log the HTML data to inspect the structure
        console.log(data);  // Log the full HTML response

        // Scrape trending creators
        const creators = [];
        $('div.creator-info').each((index, element) => {
            const name = $(element).find('.creator-name').text().trim(); // Ensure to trim spaces
            const avatar = $(element).find('.creator-avatar img').attr('src');

            if (name && avatar) {
                creators.push({
                    name: name,
                    avatar: avatar,
                });
            }
        });

        console.log('Creators found:', creators);  // Log the creators array
        return creators;
    } catch (error) {
        console.error('Error scraping TikTok trending creators:', error);
        throw error;
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
