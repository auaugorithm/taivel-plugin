//
//  SuccessView.swift
//  TaivelAppClip
//
//  Success screen displayed after successful request
//

import SwiftUI

struct SuccessView: View {
    // MARK: - Properties

    let onDismiss: () -> Void

    @State private var showCheckmark = false
    @State private var showContent = false

    // MARK: - Body

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.green.opacity(0.7), Color.blue.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                // Success checkmark animation
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 120, height: 120)

                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 120, height: 120)

                    Image(systemName: "checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                        .scaleEffect(showCheckmark ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showCheckmark)
                }

                // Success message
                VStack(spacing: 12) {
                    Text("Request Sent!")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Your location data has been successfully sent to the server.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut(duration: 0.4).delay(0.3), value: showContent)

                Spacer()

                // Done button
                Button(action: {
                    onDismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white)
                        .foregroundColor(.green)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(0.5), value: showContent)
            }
        }
        .onAppear {
            showCheckmark = true
            showContent = true
        }
    }
}

// MARK: - Preview

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView(onDismiss: {})
    }
}
