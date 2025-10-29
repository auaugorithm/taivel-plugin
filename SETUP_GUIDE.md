# Taivel App Clip - Complete Setup Guide

This guide will walk you through setting up the complete Taivel App Clip project from scratch.

## Overview

Taivel is an iOS App Clip that demonstrates:
- ✅ Location permission handling (first use only)
- ✅ REST API integration with Convex.dev
- ✅ Clean SwiftUI architecture
- ✅ Success/error handling with visual feedback
- ✅ Sub-3-second network requests
- ✅ App Clip best practices

## Prerequisites

- macOS with Xcode 13+ installed
- iOS device or simulator running iOS 14+
- Node.js 18+ and npm
- Apple Developer account (for deploying to device)
- Convex account (free at https://www.convex.dev)

## Part 1: Convex Backend Setup (15 minutes)

### Step 1: Initialize Convex Project

```bash
cd convex-backend
npm install
```

### Step 2: Start Development Server

```bash
npm run dev
```

This will:
- Create a Convex account (if you don't have one)
- Initialize your project
- Open the Convex dashboard in your browser
- Start watching for changes

### Step 3: Verify Deployment

In the terminal, you should see:
```
✓ Convex project ready
  Dashboard: https://dashboard.convex.dev/...
  Deployment URL: https://xxx-yyy-123.convex.cloud
```

**Copy the deployment URL** - you'll need it for the iOS app!

### Step 4: Test the API (Optional)

Open the Convex dashboard and try the mutation:

```typescript
// In the dashboard's function runner
await ctx.runMutation(api.location.send, {
  latitude: 37.7749,
  longitude: -122.4194
});
```

You should see the data appear in the `locations` table.

## Part 2: iOS App Setup (30 minutes)

### Step 1: Create Xcode Project

1. **Open Xcode** → File → New → Project
2. Choose **App** template
3. Configure:
   - Product Name: `Taivel`
   - Team: Your development team
   - Organization Identifier: `com.yourdomain` (use your domain)
   - Bundle Identifier: `com.yourdomain.taivel`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None**
   - Include Tests: ✓ (optional)

4. **Save** the project to a location on your Mac

### Step 2: Add App Clip Target

1. In Xcode, select your project in the navigator
2. Click **+** at the bottom of the targets list
3. Choose **App Clip**
4. Configure:
   - Product Name: `TaivelAppClip`
   - Bundle Identifier: `com.yourdomain.taivel.Clip`
   - Embed in Application: `Taivel`

5. Click **Activate** when prompted about the scheme

### Step 3: Copy Source Files

Now copy the source files from this repository to your Xcode project:

1. **Delete default files** in App Clip target:
   - `ContentView.swift` (we'll replace it)
   - `TaivelAppClipApp.swift` (we'll replace it)

2. **Create folder structure** in App Clip:
   - Right-click App Clip → New Group → `Models`
   - Right-click App Clip → New Group → `Services`
   - Right-click App Clip → New Group → `Views`
   - Right-click App Clip → New Group → `Resources`

3. **Add files to each group**:

   **Models/**
   - Drag `TaivelAppClip/Models/ConvexResponse.swift` → Models group

   **Services/**
   - Drag `TaivelAppClip/Services/ConvexAPIClient.swift` → Services group
   - Drag `TaivelAppClip/Services/LocationManager.swift` → Services group

   **Views/**
   - Drag `TaivelAppClip/Views/ContentView.swift` → Views group
   - Drag `TaivelAppClip/Views/SuccessView.swift` → Views group

   **Resources/**
   - Drag `TaivelAppClip/Resources/ConvexConfig.swift` → Resources group

   **Root of App Clip:**
   - Drag `TaivelAppClip/TaivelAppClipApp.swift` → App Clip root

4. **When prompted**: Select "Copy items if needed" and target: App Clip only

### Step 4: Configure Info.plist

1. Select the **App Clip's Info.plist** in the navigator
2. Add location permission:
   - Key: `Privacy - Location When In Use Usage Description`
   - Value: `We need your location to send it to our server on first use.`

3. Configure App Clip settings:
   - Right-click Info.plist → Open As → Source Code
   - Copy relevant sections from `TaivelAppClip/Resources/Info.plist`

### Step 5: Configure Entitlements

1. Select the **App Clip target** in project settings
2. Go to **Signing & Capabilities** tab
3. Add capabilities:
   - **+ Capability** → Associated Domains
   - Add domain: `appclips:yourdomain.com` (replace with your domain)

4. For production, you'll need to:
   - Own a domain
   - Host an AASA file (see README.md)

### Step 6: Configure Convex URL

1. Open `ConvexAPIClient.swift`
2. Find line ~15:
   ```swift
   private let baseURL = "https://your-deployment.convex.cloud"
   ```
3. Replace with your actual Convex deployment URL (from Part 1, Step 3)

### Step 7: Build and Test

1. Select **TaivelAppClip** scheme in Xcode
2. Choose a simulator (iPhone 14 or newer recommended)
3. Press **⌘R** to build and run

**First Run:**
- App should launch
- Press "Send Request"
- Location permission prompt appears
- After granting, request is sent to Convex
- Success screen appears

**Second Run:**
- No location permission prompt
- Request sent without location data
- Success screen appears

### Step 8: Verify in Convex Dashboard

1. Open Convex dashboard (https://dashboard.convex.dev)
2. Navigate to your deployment
3. Click **Data** → `locations` table
4. You should see entries:
   - First entry: `isFirstUse: true`, has coordinates
   - Second entry: `isFirstUse: false`, no coordinates

## Part 3: Testing & Debugging

### Reset First-Use Flag

To test first-use behavior again:

**Option 1: Reset simulator**
```
Device → Erase All Content and Settings
```

**Option 2: Add reset button (development only)**
```swift
// In ContentView, add a button:
Button("Reset First Use") {
    LocationManager.shared.resetFirstUseFlag()
}
```

### Test on Physical Device

1. Connect iPhone via USB
2. Select your device in Xcode
3. Trust the development certificate on device
4. Build and run

**Note**: Physical device provides more accurate location data.

### Common Issues

#### "Failed to send request"
- ✓ Check Convex URL in `ConvexAPIClient.swift`
- ✓ Verify Convex backend is deployed (`npm run dev`)
- ✓ Check internet connection

#### Location permission not appearing
- ✓ Verify Info.plist has location usage description
- ✓ Check Settings → Privacy → Location Services
- ✓ Try resetting simulator/device

#### Build errors
- ✓ Ensure all files are added to App Clip target
- ✓ Check Swift version compatibility
- ✓ Clean build folder (⌘⇧K)

## Part 4: Production Deployment

### For Convex Backend

```bash
cd convex-backend
npm run deploy
```

Update the iOS app with the production URL.

### For iOS App Clip

1. **Configure associated domains**:
   - Own a domain
   - Set up AASA file (see README.md)
   - Update entitlements

2. **Create App Clip experience**:
   - Go to App Store Connect
   - Create App Clip Card
   - Configure URL mappings

3. **Submit to App Store**:
   - Archive app (⌘⇧B)
   - Validate and upload
   - Submit for review

## Architecture Overview

```
┌─────────────────────────────────────────┐
│         iOS App Clip (SwiftUI)          │
├─────────────────────────────────────────┤
│  ContentView                            │
│    ├─> LocationManager (first use)      │
│    └─> ConvexAPIClient                  │
│          └─> POST /api/mutation         │
└─────────────────────────────────────────┘
                  │
                  │ HTTPS
                  ▼
┌─────────────────────────────────────────┐
│      Convex Backend (TypeScript)        │
├─────────────────────────────────────────┤
│  location:send mutation                 │
│    └─> Database (locations table)       │
└─────────────────────────────────────────┘
```

## Next Steps

- 📱 Customize the UI design
- 🎨 Add your branding and colors
- 📊 Build a dashboard to view locations
- 🔐 Add authentication
- 🌍 Add map visualization
- 📧 Send notifications on location receive

## Resources

- [Complete README](README.md)
- [Convex Documentation](https://docs.convex.dev)
- [Apple App Clips Guide](https://developer.apple.com/app-clips/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)

## Support

If you encounter issues:
1. Check the troubleshooting section in README.md
2. Review Convex dashboard logs
3. Check Xcode console for errors
4. Verify all configuration steps

Happy coding! 🚀
