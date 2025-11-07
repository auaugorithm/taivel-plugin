#!/bin/bash
# Start Convex development server

set -e  # Exit on error

echo "🔧 Starting Convex Development Server..."
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: Must run from convex-backend directory"
    echo "Usage: cd convex-backend && ./dev.sh"
    exit 1
fi

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    echo ""
fi

# Show current configuration
echo "⚙️  Configuration:"
echo "   Deployment: utmost-clam-977"
echo "   URL: https://utmost-clam-977.convex.cloud"
echo ""

# Start dev server
echo "🚀 Starting development server..."
echo "   - Dashboard will open in your browser"
echo "   - File watching enabled"
echo "   - Functions auto-reload on save"
echo ""
echo "Press Ctrl+C to stop"
echo ""

npm run dev
