from flask import Flask, render_template, request, redirect, url_for, flash
import sqlite3
import hashlib
import os
from datetime import datetime

app = Flask(__name__)
app.secret_key = os.urandom(24)

# Database initialization
def init_db():
    conn = sqlite3.connect('urls.db')
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS urls (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            original_url TEXT NOT NULL,
            short_code TEXT UNIQUE NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            clicks INTEGER DEFAULT 0
        )
    ''')
    conn.commit()
    conn.close()

# Generate short code from URL
def generate_short_code(url):
    # Create a hash of the URL and take first 6 characters
    hash_object = hashlib.md5(url.encode())
    return hash_object.hexdigest()[:6]

# Routes
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/shorten', methods=['POST'])
def shorten_url():
    original_url = request.form.get('url')
    
    if not original_url:
        flash('Please enter a valid URL', 'error')
        return redirect(url_for('index'))
    
    # Add http:// if not present
    if not original_url.startswith(('http://', 'https://')):
        original_url = 'https://' + original_url
    
    try:
        short_code = generate_short_code(original_url)
        
        conn = sqlite3.connect('urls.db')
        cursor = conn.cursor()
        
        # Check if URL already exists
        cursor.execute('SELECT short_code FROM urls WHERE original_url = ?', (original_url,))
        existing = cursor.fetchone()
        
        if existing:
            short_code = existing[0]
        else:
            # Insert new URL
            cursor.execute('''
                INSERT INTO urls (original_url, short_code)
                VALUES (?, ?)
            ''', (original_url, short_code))
        
        conn.commit()
        conn.close()
        
        short_url = request.host_url + short_code
        flash(f'URL shortened successfully! Short URL: {short_url}', 'success')
        
    except Exception as e:
        flash('An error occurred while shortening the URL', 'error')
    
    return redirect(url_for('index'))

@app.route('/<short_code>')
def redirect_to_original(short_code):
    conn = sqlite3.connect('urls.db')
    cursor = conn.cursor()
    
    cursor.execute('SELECT original_url FROM urls WHERE short_code = ?', (short_code,))
    result = cursor.fetchone()
    
    if result:
        # Update click count
        cursor.execute('UPDATE urls SET clicks = clicks + 1 WHERE short_code = ?', (short_code,))
        conn.commit()
        conn.close()
        
        return redirect(result[0])
    else:
        conn.close()
        flash('Short URL not found', 'error')
        return redirect(url_for('index'))

@app.route('/stats')
def stats():
    conn = sqlite3.connect('urls.db')
    cursor = conn.cursor()
    
    cursor.execute('''
        SELECT original_url, short_code, created_at, clicks 
        FROM urls 
        ORDER BY created_at DESC
    ''')
    urls = cursor.fetchall()
    conn.close()
    
    return render_template('stats.html', urls=urls)

if __name__ == '__main__':
    init_db()
    app.run(debug=True)
