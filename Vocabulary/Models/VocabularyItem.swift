//
//  VocabularyItem.swift
//  Vocabulary
//
//  Core vocabulary model representing a single word entry.
//

import Foundation

struct VocabularyItem: Identifiable, Codable, Hashable {
    let id: UUID
    let year: YearGroup
    let word: String
    let meaning: String
    let antonyms: [String]
    let exampleSentences: [String]

    init(
        id: UUID = UUID(),
        year: YearGroup,
        word: String,
        meaning: String,
        antonyms: [String],
        exampleSentences: [String]
    ) {
        self.id = id
        self.year = year
        self.word = word
        self.meaning = meaning
        self.antonyms = antonyms
        self.exampleSentences = exampleSentences
    }
}


