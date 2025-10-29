//
//  ConvexAPIClient.swift
//  TaivelAppClip
//
//  HTTP API client for Convex.dev backend
//

import Foundation
import CoreLocation

enum ConvexAPIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case serverError(String)
    case timeout

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid API endpoint URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let message):
            return "Server error: \(message)"
        case .timeout:
            return "Request timed out"
        }
    }
}

class ConvexAPIClient {
    // MARK: - Properties

    static let shared = ConvexAPIClient()

    // Convex deployment URL - configured for production
    private let baseURL = "https://utmost-clam-977.convex.cloud"
    private let endpoint = "/api/mutation"
    private let timeout: TimeInterval = 3.0

    private let session: URLSession

    // MARK: - Initialization

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        self.session = URLSession(configuration: config)
    }

    // MARK: - Public Methods

    /// Sends location data to Convex backend
    /// - Parameter location: Optional CLLocationCoordinate2D with user's location
    /// - Returns: Success response from Convex
    func sendLocation(_ location: CLLocationCoordinate2D?) async throws -> ConvexSuccessResponse {
        guard let url = URL(string: baseURL + endpoint) else {
            throw ConvexAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Build request payload
        var args: [String: Any] = [:]
        if let location = location {
            args["latitude"] = location.latitude
            args["longitude"] = location.longitude
        }

        let payload: [String: Any] = [
            "path": "location:send",
            "args": args,
            "format": "json"
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            throw ConvexAPIError.networkError(error)
        }

        // Execute request
        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw ConvexAPIError.invalidResponse
            }

            // Check for HTTP errors
            guard (200...299).contains(httpResponse.statusCode) else {
                // Try to parse error response
                if let errorResponse = try? JSONDecoder().decode(ConvexErrorResponse.self, from: data) {
                    throw ConvexAPIError.serverError(errorResponse.errorMessage ?? "Unknown error")
                }
                throw ConvexAPIError.serverError("HTTP \(httpResponse.statusCode)")
            }

            // Parse success response
            let successResponse = try JSONDecoder().decode(ConvexSuccessResponse.self, from: data)

            // Verify status is "success"
            guard successResponse.status == "success" else {
                throw ConvexAPIError.serverError("Response status is not success")
            }

            return successResponse

        } catch let error as ConvexAPIError {
            throw error
        } catch let error as URLError where error.code == .timedOut {
            throw ConvexAPIError.timeout
        } catch {
            throw ConvexAPIError.networkError(error)
        }
    }

    // MARK: - Configuration

    /// Updates the base URL for the Convex deployment
    /// - Parameter url: New base URL
    func setBaseURL(_ url: String) {
        // Note: In a production app, you'd want to make baseURL mutable
        // For now, this is a placeholder for configuration
        print("⚠️ Base URL should be configured: \(url)")
    }
}
