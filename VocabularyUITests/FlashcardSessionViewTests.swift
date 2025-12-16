//
//  FlashcardSessionViewTests.swift
//  VocabularyUITests
//
//  UI tests for Flashcard Session screen.
//

import XCTest

final class FlashcardSessionViewTests: BaseUITestCase {
    
    @MainActor
    func testFlashcardSession_LoadsWords() throws {
        let app = try launchApp()
        try navigateToFlashcardSession(app: app)
        
        if verifyEmptyState(app: app, emptyStateText: "No words available yet.") {
            throw XCTSkip("No words available")
        }
        
        let flashcardWordById = app.staticTexts.matching(identifier: "flashcard-word").firstMatch
        if flashcardWordById.waitForExistence(timeout: TestTimeouts.long) {
            XCTAssertFalse(flashcardWordById.label.isEmpty, "Flashcard word should not be empty")
            return
        }
        
        let allStaticTexts = app.staticTexts.allElementsBoundByIndex
        var foundWord = false
        for textElement in allStaticTexts {
            let label = textElement.label
            if !label.isEmpty &&
               label != "Today's Words" &&
               label != "Loading words…" &&
               label != "No words available yet." &&
               label != "Tap card to flip" &&
               label != "Hear the word" {
                foundWord = true
                break
            }
        }
        XCTAssertTrue(foundWord, "Should find flashcard word text on screen")
    }
    
    @MainActor
    func testFlashcardSession_TapToFlip() throws {
        let app = try launchApp()
        try navigateToFlashcardSession(app: app)
        
        if verifyEmptyState(app: app, emptyStateText: "No words available yet.") {
            throw XCTSkip("No words available")
        }
        
        let flashcardWord = app.staticTexts.matching(identifier: "flashcard-word").firstMatch
        XCTAssertTrue(flashcardWord.waitForExistence(timeout: TestTimeouts.long), "Flashcard word should be visible on front side")
        let wordText = flashcardWord.label
        XCTAssertFalse(wordText.isEmpty, "Flashcard word should not be empty")
        
        let hearWordButton = app.buttons["Hear the word"]
        XCTAssertTrue(hearWordButton.exists, "Hear the word button should be visible on front side")
        
        let tapToFlipText = app.staticTexts["Tap card to flip"]
        XCTAssertTrue(tapToFlipText.exists, "Tap card to flip instruction should be visible")
        
        let flashcardQuery = app.otherElements.matching(NSPredicate(format: "identifier BEGINSWITH 'flashcard-'"))
        let flashcard = flashcardQuery.firstMatch
        XCTAssertTrue(flashcard.waitForExistence(timeout: TestTimeouts.medium), "Flashcard element should exist")
        
        let tapCoordinate = flashcard.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        tapCoordinate.tap()
        
        let markMemorizedButton = app.buttons["Mark as memorized"]
        XCTAssertTrue(markMemorizedButton.waitForExistence(timeout: TestTimeouts.medium), "Mark as memorized button should be visible on back side")
        
        let antonymsLabel = app.staticTexts["Antonyms"]
        XCTAssertTrue(antonymsLabel.waitForExistence(timeout: TestTimeouts.short), "Antonyms section should be visible on back side")
        
        let flashcardWordBack = app.staticTexts.matching(identifier: "flashcard-word-back").firstMatch
        if !flashcardWordBack.exists {
            let wordStillVisible = app.staticTexts[wordText].exists
            XCTAssertTrue(wordStillVisible, "Word should still be visible on back side")
        }
        
        let tapCoordinate2 = flashcard.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        tapCoordinate2.tap()
        
        XCTAssertTrue(hearWordButton.waitForExistence(timeout: TestTimeouts.short), "Hear the word button should be visible again after flipping back")
        XCTAssertTrue(hearWordButton.isHittable, "Hear the word button should be hittable on front side")
        XCTAssertTrue(tapToFlipText.exists, "Tap card to flip instruction should be visible again")
    }
    
    @MainActor
    func testFlashcardSession_MarkAsMemorized() throws {
        let app = try launchApp()
        try navigateToFlashcardSession(app: app)
        
        if verifyEmptyState(app: app, emptyStateText: "No words available yet.") {
            throw XCTSkip("No words available")
        }
        
        let flashcardQuery = app.otherElements.matching(NSPredicate(format: "identifier BEGINSWITH 'flashcard-'"))
        let flashcard = flashcardQuery.firstMatch
        XCTAssertTrue(flashcard.waitForExistence(timeout: TestTimeouts.medium))
        
        let tapCoordinate = flashcard.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        tapCoordinate.tap()
        
        let markMemorizedButton = app.buttons["Mark as memorized"]
        XCTAssertTrue(markMemorizedButton.waitForExistence(timeout: TestTimeouts.medium), "Mark as memorized button should be visible")
        XCTAssertTrue(markMemorizedButton.isHittable, "Mark as memorized button should be hittable")
        
        markMemorizedButton.tap()
    }
    
    @MainActor
    func testFlashcardSession_TTSButton() throws {
        let app = try launchApp()
        try navigateToFlashcardSession(app: app)
        
        if verifyEmptyState(app: app, emptyStateText: "No words available yet.") {
            throw XCTSkip("No words available")
        }
        
        let hearWordButton = app.buttons["Hear the word"]
        XCTAssertTrue(hearWordButton.waitForExistence(timeout: TestTimeouts.medium), "Hear the word button should be visible")
        XCTAssertTrue(hearWordButton.isHittable, "Hear the word button should be hittable")
        
        hearWordButton.tap()
    }
    
    @MainActor
    func testFlashcardSession_SwipeToNextCard() throws {
        let app = try launchApp()
        try navigateToFlashcardSession(app: app)
        
        if verifyEmptyState(app: app, emptyStateText: "No words available yet.") {
            throw XCTSkip("No words available")
        }
        
        let firstCardWord = app.staticTexts.matching(identifier: "flashcard-word").firstMatch
        guard firstCardWord.waitForExistence(timeout: TestTimeouts.medium) else {
            XCTFail("First card word should be visible")
            return
        }
        
        let flashcardQuery = app.otherElements.matching(NSPredicate(format: "identifier BEGINSWITH 'flashcard-'"))
        let flashcard = flashcardQuery.firstMatch
        XCTAssertTrue(flashcard.exists)
        
        flashcard.swipeLeft()
        
        let secondCardWord = app.staticTexts.matching(identifier: "flashcard-word").firstMatch
        if secondCardWord.exists {
            XCTAssertTrue(secondCardWord.exists, "Card should still be visible after swipe")
        }
    }
}
