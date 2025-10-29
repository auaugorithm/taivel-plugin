# Local Development Guide - Running on Your iPhone

Complete guide to run the Taivel App Clip on your physical iPhone device.

## Prerequisites

- ✅ Mac with Xcode 14+ installed
- ✅ iPhone running iOS 16+ (physical device)
- ✅ USB cable to connect iPhone to Mac
- ✅ Apple ID (free account works for development)
- ✅ This repository cloned locally

## Part 1: Create the Xcode Project (10 minutes)

### Step 1: Open Xcode

```bash
# Make sure you're in the project directory
cd /path/to/taivel-plugin

# Launch Xcode
open -a Xcode
```

### Step 2: Create New Project

1. **Xcode** → **File** → **New** → **Project**
2. Choose template:
   - Platform: **iOS**
   - Template: **App**
   - Click **Next**

3. Configure project:
   ```
   Product Name: Taivel
   Team: [Select your Apple ID team]
   Organization Identifier: com.yourusername
   Bundle Identifier: com.yourusername.taivel (auto-generated)
   Interface: SwiftUI
   Language: Swift
   Storage: None
   ☑ Include Tests
   ```

4. **Save location**: Choose the `taivel-plugin` directory
   - ⚠️ **IMPORTANT**: Save it IN the same folder as the source files
   - The structure should be:
     ```
     taivel-plugin/
     ├── Taivel.xcodeproj/     ← NEW
     ├── Taivel/               ← NEW (main app folder)
     ├── TaivelAppClip/        ← EXISTING (our source code)
     └── convex-backend/
     ```

### Step 3: Add App Clip Target

1. Select **Taivel** project in navigator (top item)
2. At bottom of targets list, click **+** button
3. Search for **"App Clip"**
4. Click **App Clip** → **Next**
5. Configure:
   ```
   Product Name: TaivelAppClip
   Team: [Same as main app]
   Bundle Identifier: com.yourusername.taivel.Clip (auto-generated)
   Embed in Application: Taivel
   ```
6. Click **Finish**
7. Click **Activate** when prompted about the scheme

### Step 4: Copy Source Files

Now we'll replace the default files with our implementation:

#### A. Delete Default App Clip Files

In the **TaivelAppClip** folder (the one Xcode just created):
- Right-click `ContentView.swift` → Delete → **Move to Trash**
- Right-click `TaivelAppClipApp.swift` → Delete → **Move to Trash**

#### B. Add Our Source Files

**Method 1: Drag and Drop (Recommended)**

1. Open Finder and navigate to `taivel-plugin/TaivelAppClip/`
2. In Xcode project navigator, right-click **TaivelAppClip** folder
3. Select **Add Files to "Taivel"...**
4. Navigate to `taivel-plugin/TaivelAppClip/`
5. Select these folders/files:
   - `Models/`
   - `Services/`
   - `Views/`
   - `Resources/` (except Info.plist if it conflicts)
   - `TaivelAppClipApp.swift`
6. **Options (Important)**:
   - ☑ **Copy items if needed**
   - ☑ **Create groups**
   - Target Membership: ☑ **TaivelAppClip** (only)
   - ☐ Taivel (uncheck main app)
7. Click **Add**

**Method 2: Manual Copy**

```bash
# From terminal in taivel-plugin directory:

# Copy to Xcode's TaivelAppClip folder
cp -r TaivelAppClip/Models Taivel/TaivelAppClip/
cp -r TaivelAppClip/Services Taivel/TaivelAppClip/
cp -r TaivelAppClip/Views Taivel/TaivelAppClip/
cp -r TaivelAppClip/Resources Taivel/TaivelAppClip/
cp TaivelAppClip/TaivelAppClipApp.swift Taivel/TaivelAppClip/

# Then in Xcode: File → Add Files to "Taivel"
# Navigate to Taivel/TaivelAppClip and add all folders
```

### Step 5: Configure Info.plist

1. In Xcode navigator, select **TaivelAppClip** → **Info.plist**
2. Add location permission:
   - Click **+** button (or right-click → Add Row)
   - Key: **Privacy - Location When In Use Usage Description**
   - Type: String
   - Value: `We need your location to send it to our server on first use.`

3. Verify these keys exist (Xcode may have added them):
   - `CFBundleDisplayName` = "Taivel"
   - `UIApplicationSceneManifest` (for SwiftUI support)

### Step 6: Build the Project

1. Select scheme: **TaivelAppClip** (top bar, left of device selector)
2. Select device: **Any iOS Device** (or your iPhone if connected)
3. Press **⌘B** to build
4. Fix any errors (likely file references or imports)

**Common Build Errors:**

```swift
// If you see "Cannot find 'AnyCodable' in scope"
// Make sure ConvexResponse.swift is added to target

// If you see "No such module 'CoreLocation'"
// Add CoreLocation framework:
// Target → Build Phases → Link Binary With Libraries → + → CoreLocation.framework
```

---

## Part 2: Run on Physical iPhone (5 minutes)

### Step 1: Connect iPhone

1. Connect iPhone to Mac via USB cable
2. **iPhone**: Tap **Trust This Computer**
3. Enter iPhone passcode

### Step 2: Configure Signing

1. Select **TaivelAppClip** target
2. Go to **Signing & Capabilities** tab
3. Configure:
   ```
   ☑ Automatically manage signing
   Team: [Select your Apple ID]
   Signing Certificate: Apple Development
   Provisioning Profile: [Auto-generated]
   ```

4. **Important**: Do the same for **Taivel** (main app) target
   - Main app must be signed to embed App Clip

**If you see signing errors:**
- Go to Xcode → Settings → Accounts
- Click **+** → Add Apple ID
- Sign in with your Apple ID
- Select your account → Click refresh button

### Step 3: Build and Run

1. **Select device**: Click device selector (top bar) → Select your iPhone by name
2. **Run**: Press **⌘R** (or click ▶️ play button)
3. **Wait**: Xcode will:
   - Build the app
   - Install on your iPhone
   - Launch the App Clip

**First Time Setup (iPhone):**

1. iPhone will show: **"Untrusted Developer"**
2. Go to **Settings** → **General** → **VPN & Device Management**
3. Tap your Apple ID
4. Tap **Trust "[Your Name]"**
5. Confirm **Trust**
6. Go back to Xcode and run again (⌘R)

### Step 4: Test the App Clip

The app should launch on your iPhone:

1. ✅ See "Taivel" title
2. ✅ See "Send Request" button
3. ✅ Press button
4. ✅ Location permission prompt appears
5. ✅ Tap "Allow While Using App"
6. ✅ Wait for request (you'll see "Sending..." state)
7. ✅ Success screen appears!

**Debugging on Device:**

- View console logs: Xcode → View → Debug Area → Show Debug Area
- Look for `📍` location logs and `🌐` network logs
- Check for errors in red

---

## Part 3: Testing App Clip Invocation (Advanced)

App Clips can be invoked in several ways. For local development:

### Option 1: Direct Launch (What We Just Did)

**Pros:**
- ✅ Easiest for development
- ✅ Full debugging support
- ✅ Works immediately

**Cons:**
- ❌ Not the real App Clip experience
- ❌ Launches as a separate app

### Option 2: Local Experiences (Xcode 16+)

1. **Configure Associated Domain:**
   - TaivelAppClip target → Signing & Capabilities
   - **+ Capability** → **Associated Domains**
   - Add domain: `appclips:yourdomain.com`
   - (Use a domain you control, even for testing)

2. **Create Local Experience:**
   - Xcode → **Configure App Clip Experiences**
   - Click **+** → **Add Local Experience**
   - URL: `https://yourdomain.com/clip`
   - Title: "Taivel Location"
   - Subtitle: "Share your location"
   - Click **Add**

3. **Test:**
   - Run app on device (⌘R)
   - Open Notes app on iPhone
   - Type the URL: `https://yourdomain.com/clip`
   - Tap the link → App Clip card should appear

### Option 3: QR Code (Production Setup)

For a real App Clip experience, you need:

1. **Host Apple App Site Association (AASA) file:**

```json
// At https://yourdomain.com/.well-known/apple-app-site-association
{
  "appclips": {
    "apps": [
      "TEAMID.com.yourusername.taivel.Clip"
    ]
  }
}
```

2. **Generate QR Code:**
   - Use App Store Connect to create App Clip experience
   - Generate QR code for testing
   - Scan with iPhone camera → App Clip loads

### Option 4: Simulator Testing (Quick Testing)

While you can't test true App Clip invocation in Simulator, you can test functionality:

```bash
# Build for Simulator
1. Select scheme: TaivelAppClip
2. Select device: iPhone 15 (or any simulator)
3. Press ⌘R
```

**Simulator Limitations:**
- ❌ No real location data (can simulate)
- ❌ No App Clip card experience
- ✅ Can test UI and logic
- ✅ Faster iteration

---

## Part 4: Deploy Convex Backend

For the app to actually work, deploy your backend:

### Step 1: Install Dependencies

```bash
cd taivel-plugin/convex-backend
npm install
```

### Step 2: Start Development Server

```bash
npm run dev
```

**What happens:**
- Opens Convex dashboard in browser
- Creates development deployment
- Watches for changes
- Outputs deployment URL (already configured: `https://utmost-clam-977.convex.cloud`)

### Step 3: Verify Functions

In the Convex dashboard:
1. Go to **Functions** tab
2. Verify `location:send` mutation exists
3. Go to **Data** tab
4. Verify `locations` table exists

### Step 4: Test from iOS App

1. Make sure backend is running (`npm run dev`)
2. Run iOS app on your iPhone
3. Press "Send Request"
4. Check Convex dashboard → **Data** → **locations**
5. See your location entry!

---

## Part 5: Troubleshooting

### "Build Failed" in Xcode

**Check:**
- ✅ All source files added to TaivelAppClip target
- ✅ Target membership is correct (select file → File Inspector → Target Membership)
- ✅ Info.plist has location permission
- ✅ No duplicate files

**Fix:**
```bash
# Clean build folder
Xcode → Product → Clean Build Folder (⌘⇧K)
# Then build again (⌘B)
```

### "Could not launch" on Device

**Reason:** Developer trust not enabled

**Fix:**
1. Settings → General → VPN & Device Management
2. Tap your Apple ID → Trust
3. Try again in Xcode

### "Network request failed"

**Check:**
- ✅ iPhone has internet connection (WiFi or cellular)
- ✅ Convex backend is running (`npm run dev`)
- ✅ URL is correct: `https://utmost-clam-977.convex.cloud`

**Debug:**
```swift
// In ConvexAPIClient.swift, add logging:
print("🌐 Request URL: \(url)")
print("📦 Payload: \(payload)")

// Check Xcode console for output
```

### "Location permission not appearing"

**Check:**
- ✅ Info.plist has `NSLocationWhenInUseUsageDescription`
- ✅ Running on physical device (not simulator for real location)
- ✅ Location Services enabled: Settings → Privacy → Location Services

**Reset permissions:**
```bash
Settings → General → Transfer or Reset iPhone → Reset → Reset Location & Privacy
```

### "App Clip too large"

App Clips must be < 15 MB when invoked via QR code.

**Check size:**
1. Archive the app: Product → Archive
2. View in Organizer → Distribute → App Clip Size Report

**Reduce size:**
- Remove unused assets
- Use `@3x` images only for App Clip
- Lazy load resources

### "No Xcode project file"

If you skipped Part 1:

```bash
# The .xcodeproj file is NOT in the repository
# You MUST create it following Part 1 above
```

---

## Quick Start Summary

**Absolute minimum to run on your iPhone:**

```bash
# 1. Clone repo (if not already)
git clone [your-repo-url]
cd taivel-plugin

# 2. Start backend
cd convex-backend
npm install
npm run dev
# Keep this terminal open!

# 3. In another terminal / Xcode:
# - Open Xcode
# - Create new project (Part 1, Steps 1-2)
# - Add App Clip target (Part 1, Step 3)
# - Copy source files (Part 1, Step 4)
# - Configure Info.plist (Part 1, Step 5)
# - Build (⌘B)
# - Connect iPhone
# - Trust developer (Part 2, Step 3)
# - Run (⌘R)

# 4. On iPhone:
# - Trust developer (Settings → General → VPN & Device Management)
# - Run app again
# - Press "Send Request"
# - Allow location
# - See success!

# 5. Verify:
# - Check Convex dashboard → Data → locations
# - See your location entry!
```

---

## File Structure After Setup

```
taivel-plugin/
├── Taivel.xcodeproj/              ← You created this
│   └── project.pbxproj
├── Taivel/                         ← Xcode created this (main app)
│   ├── TaivelApp.swift
│   ├── ContentView.swift
│   └── Assets.xcassets
├── TaivelAppClip/                  ← Our implementation (copied in)
│   ├── Models/
│   │   └── ConvexResponse.swift
│   ├── Services/
│   │   ├── ConvexAPIClient.swift
│   │   └── LocationManager.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   └── SuccessView.swift
│   ├── Resources/
│   │   ├── ConvexConfig.swift
│   │   └── Info.plist
│   └── TaivelAppClipApp.swift
├── convex-backend/                 ← Backend functions
│   ├── convex/
│   │   ├── location.ts
│   │   └── schema.ts
│   └── package.json
└── [documentation files]
```

---

## Next Steps

After successfully running on your iPhone:

1. ✅ **Test first use:** Location permission + coordinates sent
2. ✅ **Test second use:** No permission prompt + empty coordinates
3. ✅ **Verify in dashboard:** Check Convex data
4. ⬜ **Set up App Clip card:** Follow Part 3 for real invocation
5. ⬜ **Configure CI/CD:** See CI_CD.md
6. ⬜ **Deploy to TestFlight:** Use Xcode Archive

---

## Resources

- **Xcode Help:** Help → Xcode Help (in Xcode)
- **App Clip Docs:** https://developer.apple.com/app-clips/
- **Convex Dashboard:** https://dashboard.convex.dev
- **This Project's Docs:** See README.md, SETUP_GUIDE.md, TESTING.md

---

**Questions?** Drop a comment in the repo or check the docs!

🎉 **Happy Coding!**
