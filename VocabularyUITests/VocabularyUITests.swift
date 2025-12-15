//
//  VocabularyUITests.swift
//  VocabularyUITests
//
//  Created by Shakir Ali on 15/12/2025.
//

import XCTest

final class VocabularyUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func launchApp() throws -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["WordWizards"].waitForExistence(timeout: 5))
        return app
    }
    
    @MainActor
    func testExample() throws {
        do {
            let app = try launchApp()
            let element = app.buttons.matching(identifier: "Start Adventure").firstMatch
            element.tap()
        } catch {
            XCTFail("Launch failed: \(error)")
        }
    }

    @MainActor
    func testFlashcardFlow() throws {
        let app = try launchApp()

        // Tap "Start Adventure" button to navigate to year selection
        let startButton = app.buttons["Start Adventure"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 5), "Start Adventure button should exist")
        startButton.tap()

        // Wait for year selection screen and select Year 3
        let year3Button = app.buttons.matching(identifier: "year-Y3").firstMatch
        XCTAssertTrue(year3Button.waitForExistence(timeout: 5), "Year 3 button should exist")
        year3Button.tap()

        // Wait for dashboard and tap Flashcard Flip card
        let flashcardCard = app.buttons.matching(identifier: "flashcard-flip-card").firstMatch
        XCTAssertTrue(flashcardCard.waitForExistence(timeout: 5), "Flashcard Flip card should exist")
        flashcardCard.tap()

        // Wait for flashcard session screen to appear (check for "Today's Words" header)
        let headerText = app.staticTexts["Today's Words"]
        XCTAssertTrue(headerText.waitForExistence(timeout: 5), "Flashcard session header should appear")

        // Wait for flashcard content to load - check that we're not in loading or error state
        // Wait a bit for async loading to complete
        sleep(2)
        
        // Check for empty state first to provide better error message
        let emptyStateText = app.staticTexts["No words available yet."]
        if emptyStateText.exists {
            XCTFail("Flashcard session shows empty state - words may not be loaded from JSON")
            return
        }
        
        // Try to find flashcard word by identifier first
        let flashcardWordById = app.staticTexts.matching(identifier: "flashcard-word").firstMatch
        if flashcardWordById.waitForExistence(timeout: 10) {
            XCTAssertFalse(flashcardWordById.label.isEmpty, "Flashcard word should not be empty")
            return
        }
        
        // Fallback: Look for any visible text that might be a word (not UI labels)
        // The flashcard should have visible text content
        let allStaticTexts = app.staticTexts.allElementsBoundByIndex
        var foundWord = false
        for textElement in allStaticTexts {
            let label = textElement.label
            // Skip UI labels and look for actual word content (non-empty, not "Today's Words", etc.)
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
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
