@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM URL Shortener Startup Script for Windows
REM Automatically creates virtual environment, installs dependencies, and runs the app

echo 🚀 URL Shortener - Windows Startup Script
echo ========================================

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python is not installed or not in PATH!
    echo Please install Python 3.7+ and try again.
    pause
    exit /b 1
)

echo ✅ Python found: 
python --version

REM Check if pip is installed
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ pip is not installed or not in PATH!
    echo Please install pip and try again.
    pause
    exit /b 1
)

echo ✅ pip found

REM Check if app.py exists
if not exist "app.py" (
    echo ❌ app.py not found in current directory
    echo Please run this script from the url-builder directory
    pause
    exit /b 1
)

REM Check if requirements.txt exists
if not exist "requirements.txt" (
    echo ❌ requirements.txt not found in current directory
    echo Please run this script from the url-builder directory
    pause
    exit /b 1
)

REM Create virtual environment if it doesn't exist
if not exist "venv" (
    echo 📦 Creating virtual environment...
    python -m venv venv
    if %errorlevel% neq 0 (
        echo ❌ Failed to create virtual environment
        pause
        exit /b 1
    )
    echo ✅ Virtual environment created successfully
) else (
    echo 📁 Virtual environment already exists
)

REM Activate virtual environment
echo 🔓 Activating virtual environment...
call venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo ❌ Failed to activate virtual environment
    pause
    exit /b 1
)

echo ✅ Virtual environment activated

REM Check if Flask is installed
python -c "import flask" >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flask is not installed, installing now...
    echo 📥 Installing dependencies...
    pip install -r requirements.txt
    if %errorlevel% neq 0 (
        echo ❌ Failed to install dependencies
        pause
        exit /b 1
    )
    echo ✅ Dependencies installed successfully
) else (
    echo ✅ Flask is installed
)

echo.
echo 🌐 Starting Flask Application...
echo 📱 Open your browser and go to: http://localhost:5000
echo ⏹️  Press Ctrl+C to stop the application
echo ========================================

REM Run the application
python app.py

REM Deactivate virtual environment on exit
call venv\Scripts\deactivate.bat
echo.
echo 👋 Application stopped
pause
