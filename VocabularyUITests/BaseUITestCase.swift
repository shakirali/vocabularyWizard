//
//  BaseUITestCase.swift
//  VocabularyUITests
//
//  Base test case with common utilities for UI tests.
//

import XCTest

enum TestTimeouts {
    static let short: TimeInterval = 2
    static let medium: TimeInterval = 5
    static let long: TimeInterval = 10
}

class BaseUITestCase: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    @MainActor
    func launchApp() throws -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["WordWizards"].waitForExistence(timeout: TestTimeouts.medium))
        return app
    }
    
    @MainActor
    func navigateToYear3Dashboard(app: XCUIApplication) throws {
        let startButton = app.buttons["Start Adventure"]
        XCTAssertTrue(startButton.waitForExistence(timeout: TestTimeouts.medium), "Start Adventure button should exist")
        startButton.tap()
        
        let year3Button = app.buttons.matching(identifier: "year-Y3").firstMatch
        XCTAssertTrue(year3Button.waitForExistence(timeout: TestTimeouts.medium), "Year 3 button should exist")
        year3Button.tap()
        
        let dashboardTitle = app.staticTexts["Time to practise!"]
        XCTAssertTrue(dashboardTitle.waitForExistence(timeout: TestTimeouts.medium), "Should navigate to dashboard")
    }
    
    @MainActor
    func navigateToYearSelection(app: XCUIApplication) throws {
        let startButton = app.buttons["Start Adventure"]
        XCTAssertTrue(startButton.waitForExistence(timeout: TestTimeouts.medium), "Start Adventure button should exist")
        startButton.tap()
        
        let yearSelectionTitle = app.staticTexts["Hi! 👋\nWhich year are you in?"]
        XCTAssertTrue(yearSelectionTitle.waitForExistence(timeout: TestTimeouts.medium), "Should be on year selection screen")
    }
    
    @MainActor
    func navigateToFlashcardSession(app: XCUIApplication) throws {
        try navigateToYear3Dashboard(app: app)
        
        let flashcardCard = app.buttons.matching(identifier: "flashcard-flip-card").firstMatch
        XCTAssertTrue(flashcardCard.waitForExistence(timeout: TestTimeouts.medium), "Flashcard Flip card should exist")
        flashcardCard.tap()
        
        let headerText = app.staticTexts["Today's Words"]
        XCTAssertTrue(headerText.waitForExistence(timeout: TestTimeouts.medium), "Flashcard session header should appear")
        
        waitForContentLoad(app: app)
    }
    
    @MainActor
    func navigateToQuiz(app: XCUIApplication) throws {
        try navigateToYear3Dashboard(app: app)
        
        let quizCardTitle = app.staticTexts["Flashcard Quiz"]
        XCTAssertTrue(quizCardTitle.waitForExistence(timeout: TestTimeouts.medium), "Quiz card should exist on dashboard")
        
        let quizCards = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Flashcard Quiz' OR label CONTAINS 'Test yourself'"))
        if quizCards.count > 0 {
            quizCards.firstMatch.tap()
        } else {
            quizCardTitle.tap()
        }
        
        let quizHeader = app.staticTexts["Flashcard Quiz"]
        XCTAssertTrue(quizHeader.waitForExistence(timeout: TestTimeouts.medium), "Should navigate to Quiz screen")
    }
    
    @MainActor
    func navigateToSentenceFill(app: XCUIApplication) throws {
        try navigateToYear3Dashboard(app: app)
        
        let sentenceFillTitle = app.staticTexts["Fill in the Sentence"]
        XCTAssertTrue(sentenceFillTitle.waitForExistence(timeout: TestTimeouts.medium), "Sentence Fill card should exist on dashboard")
        
        let sentenceFillCards = app.buttons.containing(NSPredicate(format: "label CONTAINS 'Fill in the Sentence' OR label CONTAINS 'Choose the word'"))
        if sentenceFillCards.count > 0 {
            sentenceFillCards.firstMatch.tap()
        } else {
            sentenceFillTitle.tap()
        }
        
        let sentenceFillHeader = app.staticTexts["Sentence Quiz"]
        XCTAssertTrue(sentenceFillHeader.waitForExistence(timeout: TestTimeouts.medium), "Should navigate to Sentence Fill screen")
    }
    
    @MainActor
    func navigateBack(app: XCUIApplication) {
        let navigationBar = app.navigationBars.firstMatch
        if navigationBar.exists {
            let backButton = navigationBar.buttons.firstMatch
            if backButton.exists {
                backButton.tap()
                let yearSelectionTitle = app.staticTexts["Hi! 👋\nWhich year are you in?"]
                let dashboardTitle = app.staticTexts["Time to practise!"]
                _ = yearSelectionTitle.waitForExistence(timeout: TestTimeouts.short) || dashboardTitle.waitForExistence(timeout: TestTimeouts.short)
            }
        }
    }
    
    @MainActor
    func waitForContentLoad(app: XCUIApplication) {
        let loadingText = app.staticTexts["Loading words…"]
        if loadingText.exists {
            _ = loadingText.waitForNonExistence(timeout: TestTimeouts.medium)
        }
    }
    
    @MainActor
    func waitForAnimation(app: XCUIApplication, element: XCUIElement, timeout: TimeInterval = TestTimeouts.short) {
        _ = element.waitForExistence(timeout: timeout)
    }
    
    @MainActor
    func verifyEmptyState(app: XCUIApplication, emptyStateText: String) -> Bool {
        let emptyState = app.staticTexts[emptyStateText]
        return emptyState.waitForExistence(timeout: TestTimeouts.short)
    }
}
