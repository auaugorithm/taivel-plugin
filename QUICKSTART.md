# Quick Start (5 minutes)

Get the Taivel App Clip running locally in 5 minutes.

## Backend (2 minutes)

```bash
# 1. Install dependencies
cd convex-backend
npm install

# 2. Start development server
npm run dev
# → Creates Convex account (if needed)
# → Opens dashboard in browser
# → Outputs deployment URL

# 3. Copy the deployment URL (looks like: https://xxx-yyy-123.convex.cloud)
```

## iOS App (3 minutes)

### Create Xcode Project

```
1. Xcode → File → New → Project
2. Choose "App" template
3. Product Name: Taivel
4. Interface: SwiftUI
5. Language: Swift
```

### Add App Clip Target

```
1. Project → + Target
2. Choose "App Clip"
3. Product Name: TaivelAppClip
4. Click Activate
```

### Copy Source Files

```
Drag these folders into the App Clip target in Xcode:
- TaivelAppClip/Models/
- TaivelAppClip/Services/
- TaivelAppClip/Views/
- TaivelAppClip/TaivelAppClipApp.swift
```

### Configure

```swift
// 1. Open ConvexAPIClient.swift
// 2. Update line 15 with your deployment URL:
private let baseURL = "https://your-actual-url.convex.cloud"
```

```
// 3. Info.plist → Add:
Key: Privacy - Location When In Use Usage Description
Value: We need your location to send it to our server on first use.
```

### Run

```
1. Select TaivelAppClip scheme
2. Choose iPhone 14 simulator
3. Press ⌘R
4. Press "Send Request" button
5. Grant location permission
6. See success screen!
```

### Verify

```
Open Convex Dashboard → Data → locations table
You should see your location entry!
```

## Done! 🎉

For detailed setup instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md)

## Troubleshooting

**"Failed to send request"**
→ Check Convex URL in ConvexAPIClient.swift

**No location permission prompt**
→ Add usage description to Info.plist

**Build errors**
→ Ensure files are added to App Clip target

---

Need help? See [README.md](README.md) for full documentation.
