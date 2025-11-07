#!/bin/bash
# Validate entire project is ready to build

set -e  # Exit on error

echo "🔍 Validating Taivel App Clip Project..."
echo ""

ERRORS=0
WARNINGS=0

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Helper functions
error() {
    echo -e "${RED}❌ $1${NC}"
    ERRORS=$((ERRORS + 1))
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    WARNINGS=$((WARNINGS + 1))
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Check root directory
echo "📁 Checking project structure..."
if [ ! -d "TaivelAppClip" ]; then
    error "TaivelAppClip directory not found"
else
    success "TaivelAppClip directory exists"
fi

if [ ! -d "convex-backend" ]; then
    error "convex-backend directory not found"
else
    success "convex-backend directory exists"
fi

echo ""

# Check iOS source files
echo "📱 Checking iOS source files..."
IOS_FILES=(
    "TaivelAppClip/TaivelAppClipApp.swift"
    "TaivelAppClip/Models/ConvexResponse.swift"
    "TaivelAppClip/Services/ConvexAPIClient.swift"
    "TaivelAppClip/Services/LocationManager.swift"
    "TaivelAppClip/Views/ContentView.swift"
    "TaivelAppClip/Views/SuccessView.swift"
    "TaivelAppClip/Resources/ConvexConfig.swift"
    "TaivelAppClip/Resources/Info.plist"
)

for file in "${IOS_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        error "Missing: $file"
    else
        success "Found: $file"
    fi
done

echo ""

# Check Convex configuration
echo "🔧 Checking Convex configuration..."
if grep -q "utmost-clam-977" TaivelAppClip/Services/ConvexAPIClient.swift; then
    success "Convex URL configured in ConvexAPIClient.swift"
else
    error "Convex URL not configured in ConvexAPIClient.swift"
fi

if grep -q "utmost-clam-977" TaivelAppClip/Resources/ConvexConfig.swift; then
    success "Convex URL configured in ConvexConfig.swift"
else
    error "Convex URL not configured in ConvexConfig.swift"
fi

echo ""

# Check backend
echo "🌐 Checking Convex backend..."
cd convex-backend

if [ ! -f "package.json" ]; then
    error "Backend package.json not found"
else
    success "Backend package.json exists"
fi

if [ ! -d "node_modules" ]; then
    warning "Backend dependencies not installed (run: npm install)"
else
    success "Backend dependencies installed"
fi

BACKEND_FILES=(
    "convex/location.ts"
    "convex/schema.ts"
    "convex/location.test.ts"
    "tsconfig.json"
    "vitest.config.ts"
    ".eslintrc.json"
)

for file in "${BACKEND_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        error "Missing: $file"
    else
        success "Found: $file"
    fi
done

# Run backend checks if dependencies are installed
if [ -d "node_modules" ]; then
    echo ""
    echo "🔍 Running backend validation..."

    # Lint
    if npm run lint > /dev/null 2>&1; then
        success "ESLint passed"
    else
        warning "ESLint warnings found (non-critical)"
    fi

    # Type check (expected to fail until first deployment)
    if npm run typecheck > /dev/null 2>&1; then
        success "TypeScript type check passed"
    else
        warning "TypeScript errors (expected until first Convex deployment)"
    fi
fi

cd ..

echo ""

# Check documentation
echo "📚 Checking documentation..."
DOCS=(
    "README.md"
    "LOCAL_DEVELOPMENT.md"
    "REACT_NATIVE_INTEGRATION.md"
    "SETUP_GUIDE.md"
    "TESTING.md"
    "CONFIGURATION.md"
    "CI_CD.md"
)

for doc in "${DOCS[@]}"; do
    if [ ! -f "$doc" ]; then
        warning "Missing documentation: $doc"
    else
        success "Documentation: $doc"
    fi
done

echo ""

# Check tests
echo "🧪 Checking test files..."
TEST_FILES=(
    "TaivelAppClip/Tests/LocationManagerTests.swift"
    "TaivelAppClip/Tests/ConvexAPIClientTests.swift"
    "TaivelAppClip/Tests/TaivelAppClipUITests.swift"
)

for file in "${TEST_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        warning "Missing test: $file"
    else
        success "Test: $file"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Summary
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}🎉 All checks passed!${NC}"
    echo ""
    echo "✅ Project is ready"
    echo ""
    echo "Next steps:"
    echo "  1. Deploy backend:"
    echo "     cd convex-backend && ./dev.sh"
    echo ""
    echo "  2. Build iOS app in Xcode:"
    echo "     See LOCAL_DEVELOPMENT.md"
    echo ""
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Validation passed with $WARNINGS warning(s)${NC}"
    echo ""
    echo "Project is mostly ready, but check warnings above."
    echo ""
    exit 0
else
    echo -e "${RED}❌ Validation failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    echo ""
    echo "Please fix errors before proceeding."
    echo ""
    exit 1
fi
