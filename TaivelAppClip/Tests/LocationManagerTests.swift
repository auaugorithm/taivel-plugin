//
//  LocationManagerTests.swift
//  TaivelAppClipTests
//
//  Unit tests for LocationManager
//

import XCTest
import CoreLocation
@testable import TaivelAppClip

class LocationManagerTests: XCTestCase {

    var locationManager: LocationManager!

    override func setUp() {
        super.setUp()
        // Reset UserDefaults for each test
        UserDefaults.standard.removeObject(forKey: "HasRequestedLocationPermission")
        locationManager = LocationManager.shared
    }

    override func tearDown() {
        // Clean up
        UserDefaults.standard.removeObject(forKey: "HasRequestedLocationPermission")
        locationManager = nil
        super.tearDown()
    }

    // MARK: - First Use Tests

    func testIsFirstUse_InitialState() {
        // Given: Fresh install
        UserDefaults.standard.removeObject(forKey: "HasRequestedLocationPermission")

        // When: Checking first use
        let isFirstUse = locationManager.isFirstUse

        // Then: Should be true
        XCTAssertTrue(isFirstUse, "Should be first use on fresh install")
    }

    func testIsFirstUse_AfterRequest() {
        // Given: Location has been requested
        UserDefaults.standard.set(true, forKey: "HasRequestedLocationPermission")

        // When: Checking first use
        let isFirstUse = locationManager.isFirstUse

        // Then: Should be false
        XCTAssertFalse(isFirstUse, "Should not be first use after request")
    }

    func testShouldRequestLocation_FirstUse() {
        // Given: First use
        UserDefaults.standard.removeObject(forKey: "HasRequestedLocationPermission")

        // When: Checking should request
        let shouldRequest = locationManager.shouldRequestLocation

        // Then: Should be true
        XCTAssertTrue(shouldRequest, "Should request location on first use")
    }

    func testShouldRequestLocation_SubsequentUse() {
        // Given: Not first use
        UserDefaults.standard.set(true, forKey: "HasRequestedLocationPermission")

        // When: Checking should request
        let shouldRequest = locationManager.shouldRequestLocation

        // Then: Should be false
        XCTAssertFalse(shouldRequest, "Should not request location on subsequent use")
    }

    // MARK: - Reset Tests

    func testResetFirstUseFlag() {
        // Given: Location has been requested
        UserDefaults.standard.set(true, forKey: "HasRequestedLocationPermission")
        XCTAssertFalse(locationManager.isFirstUse)

        // When: Resetting flag
        locationManager.resetFirstUseFlag()

        // Then: Should be first use again
        XCTAssertTrue(locationManager.isFirstUse, "Should be first use after reset")
    }

    // MARK: - Location for Request Tests

    func testGetLocationForRequest_NotFirstUse() {
        // Given: Not first use
        UserDefaults.standard.set(true, forKey: "HasRequestedLocationPermission")
        locationManager.currentLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)

        // When: Getting location for request
        let location = locationManager.getLocationForRequest()

        // Then: Should return nil
        XCTAssertNil(location, "Should return nil location on subsequent use")
    }

    func testGetLocationForRequest_FirstUseNoLocation() {
        // Given: First use but no location available
        UserDefaults.standard.removeObject(forKey: "HasRequestedLocationPermission")
        locationManager.currentLocation = nil
        locationManager.authorizationStatus = .notDetermined

        // When: Getting location for request
        let location = locationManager.getLocationForRequest()

        // Then: Should return nil
        XCTAssertNil(location, "Should return nil when no location available")
    }

    // MARK: - Performance Tests

    func testPerformanceFirstUseCheck() {
        measure {
            _ = locationManager.isFirstUse
        }
    }
}
