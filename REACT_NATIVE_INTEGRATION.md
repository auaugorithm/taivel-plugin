# React Native Integration Guide

How to add the Taivel App Clip to your existing React Native project.

## Overview

There are **three approaches** to integrate this App Clip with React Native:

| Approach | Size | Performance | Complexity | Recommended? |
|----------|------|-------------|------------|--------------|
| **1. Native Swift App Clip** | ✅ Smallest | ✅ Fastest | ⚠️ Medium | ✅ **YES** |
| **2. React Native App Clip** | ❌ Large | ⚠️ Slower | ❌ Complex | ❌ No |
| **3. Hybrid (RN Bridge)** | ⚠️ Medium | ⚠️ Medium | ❌ Very Complex | ⚠️ Maybe |

**TL;DR:** Keep the App Clip as **native Swift** (our current implementation) and add it to your existing React Native app. This is Apple's recommended approach.

---

## Why Native Swift App Clip is Best

### Size Constraints

App Clips have strict size limits:
- **QR Code/NFC invocation:** < 15 MB
- **Safari/Messages:** < 50 MB

React Native bundle sizes:
- **RN Core:** ~5-8 MB (uncompressed)
- **With typical dependencies:** 15-30+ MB
- **Problem:** May exceed App Clip size limit

### Performance

- ✅ **Native Swift:** Instant launch, smooth animations
- ⚠️ **React Native:** JS bundle load time, bridge overhead
- **App Clips need:** Sub-second launch times

### Apple's Recommendation

From Apple docs:
> "Keep your App Clip as lightweight as possible. Consider using native code for App Clips even if your main app uses cross-platform frameworks."

---

## Approach 1: Native Swift App Clip (Recommended)

This approach keeps our current Swift implementation and integrates it into your RN project.

### Architecture

```
YourReactNativeApp/
├── ios/
│   ├── YourApp/                    ← Your RN app
│   │   ├── AppDelegate.mm
│   │   ├── main.m
│   │   └── Info.plist
│   ├── YourApp.xcodeproj
│   └── TaivelAppClip/              ← NEW: Our Swift App Clip
│       ├── Models/
│       ├── Services/
│       ├── Views/
│       └── TaivelAppClipApp.swift
├── android/
├── src/                            ← Your RN JavaScript code
└── package.json
```

### Step-by-Step Integration

#### Step 1: Open Your RN Project in Xcode

```bash
cd YourReactNativeApp
cd ios
open YourApp.xcworkspace  # Or .xcodeproj
```

#### Step 2: Add App Clip Target

1. In Xcode, select your project (top of navigator)
2. Click **+** at bottom of Targets list
3. Choose **App Clip** template
4. Configure:
   ```
   Product Name: TaivelAppClip
   Team: [Your team]
   Bundle Identifier: com.yourcompany.yourapp.Clip
   Embed in Application: YourApp
   ```
5. Click **Finish** → **Activate**

#### Step 3: Copy App Clip Source Files

```bash
# From the taivel-plugin directory to your RN project
cd /path/to/taivel-plugin

# Copy to your RN iOS directory
cp -r TaivelAppClip/Models /path/to/YourReactNativeApp/ios/TaivelAppClip/
cp -r TaivelAppClip/Services /path/to/YourReactNativeApp/ios/TaivelAppClip/
cp -r TaivelAppClip/Views /path/to/YourReactNativeApp/ios/TaivelAppClip/
cp -r TaivelAppClip/Resources /path/to/YourReactNativeApp/ios/TaivelAppClip/
cp TaivelAppClip/TaivelAppClipApp.swift /path/to/YourReactNativeApp/ios/TaivelAppClip/
```

#### Step 4: Add Files to Xcode

1. Right-click **TaivelAppClip** folder in Xcode
2. **Add Files to "YourApp"...**
3. Select the copied folders
4. ✅ **Copy items if needed**
5. ✅ **Create groups**
6. Target: ✅ **TaivelAppClip** only

#### Step 5: Configure Info.plist

Add location permission to App Clip's Info.plist:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to send it to our server on first use.</string>
```

#### Step 6: Configure Signing

1. Select **TaivelAppClip** target
2. **Signing & Capabilities**
3. ✅ Automatically manage signing
4. Team: [Your Apple Developer Team]
5. Add capability: **Associated Domains**
   - Add: `appclips:yourdomain.com`

#### Step 7: Build and Test

```bash
# Select TaivelAppClip scheme in Xcode
# Select your device
# Press ⌘R

# The App Clip will launch independently
# Your main RN app is unchanged
```

#### Step 8: Share Data Between RN App and App Clip (Optional)

If you want to share data:

**A. Using App Groups:**

1. Main app target → Signing & Capabilities → + Capability → App Groups
2. Add group: `group.com.yourcompany.yourapp`
3. App Clip target → Add same App Groups capability
4. Add same group ID

**In App Clip (Swift):**
```swift
// Save data
let defaults = UserDefaults(suiteName: "group.com.yourcompany.yourapp")
defaults?.set("value", forKey: "sharedKey")

// Read data
let value = defaults?.string(forKey: "sharedKey")
```

**In RN App (JavaScript):**
```javascript
// Use react-native-shared-group-preferences
import SharedGroupPreferences from 'react-native-shared-group-preferences';

const appGroupIdentifier = 'group.com.yourcompany.yourapp';

// Save
await SharedGroupPreferences.setItem('sharedKey', 'value', appGroupIdentifier);

// Read
const value = await SharedGroupPreferences.getItem('sharedKey', appGroupIdentifier);
```

**B. Using Universal Links:**

App Clip can open your main RN app with data:

```swift
// In App Clip success screen
if let url = URL(string: "yourapp://location?lat=\(lat)&lng=\(lng)") {
    UIApplication.shared.open(url)
}
```

In RN app, handle deep link:
```javascript
import { Linking } from 'react-native';

Linking.addEventListener('url', (event) => {
  // Parse event.url
  // Extract lat, lng parameters
});
```

### Advantages of This Approach

✅ **Size:** App Clip stays under 15 MB
✅ **Performance:** Native Swift speed
✅ **Isolation:** App Clip doesn't affect main app
✅ **Updates:** Update App Clip independently
✅ **Apple's recommendation**

### Disadvantages

❌ **Code duplication:** Can't reuse RN components
❌ **Two codebases:** Swift for App Clip, JS for main app
⚠️ **Different styling:** Manual design matching

---

## Approach 2: React Native App Clip (Not Recommended)

Use React Native for the App Clip itself. **Warning:** Complex and may exceed size limits.

### When to Consider This

- Your RN bundle is already small (<10 MB)
- You have minimal dependencies
- You need to share complex business logic
- Performance is not critical

### Requirements

- React Native 0.63+
- metro-config adjustments
- Separate JS bundle for App Clip
- Custom native bridge setup

### High-Level Steps

1. **Create App Clip target** (same as Approach 1)

2. **Configure Metro bundler** for App Clip:

```javascript
// metro.config.js
module.exports = {
  transformer: {
    // ... existing config
  },
  resolver: {
    // ... existing config
  },
  // Add App Clip entry point
  serializer: {
    createModuleIdFactory: () => (path) => {
      // Custom module ID for App Clip
    },
  },
};
```

3. **Create separate entry point:**

```javascript
// appClip.js
import { AppRegistry } from 'react-native';
import AppClipRoot from './src/AppClipRoot';

AppRegistry.registerComponent('TaivelAppClip', () => AppClipRoot);
```

4. **Build separate bundle:**

```bash
# Build App Clip JS bundle
npx react-native bundle \
  --platform ios \
  --dev false \
  --entry-file appClip.js \
  --bundle-output ios/TaivelAppClip/main.jsbundle \
  --assets-dest ios/TaivelAppClip
```

5. **Configure App Clip target in Xcode:**

```swift
// AppClipDelegate.swift
import UIKit
import React

@UIApplicationMain
class AppClipDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var bridge: RCTBridge!

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let jsCodeLocation = RCTBundleURLProvider.sharedSettings().jsBundleURL(
      forBundleRoot: "appClip"
    )

    let rootView = RCTRootView(
      bundleURL: jsCodeLocation,
      moduleName: "TaivelAppClip",
      initialProperties: nil,
      launchOptions: launchOptions
    )

    self.window = UIWindow(frame: UIScreen.main.bounds)
    let rootViewController = UIViewController()
    rootViewController.view = rootView
    self.window?.rootViewController = rootViewController
    self.window?.makeKeyAndVisible()

    return true
  }
}
```

### Problems with This Approach

❌ **Size bloat:** RN core + dependencies easily exceed 15 MB
❌ **Performance:** Slower launch time
❌ **Complexity:** Build system gets complicated
❌ **Two bundles:** Maintain separate JS bundles
❌ **Not recommended by Apple or React Native team**

### Optimization Techniques (If You Proceed)

```javascript
// Use Hermes engine for smaller bundles
// ios/Podfile
use_react_native!(
  :path => config[:reactNativePath],
  :hermes_enabled => true // Enable Hermes
)

// Strip unused code
// babel.config.js
module.exports = {
  presets: ['module:metro-react-native-babel-preset'],
  plugins: [
    ['transform-remove-console', { exclude: ['error', 'warn'] }],
  ],
};

// Only include essential dependencies in App Clip bundle
```

---

## Approach 3: Hybrid - Share Logic via Native Modules

Use React Native for business logic, native Swift for UI.

### Architecture

```
Main RN App (JS) → Native Module → App Clip (Swift)
     ↓                                    ↓
  Business Logic ←――――――――――――→  Shared Logic (Native)
```

### Implementation

1. **Create shared native module:**

```swift
// ios/SharedLocationManager.swift
import Foundation
import CoreLocation

@objc(SharedLocationManager)
class SharedLocationManager: NSObject {

  @objc
  func getLocation(_ callback: @escaping (NSDictionary) -> Void) {
    // Shared location logic
    let manager = CLLocationManager()
    // ... location logic

    callback([
      "latitude": 37.7749,
      "longitude": -122.4194
    ])
  }

  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
}
```

2. **Bridge to React Native:**

```objc
// ios/SharedLocationManager.m
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(SharedLocationManager, NSObject)
RCT_EXTERN_METHOD(getLocation:(RCTResponseSenderBlock)callback)
@end
```

3. **Use in RN app:**

```javascript
// src/services/LocationService.js
import { NativeModules } from 'react-native';

const { SharedLocationManager } = NativeModules;

export const getLocation = () => {
  return new Promise((resolve) => {
    SharedLocationManager.getLocation((location) => {
      resolve(location);
    });
  });
};
```

4. **Use same native code in App Clip:**

```swift
// In App Clip
import SharedLocationManager

let manager = SharedLocationManager()
manager.getLocation { location in
  print("Location: \(location)")
}
```

### Advantages

✅ **Share business logic** between RN and App Clip
✅ **App Clip stays native** (small and fast)
✅ **Code reuse** for complex logic

### Disadvantages

❌ **Complex setup** requires native module expertise
❌ **Still need UI in Swift** for App Clip
❌ **Maintenance** of bridge code

---

## Comparison Summary

### Size Comparison

| Approach | Estimated Size | Exceeds Limit? |
|----------|----------------|----------------|
| Native Swift | 2-5 MB | ✅ No |
| React Native | 15-30 MB | ❌ Yes (QR/NFC) |
| Hybrid | 3-8 MB | ✅ Usually No |

### Effort Comparison

| Task | Native | RN App Clip | Hybrid |
|------|--------|-------------|--------|
| Initial Setup | 1 hour | 4+ hours | 2-3 hours |
| Add to existing RN | Easy | Hard | Medium |
| Code reuse | Low | High | Medium |
| Maintenance | Low | High | Medium |

---

## Recommended Implementation for Your RN App

### Option A: Pure Native (Best for most cases)

```
YourRNApp/
├── ios/
│   ├── YourApp/           ← React Native
│   └── TaivelAppClip/     ← Native Swift App Clip
├── src/                   ← Your RN code
```

**When to use:**
- ✅ App Clip is simple (like our location sender)
- ✅ You want smallest size and best performance
- ✅ You're okay maintaining separate Swift code

**Steps:** Follow Approach 1 above

### Option B: Shared Native Modules (Advanced)

```
YourRNApp/
├── ios/
│   ├── YourApp/              ← React Native
│   ├── TaivelAppClip/        ← Native Swift UI
│   └── SharedModules/        ← Shared native logic
│       ├── LocationManager.swift
│       └── APIClient.swift
├── src/                      ← Your RN code
```

**When to use:**
- ✅ Complex business logic to share
- ✅ You have native iOS expertise
- ✅ You want code reuse for critical features

**Steps:** Follow Approach 3 above

---

## Step-by-Step: Add to Your Existing RN Project

### Complete Example for Option A (Native Swift)

Let's say your RN app is called **AwesomeApp**:

```bash
# 1. Navigate to your project
cd ~/Projects/AwesomeApp

# 2. Open in Xcode
cd ios
open AwesomeApp.xcworkspace

# 3. In Xcode: Add App Clip target
#    Project → + → App Clip
#    Name: TaivelAppClip
#    Bundle ID: com.yourcompany.awesomeapp.Clip

# 4. Copy our App Clip files
cd ~/Projects/taivel-plugin
cp -r TaivelAppClip/Models ~/Projects/AwesomeApp/ios/TaivelAppClip/
cp -r TaivelAppClip/Services ~/Projects/AwesomeApp/ios/TaivelAppClip/
cp -r TaivelAppClip/Views ~/Projects/AwesomeApp/ios/TaivelAppClip/
cp TaivelAppClip/TaivelAppClipApp.swift ~/Projects/AwesomeApp/ios/TaivelAppClip/

# 5. In Xcode: Add files to target
#    Right-click TaivelAppClip folder → Add Files
#    Select copied folders
#    ✅ Target: TaivelAppClip

# 6. Add location permission to App Clip Info.plist
#    TaivelAppClip → Info.plist → + Key
#    NSLocationWhenInUseUsageDescription

# 7. Configure signing
#    TaivelAppClip target → Signing & Capabilities
#    Team: Your team
#    + Capability → Associated Domains
#    appclips:yourdomain.com

# 8. Deploy Convex backend
cd ~/Projects/taivel-plugin/convex-backend
npm install
npm run dev

# 9. Build and run
#    Xcode → Select TaivelAppClip scheme
#    Select your device
#    ⌘R
```

### Testing with Your Main RN App

```bash
# Terminal 1: Run Metro bundler
cd ~/Projects/AwesomeApp
npm start

# Terminal 2: Run Convex backend
cd ~/Projects/taivel-plugin/convex-backend
npm run dev

# Terminal 3: Run your main RN app
cd ~/Projects/AwesomeApp
npx react-native run-ios

# Xcode: Run App Clip separately
# Select TaivelAppClip scheme → ⌘R
```

---

## Sharing Data Between Your RN App and App Clip

### Use Case: User completes App Clip, opens main app

**Setup App Groups:**

1. Main app target → Signing & Capabilities → + App Groups
2. Add: `group.com.yourcompany.awesomeapp`
3. App Clip target → + App Groups → Same group ID

**In App Clip (Swift):**
```swift
// After successful location send
let defaults = UserDefaults(suiteName: "group.com.yourcompany.awesomeapp")
defaults?.set(true, forKey: "appClipCompleted")
defaults?.set(latitude, forKey: "lastLatitude")
defaults?.set(longitude, forKey: "lastLongitude")
```

**In RN App (JavaScript):**
```javascript
import SharedGroupPreferences from 'react-native-shared-group-preferences';

const GROUP_ID = 'group.com.yourcompany.awesomeapp';

async function checkAppClipCompletion() {
  const completed = await SharedGroupPreferences.getItem(
    'appClipCompleted',
    GROUP_ID
  );

  if (completed) {
    const lat = await SharedGroupPreferences.getItem('lastLatitude', GROUP_ID);
    const lng = await SharedGroupPreferences.getItem('lastLongitude', GROUP_ID);

    // Show welcome screen or use data
    console.log('User completed App Clip:', lat, lng);
  }
}
```

**Install required package:**
```bash
npm install react-native-shared-group-preferences
cd ios && pod install
```

---

## Troubleshooting RN Integration

### "Build failed: Multiple commands produce..."

This happens when RN's build system conflicts with App Clip.

**Fix:**
```ruby
# ios/Podfile
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
```

Then:
```bash
cd ios
pod install
```

### "App Clip exceeds size limit"

Check size:
```bash
# Archive the app
# Xcode → Product → Archive
# Organizer → Distribute → App Clip Size Report
```

Reduce size:
- Remove unused assets from App Clip
- Use asset catalogs
- Enable bitcode
- Compress images

### "React Native headers not found in App Clip"

App Clip shouldn't include RN. If using Approach 2:

```ruby
# ios/Podfile
target 'TaivelAppClip' do
  # Don't include React Native pods for App Clip
  # Only include if you're doing RN App Clip (Approach 2)
end
```

### "App Clip and main app out of sync"

Both must have compatible bundle IDs:
- Main: `com.company.app`
- App Clip: `com.company.app.Clip` (must be sub-identifier)

---

## Best Practices

### 1. Keep App Clip Simple

✅ **Do:**
- Single, focused task (like our location sender)
- Minimal UI (our 2 screens)
- Native Swift for performance

❌ **Don't:**
- Complex navigation
- Heavy dependencies
- Try to replicate full app

### 2. Share Assets Wisely

```
ios/
├── Shared/
│   ├── Assets.xcassets     ← Shared between main & App Clip
│   └── Colors.swift
├── YourApp/
└── TaivelAppClip/
```

In Xcode, add Shared folder to both targets.

### 3. Test Both Paths

- User uses App Clip → Then installs full app
- User has full app → App Clip still works

### 4. Monitor Size

```bash
# Check App Clip size regularly
xcodebuild archive \
  -workspace ios/YourApp.xcworkspace \
  -scheme TaivelAppClip \
  -archivePath ./build/TaivelAppClip.xcarchive

# Check archive size
du -sh ./build/TaivelAppClip.xcarchive
```

---

## Example: Complete Integration

Here's a real example integrating into a React Native app called "TravelApp":

**Before:**
```
TravelApp/
├── ios/
│   ├── TravelApp/
│   └── TravelApp.xcworkspace
├── android/
└── src/
```

**After:**
```
TravelApp/
├── ios/
│   ├── TravelApp/              ← Unchanged RN app
│   ├── TaivelAppClip/          ← NEW: App Clip
│   │   ├── Models/
│   │   ├── Services/
│   │   ├── Views/
│   │   └── Info.plist
│   └── TravelApp.xcworkspace
├── android/
├── src/                        ← Unchanged RN code
└── convex-backend/             ← NEW: Backend for App Clip
    ├── convex/
    └── package.json
```

**Result:**
- Main app: Full React Native app (unchanged)
- App Clip: Native Swift, launches in <1 second
- Backend: Convex handles location data
- Size: App Clip ~3 MB, well under limit

---

## Resources

- **[Apple: Creating an App Clip](https://developer.apple.com/documentation/app_clips/creating_an_app_clip_with_xcode)**
- **[React Native with App Clips](https://reactnative.dev/docs/appclip)**
- **[App Groups for Data Sharing](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_application-groups)**
- **[Reducing App Clip Size](https://developer.apple.com/documentation/app_clips/reducing_your_app_clip_s_size)**

---

## Quick Decision Tree

```
Do you need to share complex business logic?
├─ No → Use Approach 1 (Native Swift) ✅
└─ Yes → Is the logic simple enough to duplicate?
    ├─ Yes → Use Approach 1 (Native Swift) ✅
    └─ No → Can you extract it to native module?
        ├─ Yes → Use Approach 3 (Hybrid) ⚠️
        └─ No → Use Approach 1 anyway, worth it! ✅
```

**Bottom line:** Approach 1 (Native Swift App Clip) is almost always the right choice for React Native apps.

---

**Ready to integrate?** Follow the steps in "Step-by-Step: Add to Your Existing RN Project" above! 🚀
