//
//  YearDashboardViewTests.swift
//  VocabularyUITests
//
//  UI tests for Year Dashboard screen.
//

import XCTest

final class YearDashboardViewTests: BaseUITestCase {
    
    @MainActor
    func testDashboard_DisplaysCorrectYear() throws {
        let app = try launchApp()
        try navigateToYear3Dashboard(app: app)
        
        let dashboardTitle = app.staticTexts["Time to practise!"]
        XCTAssertTrue(dashboardTitle.exists, "Dashboard title should be visible")
        
        let year3Text = app.staticTexts["Year 3"]
        XCTAssertTrue(year3Text.exists, "Year 3 should be displayed")
    }
    
    @MainActor
    func testDashboard_FlashcardCardExists() throws {
        let app = try launchApp()
        try navigateToYear3Dashboard(app: app)
        
        let flashcardCard = app.buttons.matching(identifier: "flashcard-flip-card").firstMatch
        XCTAssertTrue(flashcardCard.waitForExistence(timeout: TestTimeouts.medium), "Flashcard Flip card should exist")
        
        let flashcardTitle = app.staticTexts["Flashcard Flip"]
        XCTAssertTrue(flashcardTitle.exists, "Flashcard Flip title should be visible")
    }
    
    @MainActor
    func testDashboard_QuizCardExists() throws {
        let app = try launchApp()
        try navigateToYear3Dashboard(app: app)
        
        let quizCardTitle = app.staticTexts["Flashcard Quiz"]
        XCTAssertTrue(quizCardTitle.waitForExistence(timeout: TestTimeouts.medium), "Quiz card should exist on dashboard")
    }
    
    @MainActor
    func testDashboard_SentenceFillCardExists() throws {
        let app = try launchApp()
        try navigateToYear3Dashboard(app: app)
        
        let sentenceFillTitle = app.staticTexts["Fill in the Sentence"]
        XCTAssertTrue(sentenceFillTitle.waitForExistence(timeout: TestTimeouts.medium), "Sentence Fill card should exist on dashboard")
    }
}
