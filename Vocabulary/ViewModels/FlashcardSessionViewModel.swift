//
//  FlashcardSessionViewModel.swift
//  Vocabulary
//
//  Manages flashcard learning sessions with 5 cards at a time.
//

import Foundation
import Combine

@MainActor
final class FlashcardSessionViewModel: ObservableObject {
    @Published private(set) var cards: [VocabularyItem] = []
    @Published private(set) var currentBatchIndex: Int = 0
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    private let repository: VocabularyRepository
    private let progressStore: ProgressStore
    private let year: YearGroup
    private let batchSize = 5

    init(
        year: YearGroup,
        repository: VocabularyRepository,
        progressStore: ProgressStore
    ) {
        self.year = year
        self.repository = repository
        self.progressStore = progressStore
    }

    var currentBatch: [VocabularyItem] {
        let start = currentBatchIndex * batchSize
        let end = min(start + batchSize, cards.count)
        guard start < end else { return [] }
        return Array(cards[start..<end])
    }

    var hasNextBatch: Bool {
        (currentBatchIndex + 1) * batchSize < cards.count
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            let words = try await repository.getWords(for: year)
            cards = words
            currentBatchIndex = 0
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func advanceBatch() {
        guard hasNextBatch else { return }
        currentBatchIndex += 1
    }

    func markMemorized(_ item: VocabularyItem) {
        progressStore.markWordMastered(item.id, year: year)
    }
}
