#!/bin/bash
# Build script for DOCX2PDF macOS application
# This script should be run on macOS with Xcode installed

set -e

echo "==================================="
echo "DOCX2PDF Build Script"
echo "==================================="
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Error: This script must be run on macOS"
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed"
    echo "Please install Xcode from the Mac App Store"
    exit 1
fi

echo "✓ Running on macOS"
echo "✓ Xcode is installed"
echo ""

# Check if LibreOffice is installed
if [ -f "/Applications/LibreOffice.app/Contents/MacOS/soffice" ]; then
    echo "✓ LibreOffice is installed"
    LIBREOFFICE_VERSION=$(/Applications/LibreOffice.app/Contents/MacOS/soffice --version)
    echo "  Version: $LIBREOFFICE_VERSION"
else
    echo "⚠️  Warning: LibreOffice is not installed at /Applications/LibreOffice.app"
    echo "  The app will require LibreOffice to be installed to function"
    echo "  Download from: https://www.libreoffice.org/download/download/"
fi
echo ""

# Build configuration
BUILD_CONFIG="${1:-Debug}"
echo "Build Configuration: $BUILD_CONFIG"
echo ""

# Clean build folder
echo "🧹 Cleaning build folder..."
rm -rf build/
echo "✓ Clean complete"
echo ""

# Build the project
echo "🔨 Building DOCX2PDF..."
xcodebuild \
    -project DOCX2PDF.xcodeproj \
    -scheme DOCX2PDF \
    -configuration "$BUILD_CONFIG" \
    -derivedDataPath build \
    clean build

if [ $? -eq 0 ]; then
    echo ""
    echo "==================================="
    echo "✅ Build successful!"
    echo "==================================="
    echo ""
    echo "Application location:"
    echo "build/Build/Products/$BUILD_CONFIG/DOCX2PDF.app"
    echo ""
    echo "To run the application:"
    echo "open build/Build/Products/$BUILD_CONFIG/DOCX2PDF.app"
    echo ""
else
    echo ""
    echo "❌ Build failed"
    exit 1
fi
