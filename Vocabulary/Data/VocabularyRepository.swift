//
//  VocabularyRepository.swift
//  Vocabulary
//
//  Abstraction for loading vocabulary content, allowing future swap to API-backed sources.
//

import Foundation

protocol VocabularyRepository {
    func getYears() -> [YearGroup]
    func getWords(for year: YearGroup) async throws -> [VocabularyItem]
}


