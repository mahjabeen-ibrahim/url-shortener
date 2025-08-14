# URL Shortener

A clean, modern URL shortening web application built with Flask, HTML, and CSS.

## Features

- **URL Shortening**: Convert long URLs into short, shareable links
- **Click Tracking**: Monitor how many times each shortened URL is accessed
- **Statistics Dashboard**: View detailed analytics of all shortened URLs
- **Responsive Design**: Works perfectly on desktop, tablet, and mobile devices
- **Clean UI**: Modern, intuitive interface with smooth animations
- **SQLite Database**: Lightweight database for storing URL data


## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/mahjabeen-ibrahim/url-shortener.git
   cd url-builder
   ```

2. **Make startup scripts executable** (Linux/macOS only):
   ```bash
   chmod +x start start.sh
   ```

3. **Run the application** (choose one method):
   - **Universal (recommended)**: `./start`
   - **Linux/macOS**: `./start.sh`
   - **Windows**: `start.bat`
   - **Manual**: Follow the manual setup below

### Manual Setup (if scripts don't work)

1. **Create a virtual environment** (recommended):
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

## Usage

### **Option 1: Universal Startup (Recommended)**
```bash
./start
```
This script automatically detects your OS and runs the appropriate startup method.

### **Option 2: OS-Specific Scripts**
**For Linux/macOS:**
```bash
./start.sh
```

**For Windows:**
```cmd
start.bat
```

### **Option 3: Manual Setup**
1. **Run the application**:
   ```bash
   python app.py
   ```

2. **Open your browser** and navigate to:
   ```
   http://localhost:5000
   ```

3. **Shorten URLs**:
   - Enter any long URL in the input field
   - Click "Shorten" to generate a short link
   - Copy and share the shortened URL



## How It Works

- **URL Processing**: Automatically adds `https://` if no protocol is specified
- **Hash Generation**: Creates unique 6-character codes using MD5 hashing
- **Database Storage**: Stores original URLs, short codes, creation dates, and click counts
- **Redirect System**: Shortened URLs automatically redirect to original destinations
- **Click Tracking**: Increments counter each time a shortened URL is accessed

## Project Structure

```
url-builder/
├── app.py              # Main Flask application
├── requirements.txt    # Python dependencies
├── README.md          # This file
├── start              # Universal startup script (auto-detects OS)
├── start.sh           # Linux/macOS startup script
├── start.bat          # Windows startup script
├── run.py             # Python startup script
├── templates/         # HTML templates
│   ├── index.html     # Main page
│   └── stats.html     # Statistics page
└── static/            # Static files
    └── style.css      # CSS styles
```

## API Endpoints

- `GET /` - Main page with URL shortening form
- `POST /shorten` - Create shortened URL
- `GET /<short_code>` - Redirect to original URL
- `GET /stats` - View URL statistics

## Database Schema

The application uses SQLite with the following table structure:

```sql
CREATE TABLE urls (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    original_url TEXT NOT NULL,
    short_code TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    clicks INTEGER DEFAULT 0
);
```

## Customization

- **Colors**: Modify the CSS variables in `static/style.css`
- **Short Code Length**: Change the `[:6]` slice in `generate_short_code()` function
- **Database**: Switch to PostgreSQL or MySQL by modifying database connection code
- **Styling**: Customize the design by editing the CSS file

## Security Features

- Input validation and sanitization
- SQL injection prevention using parameterized queries
- Secure random secret key generation
- HTTPS protocol enforcement

## Browser Compatibility

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source and available under the MIT License.

## Support

If you encounter any issues or have questions, please open an issue on the repository.

---

Built with ❤️ using Flask, HTML, and CSS
