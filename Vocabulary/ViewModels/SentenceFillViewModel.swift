//
//  SentenceFillViewModel.swift
//  Vocabulary
//
//  Manages sentence fill-in-the-blank questions.
//

import Foundation
import Combine

@MainActor
final class SentenceFillViewModel: ObservableObject {
    @Published private(set) var questions: [SentenceQuestion] = []
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var isFinished: Bool = false

    private let repository: VocabularyRepository
    private let year: YearGroup

    init(
        year: YearGroup,
        repository: VocabularyRepository
    ) {
        self.year = year
        self.repository = repository
    }

    var currentQuestion: SentenceQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    func load() async {
        isFinished = false
        currentIndex = 0
        do {
            let items = try await repository.getWords(for: year)
            questions = makeQuestions(from: items)
        } catch {
            questions = []
        }
    }

    func advance() {
        guard !isFinished else { return }
        if currentIndex + 1 < questions.count {
            currentIndex += 1
        } else {
            isFinished = true
        }
    }

    // MARK: - Private

    private func makeQuestions(from items: [VocabularyItem]) -> [SentenceQuestion] {
        let candidates = items.filter { !$0.exampleSentences.isEmpty }
        guard candidates.count >= 2 else { return [] }
        var questions: [SentenceQuestion] = []
        let shuffled = candidates.shuffled()
        for item in shuffled {
            guard let sentence = item.exampleSentences.first else { continue }
            let template = sentence.replacingOccurrences(of: item.word, with: "{word}")
            var distractors = shuffled.filter { $0.id != item.id }.map(\.word).shuffled()
            distractors = Array(distractors.prefix(3))
            var options = distractors
            if options.count < 3 {
                continue
            }
            let correctIndex = Int.random(in: 0...options.count)
            options.insert(item.word, at: correctIndex)
            let question = SentenceQuestion(
                sentenceTemplate: template,
                correctWord: item.word,
                options: options
            )
            questions.append(question)
        }
        return questions
    }
}


