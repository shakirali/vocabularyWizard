//
//  QuizViewModel.swift
//  Vocabulary
//
//  Manages multiple-choice quiz using mastered words.
//

import Foundation

@MainActor
final class QuizViewModel: ObservableObject {
    @Published private(set) var questions: [QuizQuestion] = []
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var correctCount: Int = 0
    @Published private(set) var isFinished: Bool = false

    private let repository: VocabularyRepository
    private let progressStore: ProgressStore
    private let year: YearGroup

    init(
        year: YearGroup,
        repository: VocabularyRepository,
        progressStore: ProgressStore
    ) {
        self.year = year
        self.repository = repository
        self.progressStore = progressStore
    }

    var currentQuestion: QuizQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    func load() async {
        isFinished = false
        correctCount = 0
        currentIndex = 0
        let mastered = progressStore.masteredWordIDs(for: year)
        guard !mastered.isEmpty else {
            questions = []
            return
        }
        do {
            let items = try await repository.getWords(for: year)
            let masteredItems = items.filter { mastered.contains($0.id) }
            questions = makeQuestions(from: masteredItems)
        } catch {
            questions = []
        }
    }

    func answer(optionIndex: Int) {
        guard !isFinished, let question = currentQuestion else { return }
        if optionIndex == question.correctIndex {
            correctCount += 1
        }
        if currentIndex + 1 < questions.count {
            currentIndex += 1
        } else {
            isFinished = true
        }
    }

    // MARK: - Private

    private func makeQuestions(from items: [VocabularyItem]) -> [QuizQuestion] {
        guard items.count >= 2 else { return [] }
        var questions: [QuizQuestion] = []
        let shuffled = items.shuffled()
        for item in shuffled {
            var distractors = shuffled.filter { $0.id != item.id }.map(\.meaning).shuffled()
            distractors = Array(distractors.prefix(3))
            var options = distractors
            let correctIndex = Int.random(in: 0...options.count)
            options.insert(item.meaning, at: correctIndex)
            let question = QuizQuestion(
                item: item,
                options: options,
                correctIndex: correctIndex,
                type: .meaning
            )
            questions.append(question)
        }
        return questions
    }
}
