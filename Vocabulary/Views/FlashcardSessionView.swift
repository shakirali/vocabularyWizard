//
//  FlashcardSessionView.swift
//  Vocabulary
//
//  Shows a batch of 5 flashcards for the selected year group.
//

import SwiftUI

struct FlashcardSessionView: View {
    @StateObject private var viewModel: FlashcardSessionViewModel
    private let tts: TextToSpeechService

    init(
        year: YearGroup,
        repository: VocabularyRepository,
        progressStore: ProgressStore,
        tts: TextToSpeechService
    ) {
        _viewModel = StateObject(
            wrappedValue: FlashcardSessionViewModel(
                year: year,
                repository: repository,
                progressStore: progressStore
            )
        )
        self.tts = tts
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar (no extra dots – TabView page control is enough)
                VStack(spacing: 8) {
                    HStack {
                        Text("Today's Words")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(.label))
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)

                if viewModel.isLoading {
                    ProgressView("Loading words…")
                        .padding()
                } else if let message = viewModel.errorMessage {
                    Text(message)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.currentBatch.isEmpty {
                    Text("No words available yet.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    Spacer(minLength: 24)

                    TabView {
                        ForEach(viewModel.currentBatch) { item in
                            FlashcardView(item: item, tts: tts) {
                                viewModel.markMemorized(item)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .accessibilityIdentifier("flashcard-\(item.id)")
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(height: 460)
                    // Keep the same soft background behind the card as the rest of the screen
                    .background(Color(.systemGroupedBackground))

                    Spacer(minLength: 16)
                }
            }
        }
        .task {
            await viewModel.load()
        }
    }
}
