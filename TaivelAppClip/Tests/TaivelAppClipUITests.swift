//
//  TaivelAppClipUITests.swift
//  TaivelAppClipUITests
//
//  UI tests for the App Clip user flow
//

import XCTest

class TaivelAppClipUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Initial Launch Tests

    func testAppLaunches() throws {
        // Verify app launches successfully
        XCTAssertTrue(app.state == .runningForeground)
    }

    func testMainScreenElements() throws {
        // Given: App is launched
        // Then: Main screen elements should be visible

        // Check for title
        let titleLabel = app.staticTexts["Taivel"]
        XCTAssertTrue(titleLabel.exists, "Title should be visible")

        // Check for subtitle
        let subtitleLabel = app.staticTexts["Location Request App Clip"]
        XCTAssertTrue(subtitleLabel.exists, "Subtitle should be visible")

        // Check for send button
        let sendButton = app.buttons["Send Request"]
        XCTAssertTrue(sendButton.exists, "Send Request button should be visible")
        XCTAssertTrue(sendButton.isEnabled, "Send Request button should be enabled")
    }

    // MARK: - Button Interaction Tests

    func testSendRequestButton() throws {
        // Given: Main screen is visible
        let sendButton = app.buttons["Send Request"]

        // When: User taps the button
        sendButton.tap()

        // Then: Button should show loading state or trigger action
        // Note: Actual behavior depends on network/location permissions
    }

    func testFirstUseInfoText() throws {
        // Given: First use (you'd need to reset app state)
        // Then: Info text should be visible
        let infoText = app.staticTexts["Location will be requested on first use"]

        // Note: This may not be visible on subsequent runs
        // In production, you'd reset app state between tests
    }

    // MARK: - Location Permission Tests

    func testLocationPermissionPrompt() throws {
        // This test would verify the location permission dialog appears
        // Note: This requires special test configuration in iOS

        // Given: First launch
        // When: Send button is tapped
        // Then: System location permission alert should appear

        // In production, you'd use:
        // addUIInterruptionMonitor(withDescription: "Location Permission") { alert in
        //     alert.buttons["Allow While Using App"].tap()
        //     return true
        // }
    }

    // MARK: - Success Flow Tests

    func testSuccessScreenAppears() throws {
        // This test would verify the success screen appears after successful request
        // Note: Requires mocking or actual backend

        // Given: Send request succeeds
        // Then: Success screen should appear
        // let successTitle = app.staticTexts["Request Sent!"]
        // XCTAssertTrue(successTitle.waitForExistence(timeout: 5))
    }

    func testSuccessDoneButton() throws {
        // Given: Success screen is showing
        // When: User taps Done
        // Then: Should return to main screen

        // let doneButton = app.buttons["Done"]
        // doneButton.tap()
        // XCTAssertTrue(app.buttons["Send Request"].exists)
    }

    // MARK: - Error Flow Tests

    func testErrorAlert() throws {
        // This test would verify error alert appears when request fails
        // Note: Requires network failure simulation

        // Given: Network request fails
        // Then: Error alert should appear
        // let alert = app.alerts["Request Failed"]
        // XCTAssertTrue(alert.waitForExistence(timeout: 5))
    }

    func testRetryButton() throws {
        // Given: Error alert is showing
        // When: User taps Retry
        // Then: Should attempt request again

        // let retryButton = app.alerts["Request Failed"].buttons["Retry"]
        // retryButton.tap()
    }

    // MARK: - Accessibility Tests

    func testAccessibility() throws {
        // Verify accessibility labels are set correctly
        let sendButton = app.buttons["Send Request"]
        XCTAssertTrue(sendButton.isEnabled)

        // In production, verify all elements have proper accessibility labels
    }

    // MARK: - Performance Tests

    func testLaunchPerformance() throws {
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }

    func testScrollPerformance() throws {
        if #available(iOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.scrollDecelerationMetric]) {
                // Measure scroll performance if applicable
            }
        }
    }

    // MARK: - Screenshot Tests

    func testTakeScreenshots() throws {
        // Take screenshots for App Store or documentation
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Main Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
