//
//  QuizQuestion.swift
//  Vocabulary
//
//  Model for multiple-choice quiz questions based on vocabulary items.
//

import Foundation

struct QuizQuestion: Identifiable, Hashable {
    enum QuestionType {
        case meaning
    }

    let id = UUID()
    let item: VocabularyItem
    let options: [String]
    let correctIndex: Int
    let type: QuestionType

    var prompt: String {
        switch type {
        case .meaning:
            return item.word
        }
    }
}
