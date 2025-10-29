# Configuration Guide

Secure configuration for the Taivel App Clip project.

## Table of Contents

- [Convex Backend Setup](#convex-backend-setup)
- [iOS App Configuration](#ios-app-configuration)
- [GitHub Secrets](#github-secrets)
- [Environment-Specific Config](#environment-specific-config)
- [Security Best Practices](#security-best-practices)

## Convex Backend Setup

### 1. Create Convex Account

```bash
cd convex-backend
npm install
npm run dev
```

This will:
- Prompt you to create a Convex account (if needed)
- Create a new project
- Generate deployment URL

### 2. Get Deployment URL

After running `npm run dev`, you'll see:

```
✓ Convex project ready
  Dashboard: https://dashboard.convex.dev/t/your-team/your-project
  Deployment URL: https://happy-animal-123.convex.cloud
```

**Copy the Deployment URL** - you'll need it for iOS app configuration.

### 3. Deploy to Production

```bash
npm run deploy
```

This creates a production deployment separate from dev.

### 4. Get Deploy Key (for CI/CD)

```bash
npx convex deploy --print-deploy-key
```

**Save this key securely** - you'll add it to GitHub Secrets.

## iOS App Configuration

### Option 1: Direct Configuration (Development Only)

⚠️ **NOT recommended for production** - keys will be in source code.

1. Open `TaivelAppClip/Services/ConvexAPIClient.swift`
2. Update line ~15:

```swift
private let baseURL = "https://your-actual-deployment.convex.cloud"
```

### Option 2: Configuration File (Recommended)

Create a gitignored config file:

```bash
# Create config file
cat > TaivelAppClip/Resources/Config.xcconfig << EOF
CONVEX_DEPLOYMENT_URL = https:\/\/your-deployment.convex.cloud
EOF

# Add to .gitignore
echo "TaivelAppClip/Resources/Config.xcconfig" >> .gitignore
```

Then in Xcode:
1. Add `Config.xcconfig` to project (don't commit it!)
2. Project → Info → Configurations → Select Config.xcconfig
3. Update code to read from build settings

### Option 3: Environment Variables (Best for CI/CD)

```swift
// ConvexAPIClient.swift
private let baseURL: String = {
    if let url = ProcessInfo.processInfo.environment["CONVEX_URL"] {
        return url
    }
    // Fallback for development
    return "https://your-deployment.convex.cloud"
}()
```

Set in Xcode scheme:
1. Edit Scheme → Run → Arguments
2. Environment Variables → Add `CONVEX_URL`

## GitHub Secrets

For CI/CD automation, add these secrets to your GitHub repository:

### 1. Navigate to Repository Settings

```
GitHub → Your Repo → Settings → Secrets and variables → Actions
```

### 2. Add Convex Deploy Key

**Name:** `CONVEX_DEPLOY_KEY`
**Value:** (from `npx convex deploy --print-deploy-key`)

```
# Example (DO NOT use this example key):
deploy:happy-animal-123|1234567890abcdef1234567890abcdef
```

### 3. Add Convex Deployment URL (Optional)

**Name:** `CONVEX_DEPLOYMENT_URL`
**Value:** `https://your-deployment.convex.cloud`

### 4. Test in Workflow

The GitHub Actions workflows will automatically use these secrets:

```yaml
env:
  CONVEX_DEPLOY_KEY: ${{ secrets.CONVEX_DEPLOY_KEY }}
run: npx convex deploy --prod
```

## Environment-Specific Config

### Development

**Convex Backend:**
```bash
cd convex-backend
npm run dev  # Uses dev deployment
```

**iOS App:**
- Use dev Convex URL
- Test with simulator
- Location simulation enabled

### Staging (Preview)

**Convex Backend:**
```bash
npx convex deploy --preview
```

**iOS App:**
- Update URL to preview deployment
- Test on physical device
- Real location data

### Production

**Convex Backend:**
```bash
npx convex deploy --prod
```

**iOS App:**
- Production Convex URL
- App Store build
- All features enabled

## Configuration Checklist

Before deploying:

### Backend
- [ ] Convex account created
- [ ] Production deployment exists
- [ ] Deploy key added to GitHub Secrets
- [ ] Database schema deployed
- [ ] Functions tested in dashboard

### iOS
- [ ] Convex URL updated (not hardcoded in committed code)
- [ ] Associated domains configured
- [ ] Entitlements updated
- [ ] Bundle identifiers set correctly
- [ ] Code signing configured

### CI/CD
- [ ] `CONVEX_DEPLOY_KEY` secret added
- [ ] Workflows pass on test branch
- [ ] Coverage reporting enabled
- [ ] Deploy permissions correct

## Security Best Practices

### ✅ DO:

1. **Use GitHub Secrets for sensitive keys**
   ```yaml
   env:
     CONVEX_DEPLOY_KEY: ${{ secrets.CONVEX_DEPLOY_KEY }}
   ```

2. **Gitignore sensitive files**
   ```gitignore
   Config.xcconfig
   .env
   .env.local
   *.pem
   *.key
   ```

3. **Use environment-specific deployments**
   - Development: `npm run dev`
   - Staging: `npx convex deploy --preview`
   - Production: `npm run deploy`

4. **Rotate keys regularly**
   ```bash
   npx convex deploy --print-deploy-key  # Generate new key
   ```

5. **Use least-privilege access**
   - Read-only keys for CI
   - Deploy keys for CD
   - Admin keys only locally

### ❌ DON'T:

1. **Commit API keys to git**
   ```swift
   // ❌ BAD
   let apiKey = "deploy:happy-animal-123|secret123"

   // ✅ GOOD
   let apiKey = ProcessInfo.processInfo.environment["CONVEX_KEY"]
   ```

2. **Share deploy keys in public channels**
   - Don't post in Slack, Discord, etc.
   - Use secure sharing (1Password, etc.)

3. **Use production keys in development**
   - Keep dev and prod separate
   - Use preview deployments for testing

4. **Hardcode URLs in committed code**
   ```swift
   // ❌ BAD
   private let baseURL = "https://prod-deployment.convex.cloud"

   // ✅ GOOD
   private let baseURL = Config.convexURL
   ```

## Providing Your Convex Deployment URL

If you have your Convex deployment URL ready, you can configure it:

### Quick Setup

1. **Find your deployment URL**:
   - Run `npm run dev` in `convex-backend/`
   - Or visit https://dashboard.convex.dev
   - Copy the URL (format: `https://xxx-yyy-123.convex.cloud`)

2. **Update iOS app**:

   **Method A: Direct (for testing)**
   ```swift
   // TaivelAppClip/Services/ConvexAPIClient.swift:15
   private let baseURL = "https://YOUR-DEPLOYMENT.convex.cloud"
   ```

   **Method B: Config file (recommended)**
   ```bash
   # Create config
   echo 'CONVEX_DEPLOYMENT_URL = https://YOUR-DEPLOYMENT.convex.cloud' > TaivelAppClip/Resources/Config.xcconfig

   # Add to .gitignore
   echo "TaivelAppClip/Resources/Config.xcconfig" >> .gitignore
   ```

3. **Test the connection**:
   - Build and run the app
   - Press "Send Request"
   - Check Convex dashboard for data

### Sharing Your Deployment URL

If you'd like to share your deployment URL for configuration:

```
Deployment URL: https://_________________.convex.cloud
Deploy Key: (optional, for CI/CD)
```

I can then:
- Update the configuration files
- Test the integration
- Set up CI/CD workflows
- Verify end-to-end functionality

**Note:** It's safe to share the deployment URL publicly (it's read-only for unauthenticated requests). Only share deploy keys via secure channels.

## Troubleshooting

### "Invalid deployment URL"

Check format:
```
✅ https://happy-animal-123.convex.cloud
❌ http://happy-animal-123.convex.cloud
❌ happy-animal-123.convex.cloud
```

### "Deploy key not working"

```bash
# Regenerate key
npx convex deploy --print-deploy-key

# Update GitHub Secret
# Settings → Secrets → CONVEX_DEPLOY_KEY → Update
```

### "Network request failed"

1. Check internet connection
2. Verify deployment URL is correct
3. Check Convex dashboard for deployment status
4. Review Xcode console for detailed error

## Resources

- [Convex Dashboard](https://dashboard.convex.dev)
- [Convex Environment Variables](https://docs.convex.dev/production/environment-variables)
- [GitHub Encrypted Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Xcode Build Settings](https://developer.apple.com/documentation/xcode/build-settings-reference)

---

**Ready to configure?** Share your Convex deployment URL and I'll help set everything up!
