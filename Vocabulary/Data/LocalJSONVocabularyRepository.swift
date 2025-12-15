//
//  LocalJSONVocabularyRepository.swift
//  Vocabulary
//
//  Loads vocabulary from bundled JSON files per year.
//

import Foundation

final class LocalJSONVocabularyRepository: VocabularyRepository {
    private let decoder = JSONDecoder()

    func getYears() -> [YearGroup] {
        YearGroup.allCases
    }

    func getWords(for year: YearGroup) async throws -> [VocabularyItem] {
        let fileName: String
        switch year {
        case .year3: fileName = "Year3"
        case .year4: fileName = "Year4"
        case .year5: fileName = "Year5"
        case .year6: fileName = "Year6"
        }

        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw NSError(domain: "LocalJSONVocabularyRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing resource \(fileName).json"])
        }

        let data = try Data(contentsOf: url)
        let rawItems = try decoder.decode([RawVocabularyItem].self, from: data)
        return rawItems.compactMap { $0.toModel(for: year) }
    }
}

// MARK: - Raw DTO

private struct RawVocabularyItem: Codable {
    let id: UUID?
    let word: String
    let meaning: String
    let antonyms: [String]
    let exampleSentences: [String]

    func toModel(for year: YearGroup) -> VocabularyItem {
        VocabularyItem(
            id: id ?? UUID(),
            year: year,
            word: word,
            meaning: meaning,
            antonyms: antonyms,
            exampleSentences: exampleSentences
        )
    }
}
