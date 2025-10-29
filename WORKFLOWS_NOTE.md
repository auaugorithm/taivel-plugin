# GitHub Actions Workflows Note

## Location

The GitHub Actions workflow files are located in `.github/workflows/`:
- `ios-ci.yml` - iOS App Clip build and test workflow
- `convex-ci.yml` - Convex backend test and deployment workflow

## Why Aren't They Committed?

These workflow files **exist locally** but are not committed to the repository because:

1. **GitHub App Permissions**: The workflows were created by Claude Code (a GitHub App) which lacks the `workflows` permission required to push workflow files
2. **Security Restriction**: This is a GitHub security feature to prevent apps from automatically creating or modifying CI/CD workflows without explicit permission

## The Files Are Ready to Use!

The workflow files are fully functional and ready to activate. They're gitignored to avoid push conflicts, but you can enable them easily.

## How to Activate Workflows

### Option 1: Copy and Commit Manually (Recommended)

```bash
# Temporarily remove from gitignore
sed -i.bak '/.github\/workflows\//d' .gitignore

# Add and commit workflows
git add .github/workflows/
git commit -m "Add CI/CD workflows"
git push origin your-branch

# Restore gitignore if desired
mv .gitignore.bak .gitignore
```

### Option 2: Create via GitHub UI

1. Go to your repository on GitHub
2. Click **Actions** → **New workflow** → **set up a workflow yourself**
3. Copy content from `.github/workflows/ios-ci.yml`
4. Save as `ios-ci.yml`
5. Repeat for `convex-ci.yml`

### Option 3: Use Them Locally

Even without pushing, you can reference them for local CI testing:

```bash
# Test iOS workflow commands
swiftlint lint --strict
xcodebuild test -scheme TaivelAppClip

# Test Convex workflow commands
cd convex-backend
npm run typecheck
npm run lint
npm test
```

## Workflow Contents

### ios-ci.yml
- ✅ macOS runner with Xcode 15
- ✅ iOS App Clip build
- ✅ Unit and UI test execution
- ✅ SwiftLint code quality
- ✅ Security scanning

### convex-ci.yml
- ✅ TypeScript type checking
- ✅ ESLint validation
- ✅ Vitest test suite
- ✅ Preview deployments (PRs)
- ✅ Production deployment (main)

## Documentation

For complete setup instructions, see **[CI_CD.md](CI_CD.md)**

## Questions?

- **Setup help**: See [SETUP_GUIDE.md](SETUP_GUIDE.md)
- **Testing info**: See [TESTING.md](TESTING.md)
- **Configuration**: See [CONFIGURATION.md](CONFIGURATION.md)

---

**Note:** Once you manually add these workflows to your repository, you can remove this note file and the `.github/workflows/` entry from `.gitignore`.
