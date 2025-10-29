# Taivel App Clip - Location Request with Convex.dev

An iOS App Clip that allows users to send location data to a Convex.dev backend via REST API. Location permission is requested only on first use.

## Features

- **Simple UI**: Single button to send location request
- **First-Use Location**: Requests "When In Use" location permission only on first launch
- **Convex.dev Integration**: Posts location data to Convex backend via HTTP API
- **Success/Error Handling**: Clear visual feedback for request completion
- **App Clip Optimized**: Designed to meet iOS App Clip size and performance requirements

## Project Structure

```
TaivelAppClip/
├── Models/
│   └── ConvexResponse.swift       # Data models for API requests/responses
├── Services/
│   ├── ConvexAPIClient.swift      # HTTP client for Convex API
│   └── LocationManager.swift      # Location services and first-use tracking
├── Views/
│   ├── ContentView.swift          # Main view with Send Request button
│   └── SuccessView.swift          # Success confirmation screen
├── Resources/
│   ├── Info.plist                 # App configuration with permissions
│   ├── TaivelAppClip.entitlements # App Clip entitlements
│   └── ConvexConfig.swift         # Convex deployment configuration
└── TaivelAppClipApp.swift         # App entry point
```

## Setup Instructions

### 1. Create Xcode Project

Since App Clips require Xcode project configuration, you'll need to set this up in Xcode:

1. **Open Xcode** and create a new project:
   - Choose "App" template
   - Product Name: `Taivel`
   - Bundle Identifier: `com.yourdomain.taivel`
   - Interface: SwiftUI
   - Language: Swift

2. **Add App Clip Target**:
   - File → New → Target
   - Choose "App Clip"
   - Product Name: `TaivelAppClip`
   - Bundle Identifier: `com.yourdomain.taivel.Clip`

3. **Copy Source Files**:
   - Copy all files from `TaivelAppClip/` directory into your App Clip target
   - Ensure files are added to the App Clip target (not main app)
   - Replace the default `ContentView.swift` and `TaivelAppClipApp.swift`

4. **Configure Info.plist**:
   - Replace App Clip's Info.plist with `TaivelAppClip/Resources/Info.plist`
   - Update location permission description if needed

5. **Configure Entitlements**:
   - Replace App Clip's entitlements with `TaivelAppClip/Resources/TaivelAppClip.entitlements`
   - Update domain to your actual domain

### 2. Configure Convex Backend

#### A. Set Up Convex Project

1. **Sign up for Convex**:
   ```bash
   npm install -g convex
   ```

2. **Create Convex project**:
   ```bash
   mkdir convex-backend
   cd convex-backend
   npx convex dev
   ```

3. **Create the schema** (`convex/schema.ts`):
   ```typescript
   import { defineSchema, defineTable } from "convex/server";
   import { v } from "convex/values";

   export default defineSchema({
     locations: defineTable({
       latitude: v.optional(v.number()),
       longitude: v.optional(v.number()),
       timestamp: v.number(),
     }),
   });
   ```

4. **Create the mutation** (`convex/location.ts`):
   ```typescript
   import { mutation } from "./_generated/server";
   import { v } from "convex/values";

   export const send = mutation({
     args: {
       latitude: v.optional(v.number()),
       longitude: v.optional(v.number()),
     },
     handler: async (ctx, args) => {
       const { latitude, longitude } = args;

       // Store in database
       const locationId = await ctx.db.insert("locations", {
         latitude,
         longitude,
         timestamp: Date.now(),
       });

       console.log(`Received location: lat=${latitude}, lng=${longitude}`);

       return {
         id: locationId,
         message: "Location received successfully",
         latitude,
         longitude,
       };
     },
   });
   ```

5. **Deploy to production**:
   ```bash
   npx convex deploy
   ```

#### B. Update iOS App Configuration

1. **Get your deployment URL** from Convex dashboard (https://dashboard.convex.dev)
   - Format: `https://your-deployment-name.convex.cloud`

2. **Update `ConvexAPIClient.swift`**:
   ```swift
   private let baseURL = "https://your-deployment-name.convex.cloud"
   ```

### 3. Configure Associated Domains

For App Clips to work in production, you need to configure associated domains:

1. **Update entitlements** with your actual domain:
   ```xml
   <key>com.apple.developer.associated-domains</key>
   <array>
       <string>appclips:yourdomain.com</string>
   </array>
   ```

2. **Host AASA file** at `https://yourdomain.com/.well-known/apple-app-site-association`:
   ```json
   {
     "appclips": {
       "apps": ["TEAMID.com.yourdomain.taivel.Clip"]
     }
   }
   ```

### 4. Build and Test

1. **Select App Clip scheme** in Xcode
2. **Choose a simulator or device**
3. **Build and run** (⌘R)

#### Testing First-Use Behavior

To test the first-use location prompt:

1. **Run the app** - location permission will be requested
2. **To reset**:
   - In simulator: Device → Erase All Content and Settings
   - Or modify code to call `LocationManager.shared.resetFirstUseFlag()`

## API Request Format

The app sends POST requests to Convex with this structure:

```json
{
  "path": "location:send",
  "args": {
    "latitude": 37.7749,
    "longitude": -122.4194
  },
  "format": "json"
}
```

**First Use**: Includes location data (if permission granted)
**Subsequent Uses**: Empty `args` object

## Success Response

```json
{
  "status": "success",
  "value": {
    "id": "...",
    "message": "Location received successfully"
  },
  "logLines": []
}
```

## Error Response

```json
{
  "status": "error",
  "errorMessage": "Error description",
  "errorData": {},
  "logLines": []
}
```

## Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.5+
- Active Convex deployment

## App Clip Constraints

- **Maximum size**: 15MB (for QR code/NFC invocation)
- **Network timeout**: 3 seconds
- **Privacy**: Location only requested on first use
- **Ephemeral**: Data stored in UserDefaults for session tracking

## Troubleshooting

### Location not working
- Check Info.plist has `NSLocationWhenInUseUsageDescription`
- Verify location permissions in Settings → Privacy → Location Services
- Test on physical device (simulator may have issues)

### Network request failing
- Verify Convex deployment URL is correct
- Check internet connectivity
- Review Convex dashboard logs
- Ensure mutation path matches: `location:send`

### App Clip not launching
- Verify associated domains are configured correctly
- Check AASA file is accessible
- Ensure bundle identifiers match

## Documentation References

- [Convex HTTP API](https://docs.convex.dev/http-api/)
- [Apple App Clips](https://developer.apple.com/design/human-interface-guidelines/app-clips)
- [Core Location](https://developer.apple.com/documentation/corelocation)

## License

MIT License - feel free to use this as a template for your own App Clip projects.

## Support

For issues or questions:
- Convex: https://docs.convex.dev
- Apple Developer: https://developer.apple.com/app-clips/
