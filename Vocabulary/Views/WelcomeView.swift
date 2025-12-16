//
//  WelcomeView.swift
//  Vocabulary
//
//  Kid-friendly landing screen inspired by the Stitch "welcome_screen".
//

import SwiftUI

struct WelcomeView: View {
    private let repository: VocabularyRepository
    private let progressStore: ProgressStore
    private let tts: TextToSpeechService

    init(
        repository: VocabularyRepository,
        progressStore: ProgressStore,
        tts: TextToSpeechService
    ) {
        self.repository = repository
        self.progressStore = progressStore
        self.tts = tts
    }

    var body: some View {
        ZStack {
            // Background blobs to mimic colorful Tailwind design
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            Circle()
                .fill(Color.blue.opacity(0.10))
                .frame(width: 360, height: 360)
                .blur(radius: 40)
                .offset(x: -160, y: -260)

            Circle()
                .fill(Color.yellow.opacity(0.12))
                .frame(width: 420, height: 420)
                .blur(radius: 60)
                .offset(x: 140, y: 260)

            VStack {
                // Top "Parents" pill
                HStack {
                    Spacer()
                    Button {
                        // Future: Navigate to parents/guide screen
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray)
                            Text("Parents")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Spacer()

                // Hero illustration substitute
                ZStack {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.17, green: 0.68, blue: 0.93),
                                    Color(red: 0.43, green: 0.83, blue: 0.99)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(maxWidth: 320, maxHeight: 320)
                        .aspectRatio(1, contentMode: .fit)
                        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .stroke(Color.white.opacity(0.35), lineWidth: 4)
                        )

                    VStack(spacing: 16) {
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 72, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)

                        HStack(spacing: 12) {
                            ForEach(0..<4) { index in
                                Circle()
                                    .fill(Color.white.opacity(0.85))
                                    .frame(width: 10, height: 10)
                                    .offset(y: index.isMultiple(of: 2) ? -4 : 4)
                            }
                        }
                    }
                }
                .padding(.bottom, 24)

                // Title + subtitle
                VStack(spacing: 8) {
                    Text("WordWizards")
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(.label))
                        .tracking(-0.5)

                    Text("Master your words on a magical journey!")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 260)

                    HStack(spacing: 6) {
                        Image(systemName: "graduationcap.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.17, green: 0.68, blue: 0.93))
                        Text("Year 3–6")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(red: 0.17, green: 0.68, blue: 0.93))
                            .textCase(.uppercase)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color(red: 0.17, green: 0.68, blue: 0.93).opacity(0.12))
                    )
                    .padding(.top, 4)
                }
                .padding(.bottom, 24)

                // Primary CTA
                NavigationLink {
                    YearSelectionView(
                        repository: repository,
                        progressStore: progressStore,
                        tts: tts
                    )
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 22, weight: .semibold))
                        Text("Start Adventure")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .foregroundColor(Color(.systemBackground))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(red: 0.17, green: 0.68, blue: 0.93))
                            .shadow(color: Color(red: 0.12, green: 0.53, blue: 0.83), radius: 8, x: 0, y: 4)
                    )
                    .padding(.horizontal)
                }
                .buttonStyle(.plain)

                // "Already a wizard?" helper text
                HStack(spacing: 4) {
                    Text("Already a wizard?")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)
                    Button {
                        // Future: Implement authentication
                    } label: {
                        Text("Sign In")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(red: 0.17, green: 0.68, blue: 0.93))
                            .underline(pattern: .solid, color: Color(red: 0.17, green: 0.68, blue: 0.93))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
        }
    }
}
