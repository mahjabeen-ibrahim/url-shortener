#!/bin/bash

# URL Shortener Startup Script
# Automatically detects OS, creates virtual environment, and runs the app

echo "🚀 URL Shortener - Smart Startup Script"
echo "========================================"

# Function to detect operating system
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "🐧 Linux detected"
        OS="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo " macOS detected"
        OS="macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
        echo "🪟 Windows detected"
        OS="windows"
    else
        echo "❓ Unknown OS: $OSTYPE"
        OS="unknown"
    fi
}

# Function to check if Python is installed
check_python() {
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
        echo "✅ Python3 found: $(python3 --version)"
    elif command -v python &> /dev/null; then
        PYTHON_CMD="python"
        echo "✅ Python found: $(python --version)"
    else
        echo "❌ Python is not installed!"
        echo "Please install Python 3.7+ and try again."
        exit 1
    fi
}

# Function to check if pip is installed
check_pip() {
    if command -v pip3 &> /dev/null; then
        PIP_CMD="pip3"
        echo "✅ pip3 found"
    elif command -v pip &> /dev/null; then
        PIP_CMD="pip"
        echo "✅ pip found"
    else
        echo "❌ pip is not installed!"
        echo "Please install pip and try again."
        exit 1
    fi
}

# Function to create virtual environment
create_venv() {
    if [ -d "venv" ]; then
        echo "📁 Virtual environment already exists"
    else
        echo "📦 Creating virtual environment..."
        $PYTHON_CMD -m venv venv
        if [ $? -eq 0 ]; then
            echo "✅ Virtual environment created successfully"
        else
            echo "❌ Failed to create virtual environment"
            exit 1
        fi
    fi
}

# Function to activate virtual environment
activate_venv() {
    echo "🔓 Activating virtual environment..."
    
    if [ "$OS" = "windows" ]; then
        source venv/Scripts/activate
    else
        source venv/bin/activate
    fi
    
    if [ $? -eq 0 ]; then
        echo "✅ Virtual environment activated"
        echo "🐍 Python path: $(which python)"
    else
        echo "❌ Failed to activate virtual environment"
        exit 1
    fi
}

# Function to install dependencies
install_deps() {
    echo "📥 Installing dependencies..."
    $PIP_CMD install -r requirements.txt
    
    if [ $? -eq 0 ]; then
        echo "✅ Dependencies installed successfully"
    else
        echo "❌ Failed to install dependencies"
        exit 1
    fi
}

# Function to check if Flask is installed
check_flask() {
    python -c "import flask" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ Flask is installed"
    else
        echo "❌ Flask is not installed, installing now..."
        install_deps
    fi
}

# Function to run the application
run_app() {
    echo ""
    echo "🌐 Starting Flask Application..."
    echo "📱 Open your browser and go to: http://localhost:5000"
    echo "⏹️  Press Ctrl+C to stop the application"
    echo "========================================"
    
    python app.py
}

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "👋 Shutting down..."
    if [ -n "$VIRTUAL_ENV" ]; then
        deactivate
        echo "🔒 Virtual environment deactivated"
    fi
    exit 0
}

# Set trap for cleanup
trap cleanup SIGINT SIGTERM

# Main execution
main() {
    # Detect OS
    detect_os
    
    # Check Python
    check_python
    
    # Check pip
    check_pip
    
    # Create virtual environment
    create_venv
    
    # Activate virtual environment
    activate_venv
    
    # Check Flask
    check_flask
    
    # Run the application
    run_app
}

# Check if app.py exists
if [ ! -f "app.py" ]; then
    echo "❌ app.py not found in current directory"
    echo "Please run this script from the url-builder directory"
    exit 1
fi

# Check if requirements.txt exists
if [ ! -f "requirements.txt" ]; then
    echo "❌ requirements.txt not found in current directory"
    echo "Please run this script from the url-builder directory"
    exit 1
fi

# Run main function
main
