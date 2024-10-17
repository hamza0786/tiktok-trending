from flask import Flask, jsonify
from TikTokApi import TikTokApi

# Initialize the Flask app
app = Flask(__name__)

# Initialize TikTokApi instance
api = TikTokApi.get_instance()

@app.route('/trending', methods=['GET'])
def get_trending_videos():
    """
    Get trending TikTok videos.
    """
    try:
        trending_videos = api.trending(count=10)
        return jsonify(trending_videos), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/ranked', methods=['GET'])
def get_ranked_videos():
    """
    Get trending videos ranked by likes.
    """
    try:
        trending_videos = api.trending(count=10)
        # Sort videos by likes (diggCount)
        sorted_videos = sorted(trending_videos, key=lambda x: x['stats']['diggCount'], reverse=True)
        return jsonify(sorted_videos), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/video/<string:video_id>', methods=['GET'])
def get_video_details(video_id):
    """
    Get video details by video ID.
    """
    try:
        video_details = api.getTikTokById(video_id)
        return jsonify(video_details), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Run the Flask app
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
