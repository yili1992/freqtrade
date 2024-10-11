import requests
from flask import Flask, jsonify, render_template, request


app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/get_depth', methods=['POST'])
def get_depth():
    symbol = request.form['symbol']
    response = requests.get(f'https://api.binance.com/api/v3/depth?symbol={symbol.upper()}&limit=5000')
    if response.status_code == 200:
        return jsonify(response.json())
    else:
        return jsonify({"error": "Failed to fetch data"}), 400


if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0')
