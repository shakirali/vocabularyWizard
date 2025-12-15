//
//  YearDashboardView.swift
//  Vocabulary
//
//  Dashboard for a selected year, giving access to learning modes.
//

import SwiftUI

struct YearDashboardView: View {
    let year: YearGroup
    private let repository: VocabularyRepository
    private let progressStore: ProgressStore
    private let tts: TextToSpeechService

    init(
        year: YearGroup,
        repository: VocabularyRepository,
        progressStore: ProgressStore,
        tts: TextToSpeechService
    ) {
        self.year = year
        self.repository = repository
        self.progressStore = progressStore
        self.tts = tts
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header meta similar to quiz_selection_screen
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color(.systemBackground))
                                .frame(width: 44, height: 44)
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            Text(String(year.shortCode.suffix(1)))
                                .font(.system(size: 22, weight: .black, design: .rounded))
                                .foregroundColor(Color(red: 0.17, green: 0.68, blue: 0.93))
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Time to practise!")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                            Text(year.displayName)
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                                .foregroundColor(Color(.label))
                        }
                    }

                    HStack {
                        Text("Current Level:")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)
                        Text(year.displayName)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(red: 0.17, green: 0.68, blue: 0.93))
                        Spacer()
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                ScrollView {
                    VStack(spacing: 20) {
                        // Flashcard learning card
                        NavigationLink {
                            FlashcardSessionView(
                                year: year,
                                repository: repository,
                                progressStore: progressStore,
                                tts: tts
                            )
                        } label: {
                            DashboardModeCard(
                                iconName: "rectangle.on.rectangle.angled",
                                iconBackground: Color.blue.opacity(0.15),
                                iconTint: Color.blue,
                                title: "Flashcard Flip",
                                subtitle: "Learn new words and their opposites.",
                                accentLabel: "Learn",
                                accentColor: Color.green
                            )
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("flashcard-flip-card")

                        // Quiz (memorized words)
                        NavigationLink {
                            QuizView(
                                year: year,
                                repository: repository,
                                progressStore: progressStore
                            )
                        } label: {
                            DashboardModeCard(
                                iconName: "checkmark.circle",
                                iconBackground: Color.purple.opacity(0.15),
                                iconTint: Color.purple,
                                title: "Flashcard Quiz",
                                subtitle: "Test yourself on the words you know.",
                                accentLabel: "Popular",
                                accentColor: Color.orange
                            )
                        }
                        .buttonStyle(.plain)

                        // Sentence practice
                        NavigationLink {
                            SentenceFillView(
                                year: year,
                                repository: repository
                            )
                        } label: {
                            DashboardModeCard(
                                iconName: "text.cursor",
                                iconBackground: Color(red: 0.96, green: 0.90, blue: 0.99),
                                iconTint: Color(red: 0.59, green: 0.30, blue: 0.90),
                                title: "Fill in the Sentence",
                                subtitle: "Choose the word that fits the sentence.",
                                accentLabel: "New",
                                accentColor: Color(red: 0.59, green: 0.30, blue: 0.90)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 24)
                }
            }
        }
    }
}

// MARK: - Reusable dashboard card

private struct DashboardModeCard: View {
    let iconName: String
    let iconBackground: Color
    let iconTint: Color
    let title: String
    let subtitle: String
    let accentLabel: String
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(iconBackground)
                        .frame(width: 52, height: 52)
                    Image(systemName: iconName)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(iconTint)
                }

                Spacer()

                Text(accentLabel)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(accentColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(accentColor.opacity(0.15))
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(.label))
                    .accessibilityIdentifier("mode-card-title")
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
        )
    }
}


