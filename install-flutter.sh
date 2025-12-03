#!/bin/bash
# Flutter SDK Installation Script for Ubuntu/Linux
# Purpose: Automate Flutter SDK setup for Delivery App development
# Sprint 0: Local Development Environment Setup

set -e  # Exit on error

echo "🚀 Installing Flutter SDK..."

# Variables
FLUTTER_VERSION="stable"
INSTALL_DIR="$HOME/development"
FLUTTER_DIR="$INSTALL_DIR/flutter"

# Create installation directory
echo "📁 Creating installation directory..."
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Download Flutter SDK
if [ ! -d "$FLUTTER_DIR" ]; then
    echo "⬇️  Downloading Flutter SDK ($FLUTTER_VERSION channel)..."
    git clone https://github.com/flutter/flutter.git -b $FLUTTER_VERSION
else
    echo "✅ Flutter directory already exists, updating..."
    cd "$FLUTTER_DIR"
    git pull
    cd "$INSTALL_DIR"
fi

# Add Flutter to PATH (if not already added)
SHELL_RC=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "flutter/bin" "$SHELL_RC"; then
        echo ""  >> "$SHELL_RC"
        echo "# Flutter SDK" >> "$SHELL_RC"
        echo "export PATH=\"\$PATH:$FLUTTER_DIR/bin\"" >> "$SHELL_RC"
        echo "✅ Added Flutter to PATH in $SHELL_RC"
    else
        echo "✅ Flutter already in PATH"
    fi
fi

# Temporarily add to current session
export PATH="$PATH:$FLUTTER_DIR/bin"

# Run Flutter doctor to download SDK components
echo "🔧 Running flutter doctor..."
"$FLUTTER_DIR/bin/flutter" doctor

# Accept Android licenses (if Android SDK is installed)
if command -v sdkmanager &> /dev/null; then
    echo "📱 Accepting Android licenses..."
    yes | "$FLUTTER_DIR/bin/flutter" doctor --android-licenses || true
fi

echo ""
echo "✅ Flutter SDK installation complete!"
echo ""
echo "📋 Next steps:"
echo "1. Reload your shell: source $SHELL_RC"
echo "2. Verify installation: flutter --version"
echo "3. Run full diagnostics: flutter doctor -v"
echo ""
echo "🔧 To enable web support:"
echo "   flutter config --enable-web"
echo ""
echo "📱 To setup Android development:"
echo "   - Install Android Studio from: https://developer.android.com/studio"
echo "   - Run: flutter doctor --android-licenses"
echo ""
