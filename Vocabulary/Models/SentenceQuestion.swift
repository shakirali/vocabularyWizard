//
//  SentenceQuestion.swift
//  Vocabulary
//
//  Model representing a fill-in-the-blank sentence question.
//

import Foundation

struct SentenceQuestion: Identifiable, Hashable {
    let id = UUID()
    let sentenceTemplate: String
    let correctWord: String
    let options: [String]

    var displaySentence: String {
        sentenceTemplate.replacingOccurrences(of: "{word}", with: "_____")
    }
}


