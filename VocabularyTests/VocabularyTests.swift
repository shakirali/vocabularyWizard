//
//  VocabularyTests.swift
//  VocabularyTests
//
//  Created by Shakir Ali on 15/12/2025.
//

import XCTest
@testable import Vocabulary

final class VocabularyTests: XCTestCase {

    func testDecodesYear3JSON() throws {
        guard let url = Bundle(for: type(of: self)).url(forResource: "Year3", withExtension: "json") ??
                Bundle.main.url(forResource: "Year3", withExtension: "json") else {
            XCTFail("Missing Year3.json in test bundle or main bundle")
            return
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let items = try decoder.decode([TestRawVocabularyItem].self, from: data)
        XCTAssertFalse(items.isEmpty, "Expected some year 3 items")
    }

    func testProgressStorePersistsMasteredWords() {
        // Use a unique suite name for this test to avoid conflicts
        let suiteName = "test.\(UUID().uuidString)"
        
        // Register cleanup in teardown to avoid memory issues
        addTeardownBlock {
            if let cleanupDefaults = UserDefaults(suiteName: suiteName) {
                cleanupDefaults.removePersistentDomain(forName: suiteName)
            }
        }
        
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            XCTFail("Failed to create UserDefaults with suite name")
            return
        }
        
        let store = UserDefaultsProgressStore(defaults: defaults)
        let id = UUID()

        XCTAssertTrue(store.masteredWordIDs(for: .year3).isEmpty)
        store.markWordMastered(id, year: .year3)
        defaults.synchronize() // Ensure data is persisted
        let mastered = store.masteredWordIDs(for: .year3)
        XCTAssertTrue(mastered.contains(id))
    }
}

// Mirror of raw JSON structure used in LocalJSONVocabularyRepository
private struct TestRawVocabularyItem: Codable {
    let id: String
    let word: String
    let meaning: String
    let antonyms: [String]
    let exampleSentences: [String]
}

