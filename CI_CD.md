# CI/CD Setup Guide

Continuous Integration and Deployment workflows for the Taivel App Clip project.

## Overview

This project includes GitHub Actions workflows for automated testing and deployment. Due to GitHub App permission restrictions, these workflows need to be manually added to your repository.

## Workflow Files

The workflow files are located in `.github/workflows/`:
- `ios-ci.yml` - iOS App Clip CI/CD
- `convex-ci.yml` - Convex backend CI/CD

## Setup Instructions

### Option 1: Manual Addition via GitHub UI

1. Navigate to your repository on GitHub
2. Go to **Actions** tab
3. Click **New workflow** → **set up a workflow yourself**
4. Copy content from `.github/workflows/ios-ci.yml`
5. Name it `ios-ci.yml` and commit
6. Repeat for `convex-ci.yml`

### Option 2: Push with User Credentials

If you have direct push access (not via GitHub App):

```bash
git add .github/workflows/
git commit -m "Add CI/CD workflows"
git push origin your-branch
```

### Option 3: Enable Later

The workflows are committed to the branch and will be available when:
- Branch is merged to main
- Repository permissions are updated
- You manually enable them

## Required Secrets

Before the workflows can run successfully, add these secrets to your repository:

### CONVEX_DEPLOY_KEY

1. Get your deploy key:
   ```bash
   cd convex-backend
   npx convex deploy --print-deploy-key
   ```

2. Add to GitHub:
   - Go to: **Settings** → **Secrets and variables** → **Actions**
   - Click **New repository secret**
   - Name: `CONVEX_DEPLOY_KEY`
   - Value: (paste the deploy key)
   - Click **Add secret**

## Workflow Details

### iOS CI (`ios-ci.yml`)

**Triggers:**
- Push to `main`, `develop`, or `claude/**` branches
- Pull requests to `main` or `develop`

**Jobs:**

1. **build-and-test**
   - Runs on: `macos-13`
   - Sets up Xcode 15.0
   - Builds App Clip
   - Runs unit tests
   - Runs UI tests
   - Generates coverage reports

2. **swiftlint**
   - Runs on: `macos-13`
   - Installs SwiftLint
   - Enforces code quality standards

3. **security-scan**
   - Runs on: `ubuntu-latest`
   - Scans for security vulnerabilities
   - Uploads results to GitHub Security

**Note:** Build and test jobs are templated and will activate once the Xcode project is created.

### Convex CI (`convex-ci.yml`)

**Triggers:**
- Push to `main`, `develop`, or `claude/**` branches (when convex-backend changes)
- Pull requests to `main` or `develop` (when convex-backend changes)

**Jobs:**

1. **typecheck**
   - Runs on: `ubuntu-latest`
   - Validates TypeScript types
   - Node.js 20

2. **lint**
   - Runs on: `ubuntu-latest`
   - Runs ESLint
   - Enforces code style

3. **test**
   - Runs on: `ubuntu-latest`
   - Runs Vitest unit tests
   - Tests all Convex functions

4. **deploy-preview**
   - Runs on PRs only
   - Deploys preview environment
   - Requires `CONVEX_DEPLOY_KEY`

5. **deploy-production**
   - Runs on main branch only
   - Deploys to production
   - Requires all checks to pass
   - Requires `CONVEX_DEPLOY_KEY`

## Testing Workflows Locally

Before enabling workflows, test commands locally:

### iOS Tests

```bash
# Install SwiftLint
brew install swiftlint

# Lint code
swiftlint lint --strict

# Build (once Xcode project exists)
xcodebuild clean build \
  -scheme TaivelAppClip \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# Test
xcodebuild test \
  -scheme TaivelAppClip \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Convex Tests

```bash
cd convex-backend

# Install dependencies
npm ci

# Type check
npm run typecheck

# Lint
npm run lint

# Test
npm test

# Coverage
npm run test:coverage
```

## Deployment Strategy

### Development
- Push to `develop` or feature branches
- Runs tests and linting
- No deployment

### Staging (Preview)
- Open pull request
- Runs full test suite
- Deploys Convex preview environment
- Preview URL available in PR comments

### Production
- Merge to `main` branch
- Runs full test suite
- Deploys to production Convex
- Automated deployment on success

## Troubleshooting

### "Workflows not appearing in Actions tab"

- Workflows may need to be in the default branch (`main`)
- Check repository settings for Actions enablement
- Ensure workflow files are in `.github/workflows/`

### "CONVEX_DEPLOY_KEY not found"

- Add the secret in repository settings
- Verify the secret name matches exactly: `CONVEX_DEPLOY_KEY`
- Check the secret is available to the workflow

### "Xcode build failing"

- Ensure Xcode project is created and committed
- Update scheme name in workflow if different
- Check iOS simulator availability

### "Deploy failing with 403"

- Regenerate deploy key: `npx convex deploy --print-deploy-key`
- Update the secret in GitHub
- Verify key hasn't expired

## Workflow Customization

### Change iOS Version

Edit `ios-ci.yml`:
```yaml
env:
  XCODE_VERSION: '15.0'  # Change here
  IOS_SIMULATOR: 'iPhone 15'  # And here
  IOS_VERSION: '17.0'  # And here
```

### Change Node Version

Edit `convex-ci.yml`:
```yaml
- uses: actions/setup-node@v4
  with:
    node-version: '20'  # Change here
```

### Add Codecov Integration

Uncomment in `ios-ci.yml`:
```yaml
- name: Upload Coverage to Codecov
  uses: codecov/codecov-action@v3
  with:
    files: ./coverage.lcov
```

Then add `CODECOV_TOKEN` to repository secrets.

## Status Badges

Once workflows are enabled, add status badges to README:

```markdown
![iOS CI](https://github.com/yourusername/taivel-plugin/workflows/iOS%20CI/badge.svg)
![Convex CI](https://github.com/yourusername/taivel-plugin/workflows/Convex%20Backend%20CI/badge.svg)
```

## Monitoring

### View Workflow Runs

1. Go to **Actions** tab
2. Select workflow (iOS CI or Convex CI)
3. View recent runs and logs

### Set Up Notifications

1. **Settings** → **Notifications**
2. Enable **Actions** notifications
3. Choose notification preferences

## Security Best Practices

1. **Never commit secrets** to the repository
2. **Use environment-specific deploy keys** (dev, staging, prod)
3. **Review workflow logs** for exposed secrets
4. **Rotate deploy keys** regularly
5. **Limit workflow permissions** to minimum necessary

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Convex Deployment Guide](https://docs.convex.dev/production/hosting)
- [Xcode Cloud vs GitHub Actions](https://developer.apple.com/xcode-cloud/)

## Next Steps

1. ✅ Workflows created and documented
2. ⬜ Add `CONVEX_DEPLOY_KEY` to repository secrets
3. ⬜ Enable workflows via GitHub UI or manual push
4. ⬜ Create Xcode project and commit
5. ⬜ Test workflows on feature branch
6. ⬜ Merge to main for production deployment

---

**Need help?** See [TESTING.md](TESTING.md) for testing documentation or [CONFIGURATION.md](CONFIGURATION.md) for configuration details.
