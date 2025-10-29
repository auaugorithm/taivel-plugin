//
//  ContentView.swift
//  TaivelAppClip
//
//  Main view with Send Request button
//

import SwiftUI
import CoreLocation

enum RequestState {
    case idle
    case requesting
    case success
    case error(String)
}

struct ContentView: View {
    // MARK: - Properties

    @StateObject private var locationManager = LocationManager.shared
    @State private var requestState: RequestState = .idle
    @State private var showingLocationPrompt = false

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                // Content
                VStack(spacing: 40) {
                    // Logo/Title area
                    VStack(spacing: 16) {
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)

                        Text("Taivel")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Location Request App Clip")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 60)

                    Spacer()

                    // Main action button
                    mainButton

                    // Status indicator
                    statusView

                    Spacer()

                    // Info text
                    if locationManager.isFirstUse {
                        Text("Location will be requested on first use")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
            .sheet(isPresented: .constant(requestState.isSuccess)) {
                SuccessView(onDismiss: { resetState() })
            }
            .alert("Request Failed", isPresented: .constant(requestState.isError), presenting: requestState.errorMessage) { _ in
                Button("Retry") {
                    Task { await sendRequest() }
                }
                Button("Cancel", role: .cancel) {
                    resetState()
                }
            } message: { errorMessage in
                Text(errorMessage)
            }
        }
    }

    // MARK: - Subviews

    private var mainButton: some View {
        Button(action: {
            Task {
                await sendRequest()
            }
        }) {
            HStack(spacing: 12) {
                if case .requesting = requestState {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: "paperplane.fill")
                }

                Text(buttonTitle)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.white.opacity(0.2))
            .foregroundColor(.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
        }
        .disabled(requestState.isRequesting)
        .padding(.horizontal, 40)
    }

    private var statusView: some View {
        Group {
            if case .requesting = requestState {
                VStack(spacing: 8) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    Text("Sending request...")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
            }
        }
        .frame(height: 60)
    }

    // MARK: - Computed Properties

    private var buttonTitle: String {
        switch requestState {
        case .idle:
            return "Send Request"
        case .requesting:
            return "Sending..."
        case .success:
            return "Success!"
        case .error:
            return "Retry"
        }
    }

    // MARK: - Methods

    private func sendRequest() async {
        requestState = .requesting

        // Request location if first use
        if locationManager.isFirstUse {
            locationManager.requestLocationIfNeeded()

            // Wait a bit for location permission and acquisition
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        }

        // Get location (will be nil if not first use or not authorized)
        let location = locationManager.getLocationForRequest()

        // Send to Convex
        do {
            let response = try await ConvexAPIClient.shared.sendLocation(location)
            print("✅ Success: \(response)")
            requestState = .success
        } catch let error as ConvexAPIError {
            print("❌ Error: \(error.localizedDescription)")
            requestState = .error(error.localizedDescription)
        } catch {
            print("❌ Error: \(error.localizedDescription)")
            requestState = .error(error.localizedDescription)
        }
    }

    private func resetState() {
        requestState = .idle
    }
}

// MARK: - RequestState Extensions

extension RequestState {
    var isRequesting: Bool {
        if case .requesting = self {
            return true
        }
        return false
    }

    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }

    var isError: Bool {
        if case .error = self {
            return true
        }
        return false
    }

    var errorMessage: String? {
        if case .error(let message) = self {
            return message
        }
        return nil
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
