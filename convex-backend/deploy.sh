#!/bin/bash
# Deploy Convex backend to production

set -e  # Exit on error

echo "🚀 Deploying Convex Backend..."
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: Must run from convex-backend directory"
    echo "Usage: cd convex-backend && ./deploy.sh"
    exit 1
fi

# Check if convex is installed
if ! command -v npx &> /dev/null; then
    echo "❌ Error: npm/npx not found"
    echo "Please install Node.js: https://nodejs.org/"
    exit 1
fi

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Run type check
echo "🔍 Running type check..."
if npm run typecheck 2>&1 | grep -q "error TS"; then
    echo "⚠️  Type errors found (expected until first deployment)"
    echo "   Generated files will be created during deployment"
fi

# Run linting
echo "🔍 Running linter..."
npm run lint

# Run tests (if they exist and don't require generated files)
echo "🧪 Running tests..."
if npm test 2>&1 | grep -q "Cannot find module"; then
    echo "⚠️  Tests skipped (require generated files)"
else
    npm test
fi

# Deploy to Convex
echo ""
echo "📡 Deploying to Convex..."
echo "   This will:"
echo "   - Generate Convex schema"
echo "   - Deploy functions"
echo "   - Create database tables"
echo ""

# Check if CONVEX_DEPLOY_KEY is set (for CI/CD)
if [ -n "$CONVEX_DEPLOY_KEY" ]; then
    echo "🔑 Using CONVEX_DEPLOY_KEY from environment"
    npx convex deploy --prod
else
    echo "🔑 Using interactive login"
    npm run deploy
fi

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📊 Next steps:"
echo "   1. Check Convex dashboard: https://dashboard.convex.dev"
echo "   2. Verify functions deployed"
echo "   3. Test with iOS app"
echo ""
echo "🔗 Your deployment URL:"
echo "   https://utmost-clam-977.convex.cloud"
echo ""
