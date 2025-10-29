# Testing Guide

Comprehensive testing documentation for the Taivel App Clip project.

## Table of Contents

- [Overview](#overview)
- [iOS Testing](#ios-testing)
- [Convex Backend Testing](#convex-backend-testing)
- [CI/CD](#cicd)
- [Code Quality](#code-quality)
- [Coverage Reports](#coverage-reports)

## Overview

This project includes comprehensive testing at multiple levels:

- ✅ **Unit Tests**: Test individual components in isolation
- ✅ **UI Tests**: Test user interaction flows
- ✅ **Integration Tests**: Test Convex backend functions
- ✅ **CI/CD**: Automated testing on every push
- ✅ **Code Quality**: Linting with SwiftLint and ESLint

## iOS Testing

### Prerequisites

- Xcode 13.0+
- iOS Simulator or physical device
- SwiftLint (optional, for linting)

### Running Unit Tests

```bash
# Open Xcode project
open Taivel.xcodeproj

# Run tests with ⌘U or:
xcodebuild test \
  -scheme TaivelAppClip \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -enableCodeCoverage YES
```

### Running UI Tests

```bash
# Run UI tests
xcodebuild test \
  -scheme TaivelAppClip \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:TaivelAppClipUITests
```

### Test Structure

```
TaivelAppClip/Tests/
├── LocationManagerTests.swift      # Unit tests for location service
├── ConvexAPIClientTests.swift      # Unit tests for API client
└── TaivelAppClipUITests.swift      # UI tests for user flows
```

### Unit Test Coverage

#### LocationManagerTests.swift

Tests for the location manager:
- ✅ First-use detection
- ✅ Location permission tracking
- ✅ UserDefaults persistence
- ✅ Reset functionality
- ✅ Location retrieval logic

**Example:**
```swift
func testIsFirstUse_InitialState() {
    // Given: Fresh install
    UserDefaults.standard.removeObject(forKey: "HasRequestedLocationPermission")

    // When: Checking first use
    let isFirstUse = locationManager.isFirstUse

    // Then: Should be true
    XCTAssertTrue(isFirstUse)
}
```

#### ConvexAPIClientTests.swift

Tests for the API client:
- ✅ Request formatting
- ✅ Success response parsing
- ✅ Error handling
- ✅ Timeout handling
- ✅ Network error scenarios

**Note**: These tests use URLProtocol mocking in production. See inline comments for implementation.

#### TaivelAppClipUITests.swift

UI tests for user flows:
- ✅ App launch
- ✅ Main screen elements
- ✅ Button interactions
- ✅ Location permission flow
- ✅ Success screen
- ✅ Error handling
- ✅ Accessibility

**Example:**
```swift
func testMainScreenElements() {
    let titleLabel = app.staticTexts["Taivel"]
    XCTAssertTrue(titleLabel.exists)

    let sendButton = app.buttons["Send Request"]
    XCTAssertTrue(sendButton.exists)
    XCTAssertTrue(sendButton.isEnabled)
}
```

### Test Best Practices

1. **Arrange-Act-Assert Pattern**
   ```swift
   // Given (Arrange)
   let input = prepareTestData()

   // When (Act)
   let result = functionUnderTest(input)

   // Then (Assert)
   XCTAssertEqual(result, expectedValue)
   ```

2. **Use setUp and tearDown**
   ```swift
   override func setUp() {
       super.setUp()
       // Clean state before each test
   }

   override func tearDown() {
       // Clean up after each test
       super.tearDown()
   }
   ```

3. **Test one thing at a time**
   - Each test should verify one specific behavior
   - Use descriptive test names

4. **Mock external dependencies**
   - Don't make real network calls in unit tests
   - Use URLProtocol mocking for network tests

## Convex Backend Testing

### Prerequisites

```bash
cd convex-backend
npm install
```

### Running Tests

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run with coverage
npm run test:coverage

# TypeScript type checking
npm run typecheck

# Linting
npm run lint
npm run lint:fix
```

### Test Structure

```
convex-backend/convex/
├── location.ts         # Implementation
└── location.test.ts    # Tests
```

### Backend Test Coverage

#### location.test.ts

Tests for Convex mutations and queries:
- ✅ Store location on first use
- ✅ Store empty location on subsequent use
- ✅ List recent locations
- ✅ Respect limit parameter
- ✅ Get statistics
- ✅ Coordinate validation
- ✅ Timestamp accuracy

**Example:**
```typescript
it('should store location data on first use', async () => {
  // Given: First use with location data
  const latitude = 37.7749;
  const longitude = -122.4194;

  // When: Sending location
  const result = await t.mutation(api.location.send, {
    latitude,
    longitude,
  });

  // Then: Should return success response
  expect(result.message).toBe('Location received successfully');
  expect(result.isFirstUse).toBe(true);
});
```

### Test Configuration

**vitest.config.ts**
```typescript
export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html', 'lcov'],
    },
  },
});
```

### Backend Test Best Practices

1. **Use convex-test for unit testing**
   - Fast, no network calls
   - Tests business logic in isolation

2. **Clean state between tests**
   ```typescript
   beforeEach(() => {
     t = convexTest(schema);
   });
   ```

3. **Test edge cases**
   - Empty database
   - Partial data
   - Invalid coordinates

## CI/CD

### GitHub Actions Workflows

#### iOS CI (.github/workflows/ios-ci.yml)

Runs on every push and PR:
- ✅ Build App Clip
- ✅ Run unit tests
- ✅ Run UI tests
- ✅ SwiftLint code quality check
- ✅ Security scanning

**Trigger:**
```yaml
on:
  push:
    branches: [ main, develop, 'claude/**' ]
  pull_request:
    branches: [ main, develop ]
```

#### Convex CI (.github/workflows/convex-ci.yml)

Runs on backend changes:
- ✅ TypeScript type checking
- ✅ ESLint
- ✅ Unit tests
- ✅ Deploy preview (on PR)
- ✅ Deploy production (on main)

**Deploy Keys:**
```bash
# Get deploy key
npx convex deploy

# Add to GitHub Secrets:
# Settings → Secrets → CONVEX_DEPLOY_KEY
```

### Running CI Locally

**iOS:**
```bash
# Install SwiftLint
brew install swiftlint

# Run linter
swiftlint lint --strict

# Run tests
xcodebuild test -scheme TaivelAppClip
```

**Convex:**
```bash
cd convex-backend

# Type check
npm run typecheck

# Lint
npm run lint

# Test
npm test
```

## Code Quality

### SwiftLint

Configuration: `.swiftlint.yml`

**Key Rules:**
- Line length: 120 chars (warning), 200 (error)
- File length: 500 lines (warning), 1000 (error)
- Function body: 50 lines (warning), 100 (error)
- Cyclomatic complexity: 10 (warning), 20 (error)

**Run:**
```bash
swiftlint lint
swiftlint lint --fix  # Auto-fix some issues
```

### ESLint

Configuration: `convex-backend/.eslintrc.json`

**Key Rules:**
- TypeScript recommended rules
- No unused variables (with `_` prefix exception)
- Consistent code style

**Run:**
```bash
cd convex-backend
npm run lint
npm run lint:fix  # Auto-fix
```

## Coverage Reports

### iOS Coverage

```bash
# Generate coverage
xcodebuild test \
  -scheme TaivelAppClip \
  -enableCodeCoverage YES

# View in Xcode:
# Report Navigator (⌘9) → Coverage tab
```

**Coverage Goals:**
- Unit tests: > 80%
- Critical paths: 100% (LocationManager, ConvexAPIClient)

### Convex Coverage

```bash
cd convex-backend
npm run test:coverage

# View HTML report
open coverage/index.html
```

**Coverage Reports:**
- Text: Terminal output
- JSON: `coverage/coverage.json`
- HTML: `coverage/index.html`
- LCOV: `coverage/lcov.info` (for CI tools)

### Uploading to Codecov

Add to GitHub Actions:
```yaml
- name: Upload Coverage
  uses: codecov/codecov-action@v3
  with:
    files: ./coverage.lcov
```

## Testing Checklist

Before submitting a PR:

- [ ] All unit tests pass
- [ ] All UI tests pass
- [ ] Code coverage meets minimums
- [ ] SwiftLint passes with no errors
- [ ] ESLint passes with no errors
- [ ] TypeScript compiles without errors
- [ ] Manual testing completed
- [ ] CI/CD pipeline passes

## Debugging Tests

### iOS Test Debugging

1. **Set breakpoints** in test methods
2. **Run test** with ⌘U
3. **Inspect variables** in debug area
4. **View console output** for print statements

### Convex Test Debugging

```typescript
it('should debug test', async () => {
  console.log('Debug info:', result);
  // Tests will show console output
});
```

### Common Issues

**iOS:**
- Simulator not booting: `xcrun simctl shutdown all && xcrun simctl boot ...`
- Tests hanging: Check for infinite loops or unresolved async
- Location permission: Use `.resetFirstUseFlag()` between tests

**Convex:**
- Type errors: Run `npm run typecheck`
- Test failures: Check database schema matches code
- Import errors: Verify `convex-test` is installed

## Resources

- [XCTest Documentation](https://developer.apple.com/documentation/xctest)
- [Vitest Documentation](https://vitest.dev/)
- [Convex Testing Guide](https://docs.convex.dev/testing)
- [SwiftLint Rules](https://realm.github.io/SwiftLint/rule-directory.html)
- [ESLint Rules](https://eslint.org/docs/rules/)

## Contributing

When adding new features:

1. Write tests first (TDD)
2. Ensure all tests pass
3. Maintain or improve coverage
4. Follow code quality standards
5. Update this documentation

---

**Questions?** Check the [main README](README.md) or open an issue.
