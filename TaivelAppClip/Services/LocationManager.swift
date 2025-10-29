//
//  LocationManager.swift
//  TaivelAppClip
//
//  Manages location services and tracks first-use permission request
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    // MARK: - Properties

    static let shared = LocationManager()

    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var isLocationAvailable: Bool = false

    private let locationManager = CLLocationManager()
    private let hasRequestedLocationKey = "HasRequestedLocationPermission"

    // MARK: - Computed Properties

    /// Check if this is the first time we're requesting location
    var isFirstUse: Bool {
        return !UserDefaults.standard.bool(forKey: hasRequestedLocationKey)
    }

    /// Check if we should request location (first use only)
    var shouldRequestLocation: Bool {
        return isFirstUse
    }

    // MARK: - Initialization

    private override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // MARK: - Public Methods

    /// Request location permission (only on first use)
    func requestLocationIfNeeded() {
        guard isFirstUse else {
            print("📍 Location already requested previously, skipping")
            return
        }

        print("📍 First use detected, requesting location permission")
        locationManager.requestWhenInUseAuthorization()

        // Mark that we've requested location
        UserDefaults.standard.set(true, forKey: hasRequestedLocationKey)
    }

    /// Start updating location
    func startUpdatingLocation() {
        guard authorizationStatus == .authorizedWhenInUse ||
              authorizationStatus == .authorizedAlways else {
            print("📍 Location not authorized")
            return
        }

        print("📍 Starting location updates")
        locationManager.startUpdatingLocation()
    }

    /// Stop updating location
    func stopUpdatingLocation() {
        print("📍 Stopping location updates")
        locationManager.stopUpdatingLocation()
    }

    /// Get current location coordinate or nil if not available
    func getLocationForRequest() -> CLLocationCoordinate2D? {
        guard shouldRequestLocation else {
            print("📍 Not first use, returning nil location")
            return nil
        }

        guard authorizationStatus == .authorizedWhenInUse ||
              authorizationStatus == .authorizedAlways else {
            print("📍 Location not authorized, returning nil")
            return nil
        }

        guard let location = currentLocation else {
            print("📍 No current location available")
            return nil
        }

        print("📍 Returning location: \(location.latitude), \(location.longitude)")
        return location
    }

    /// Reset first-use flag (for testing purposes)
    func resetFirstUseFlag() {
        UserDefaults.standard.removeObject(forKey: hasRequestedLocationKey)
        print("📍 Reset first-use flag")
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .notDetermined:
            print("📍 Authorization: Not Determined")
        case .restricted:
            print("📍 Authorization: Restricted")
            isLocationAvailable = false
        case .denied:
            print("📍 Authorization: Denied")
            isLocationAvailable = false
        case .authorizedAlways, .authorizedWhenInUse:
            print("📍 Authorization: Granted")
            isLocationAvailable = true
            startUpdatingLocation()
        @unknown default:
            print("📍 Authorization: Unknown")
            isLocationAvailable = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        currentLocation = location.coordinate
        print("📍 Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")

        // Stop updating after first location to save battery
        stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("📍 Location error: \(error.localizedDescription)")
        isLocationAvailable = false
    }
}
