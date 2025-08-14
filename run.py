#!/usr/bin/env python3
"""
Startup script for the URL Shortener application
"""

import os
import sys
import subprocess

def check_dependencies():
    """Check if required packages are installed"""
    try:
        import flask
        print("✅ Flask is installed")
        return True
    except ImportError:
        print("❌ Flask is not installed")
        return False

def install_dependencies():
    """Install required dependencies"""
    print("📦 Installing dependencies...")
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "-r", "requirements.txt"])
        print("✅ Dependencies installed successfully!")
        return True
    except subprocess.CalledProcessError:
        print("❌ Failed to install dependencies")
        return False

def main():
    """Main startup function"""
    print("🚀 Starting URL Shortener Application...")
    print("=" * 50)
    
    # Check if dependencies are installed
    if not check_dependencies():
        print("\nInstalling dependencies...")
        if not install_dependencies():
            print("❌ Failed to install dependencies. Please install manually:")
            print("   pip install -r requirements.txt")
            return
        
        # Check again after installation
        if not check_dependencies():
            print("❌ Dependencies still not available after installation")
            return
    
    # Check if app.py exists
    if not os.path.exists("app.py"):
        print("❌ app.py not found in current directory")
        return
    
    print("\n✅ All dependencies are available!")
    print("\n🌐 Starting Flask application...")
    print("📱 Open your browser and go to: http://localhost:5000")
    print("⏹️  Press Ctrl+C to stop the application")
    print("=" * 50)
    
    try:
        # Start the Flask application
        subprocess.run([sys.executable, "app.py"])
    except KeyboardInterrupt:
        print("\n\n👋 Application stopped by user")
    except Exception as e:
        print(f"\n❌ Error starting application: {e}")

if __name__ == "__main__":
    main()
