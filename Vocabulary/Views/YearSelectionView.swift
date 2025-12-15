//
//  YearSelectionView.swift
//  Vocabulary
//
//  Entry screen where kids pick their year group.
//

import SwiftUI

struct YearSelectionView: View {
    @StateObject private var viewModel: YearSelectionViewModel
    private let repository: VocabularyRepository
    private let progressStore: ProgressStore
    private let tts: TextToSpeechService

    init(
        repository: VocabularyRepository,
        progressStore: ProgressStore,
        tts: TextToSpeechService
    ) {
        _viewModel = StateObject(
            wrappedValue: YearSelectionViewModel(repository: repository)
        )
        self.repository = repository
        self.progressStore = progressStore
        self.tts = tts
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar: simple back & skip layout
                HStack {
                    NavigationLink {
                        WelcomeView(
                            repository: repository,
                            progressStore: progressStore,
                            tts: tts
                        )
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(.label))
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color(.systemBackground))
                                    .opacity(0.9)
                            )
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Button {
                        // No-op for now – could later skip to most recent year.
                    } label: {
                        Text("Skip")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.secondary)
                            .textCase(.uppercase)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
                .padding(.top, 8)

                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Hi! 👋\nWhich year are you in?")
                                .font(.system(size: 30, weight: .heavy, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(.label))
                        }
                        .padding(.top, 24)

                        // Year cards in a grid, inspired by the design pack
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(viewModel.years) { year in
                                NavigationLink {
                                    YearDashboardView(
                                        year: year,
                                        repository: repository,
                                        progressStore: progressStore,
                                        tts: tts
                                    )
                                } label: {
                                    VStack(alignment: .leading, spacing: 6) {
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .fill(yearCardColor(for: year).opacity(0.16))
                                            .frame(height: 80)
                                            .overlay(
                                                Image(systemName: "sparkles")
                                                    .font(.system(size: 28, weight: .bold))
                                                    .foregroundColor(yearCardColor(for: year))
                                            )

                                        Text(year.displayName)
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(Color(.label))

                                        Text(yearSubtitle(for: year))
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(12)
                                    .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .fill(Color(.systemBackground))
                                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                                    )
                                }
                                .buttonStyle(.plain)
                                .accessibilityIdentifier("year-\(year.shortCode)")
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 32)
                }

                // Bottom helper + CTA
                VStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Text("Not sure?")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                        Button {
                            // Placeholder; no dedicated flow yet.
                        } label: {
                            Text("Ask a parent!")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(red: 0.17, green: 0.68, blue: 0.93))
                                .underline()
                        }
                        .buttonStyle(.plain)
                    }

                    Text("Let's Go!")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
        }
        // Hide the default navigation bar/back button so we only show the custom circular back button
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Private helpers

private extension YearSelectionView {
    func yearCardColor(for year: YearGroup) -> Color {
        switch year {
        case .year3:
            return Color.green
        case .year4:
            return Color.blue
        case .year5:
            return Color.orange
        case .year6:
            return Color.purple
        }
    }

    func yearSubtitle(for year: YearGroup) -> String {
        switch year {
        case .year3:
            return "Starter"
        case .year4:
            return "Explorer"
        case .year5:
            return "Challenger"
        case .year6:
            return "Master"
        }
    }
}



