# Build Guide

Complete guide for building and deploying the Taivel App Clip project.

## 🎯 Quick Summary

**What I've Built for You:**
- ✅ All Swift source code (iOS App Clip)
- ✅ Complete Convex backend (TypeScript)
- ✅ Comprehensive test suite
- ✅ Build automation scripts
- ✅ Project validation tools

**What You Need to Build:**
- 📱 iOS app (requires Xcode on Mac)
- 🌐 Convex backend (can deploy right now!)

---

## ✅ What's Already Built

### Project Validation Status

Run the validation script:
```bash
./validate-build.sh
```

**Current Status:**
```
✅ TaivelAppClip source code (8 files)
✅ Convex backend (3 functions)
✅ Test suite (3 test files)
✅ Configuration files
✅ Documentation (7 guides)
✅ Convex URL configured
✅ Backend dependencies installed
✅ ESLint passing
⚠️  TypeScript (expected errors until first deploy)
```

---

## 🚀 Building the Backend (You Can Do This Now!)

### Option 1: Development Mode (Recommended First)

```bash
cd convex-backend

# Use the dev script
./dev.sh

# Or manually:
npm run dev
```

**What happens:**
- 🌐 Opens Convex dashboard in browser
- 📊 Creates development deployment
- 👀 Watches files for changes
- ✅ Auto-reloads on save

**Your deployment:**
- URL: `https://utmost-clam-977.convex.cloud`
- Dashboard: https://dashboard.convex.dev

### Option 2: Production Deployment

```bash
cd convex-backend

# Use the deploy script
./deploy.sh

# Or manually:
npm run deploy
```

**What happens:**
- 🔍 Runs type checking
- 🧹 Runs linting
- 🧪 Runs tests
- 📡 Deploys to production
- ✅ Creates database schema

### Verify Backend Deployment

```bash
# 1. Check functions exist
# Go to: https://dashboard.convex.dev
# Click: Functions tab
# Verify: location:send mutation exists

# 2. Test the API
curl -X POST https://utmost-clam-977.convex.cloud/api/mutation \
  -H "Content-Type: application/json" \
  -d '{
    "path": "location:send",
    "args": {
      "latitude": 37.7749,
      "longitude": -122.4194
    },
    "format": "json"
  }'

# Expected response:
# {
#   "status": "success",
#   "value": {
#     "id": "...",
#     "message": "Location received successfully",
#     ...
#   }
# }
```

---

## 📱 Building the iOS App (Requires Xcode)

### Prerequisites

- ✅ Mac with Xcode 14+
- ✅ iPhone running iOS 16+ (or simulator)
- ✅ Apple ID (free account works)

### Step-by-Step Build Process

**Complete guide:** [LOCAL_DEVELOPMENT.md](LOCAL_DEVELOPMENT.md)

**Quick steps:**

```bash
# 1. Open Xcode
open -a Xcode

# 2. Create new iOS App project
# File → New → Project → App
# Name: Taivel
# Bundle ID: com.yourname.taivel

# 3. Add App Clip target
# Project → + Target → App Clip
# Name: TaivelAppClip
# Bundle ID: com.yourname.taivel.Clip

# 4. Copy source files
# Drag TaivelAppClip/ folders into Xcode
# Target: ✅ TaivelAppClip only

# 5. Add location permission to Info.plist
# Key: NSLocationWhenInUseUsageDescription
# Value: "We need your location to send it to our server on first use."

# 6. Configure signing
# TaivelAppClip target → Signing & Capabilities
# Team: Your Apple ID
# ✅ Automatically manage signing

# 7. Build and run
# Select: TaivelAppClip scheme
# Device: Your iPhone or simulator
# Press: ⌘R
```

### Build Options

#### Option A: Physical Device (Recommended)

```bash
# Connect iPhone via USB
# Trust computer on iPhone
# Xcode → Select your iPhone
# ⌘R to build and run

# First time: Trust developer certificate
# iPhone → Settings → General → VPN & Device Management
# Tap your Apple ID → Trust
```

#### Option B: Simulator

```bash
# Xcode → Select simulator (iPhone 15)
# ⌘R to build and run

# Note: Simulator limitations:
# - No real location data
# - Can't test true App Clip invocation
# - Good for UI testing only
```

### Verify iOS Build

```bash
# 1. App launches successfully
# 2. Press "Send Request" button
# 3. Location permission prompt appears (first use)
# 4. Tap "Allow While Using App"
# 5. Request completes (see "Sending..." state)
# 6. Success screen appears

# 7. Check Convex dashboard
# Dashboard → Data → locations table
# Verify: Entry with your coordinates appears
```

---

## 🧪 Running Tests

### Backend Tests

```bash
cd convex-backend

# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Watch mode (auto-run on save)
npm run test:watch

# Type checking
npm run typecheck

# Linting
npm run lint
```

### iOS Tests (After Xcode Project Created)

```bash
# Unit tests
xcodebuild test \
  -scheme TaivelAppClip \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# UI tests
xcodebuild test \
  -scheme TaivelAppClip \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:TaivelAppClipUITests

# With coverage
xcodebuild test \
  -scheme TaivelAppClip \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -enableCodeCoverage YES
```

---

## 🛠️ Build Scripts Reference

### Validation Script

```bash
# Validate entire project
./validate-build.sh
```

**Checks:**
- ✅ Project structure
- ✅ All source files exist
- ✅ Convex configuration
- ✅ Backend dependencies
- ✅ Backend code quality (lint, typecheck)
- ✅ Documentation
- ✅ Test files

**Exit codes:**
- `0` - All checks passed
- `0` - Passed with warnings (acceptable)
- `1` - Failed (fix errors)

### Backend Development Script

```bash
cd convex-backend
./dev.sh
```

**Features:**
- 📦 Auto-installs dependencies
- ⚙️ Shows configuration
- 🚀 Starts dev server
- 👀 File watching
- 🌐 Opens dashboard

### Backend Deployment Script

```bash
cd convex-backend
./deploy.sh
```

**Features:**
- 📦 Checks dependencies
- 🔍 Runs validation
- 🧪 Runs tests
- 📡 Deploys to production
- ✅ Shows deployment URL

**Environment variable support:**
```bash
# For CI/CD
export CONVEX_DEPLOY_KEY="your-key"
./deploy.sh
```

---

## 📊 Build Status

### Current Build State

| Component | Status | Notes |
|-----------|--------|-------|
| **iOS Source Code** | ✅ Complete | 8 files, ready to use |
| **Convex Backend** | ✅ Complete | 3 functions, 1 schema |
| **Backend Tests** | ✅ Complete | Unit tests ready |
| **iOS Tests** | ✅ Complete | Unit + UI tests |
| **Configuration** | ✅ Complete | Convex URL configured |
| **Documentation** | ✅ Complete | 7 comprehensive guides |
| **Xcode Project** | ⬜ Not Created | You need to create |
| **Backend Deployed** | ⬜ Not Deployed | Run `./dev.sh` |

### What You Need to Do

```
Priority  Task                           Time    Difficulty
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1        Deploy Convex backend          2 min    ⭐ Easy
2        Create Xcode project           10 min   ⭐⭐ Medium
3        Build iOS app                  5 min    ⭐ Easy
4        Test on device                 5 min    ⭐ Easy
```

---

## 🐛 Build Troubleshooting

### Backend Build Issues

#### "Cannot find module '_generated'"

**Cause:** Haven't run Convex dev/deploy yet
**Fix:**
```bash
cd convex-backend
npm run dev
# Generated files created automatically
```

#### "npm install fails"

**Cause:** Node.js version issue
**Fix:**
```bash
# Check Node version
node --version  # Should be 18+

# Update Node:
# https://nodejs.org/
```

#### "Type errors in tests"

**Cause:** Convex not initialized
**Fix:**
```bash
# Run dev server first
npm run dev
# Then tests will work
npm test
```

### iOS Build Issues

#### "Code signing failed"

**Cause:** No Apple Developer account selected
**Fix:**
```
1. Xcode → Settings → Accounts
2. Add your Apple ID
3. Target → Signing → Select team
4. ✅ Automatically manage signing
```

#### "Build failed: Multiple commands produce"

**Cause:** Target membership conflict
**Fix:**
```
1. Select each source file
2. File Inspector (right panel)
3. Target Membership
4. ✅ TaivelAppClip only
5. ⬜ Uncheck main app
```

#### "App won't install on device"

**Cause:** Trust issue
**Fix:**
```
iPhone:
Settings → General → VPN & Device Management
→ Tap your Apple ID → Trust
```

---

## 🚢 Deployment Checklist

### Development Deployment

- [ ] Backend dependencies installed (`npm install`)
- [ ] Backend dev server running (`./dev.sh`)
- [ ] Xcode project created
- [ ] Source files added to App Clip target
- [ ] Location permission in Info.plist
- [ ] Developer certificate trusted on device
- [ ] App builds without errors (⌘B)
- [ ] App runs on device (⌘R)
- [ ] Location permission prompt appears
- [ ] Network request succeeds
- [ ] Data appears in Convex dashboard

### Production Deployment

- [ ] All dev deployment steps complete
- [ ] Tests passing (`npm test`)
- [ ] Backend deployed to production (`./deploy.sh`)
- [ ] Associated domain configured
- [ ] App Clip entitlements correct
- [ ] Bundle size < 15 MB
- [ ] App Store Connect configured
- [ ] App archived (Product → Archive)
- [ ] Submitted to TestFlight
- [ ] TestFlight approved
- [ ] Ready for App Store submission

---

## 📈 Next Steps

After successful build:

### Immediate (Next 30 minutes)

1. **Deploy backend**: `cd convex-backend && ./dev.sh`
2. **Create Xcode project**: Follow [LOCAL_DEVELOPMENT.md](LOCAL_DEVELOPMENT.md)
3. **Test on device**: Build and run (⌘R)
4. **Verify data flow**: Check Convex dashboard

### Short-term (This week)

1. **Add to React Native app**: See [REACT_NATIVE_INTEGRATION.md](REACT_NATIVE_INTEGRATION.md)
2. **Set up CI/CD**: See [CI_CD.md](CI_CD.md)
3. **Write additional tests**: See [TESTING.md](TESTING.md)
4. **Configure App Clip card**: Production setup

### Long-term (Next month)

1. **TestFlight deployment**
2. **App Store submission**
3. **QR code generation**
4. **Analytics integration**
5. **Production monitoring**

---

## 📚 Related Documentation

- **[LOCAL_DEVELOPMENT.md](LOCAL_DEVELOPMENT.md)** - Detailed iOS build guide
- **[REACT_NATIVE_INTEGRATION.md](REACT_NATIVE_INTEGRATION.md)** - Add to RN app
- **[TESTING.md](TESTING.md)** - Testing guide
- **[CI_CD.md](CI_CD.md)** - Automation setup
- **[CONFIGURATION.md](CONFIGURATION.md)** - Config management

---

## 🎉 Summary

**What's Built:**
- ✅ Complete iOS App Clip source code
- ✅ Full Convex backend
- ✅ Comprehensive tests
- ✅ Build automation
- ✅ Extensive documentation

**What You Build:**
- 📱 Xcode project (10 minutes)
- 🌐 Backend deployment (2 minutes)

**Total Time to Working App:**
~ 20 minutes

**Let's build it!** 🚀

Start with: `cd convex-backend && ./dev.sh`
