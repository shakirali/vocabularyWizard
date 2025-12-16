//
//  NavigationTests.swift
//  VocabularyUITests
//
//  UI tests for navigation flows between screens.
//

import XCTest

final class NavigationTests: BaseUITestCase {
    
    @MainActor
    func testNavigation_BackFromDashboard() throws {
        let app = try launchApp()
        try navigateToYear3Dashboard(app: app)
        
        let dashboardTitle = app.staticTexts["Time to practise!"]
        XCTAssertTrue(dashboardTitle.exists)
        
        navigateBack(app: app)
        
        let yearSelectionTitle = app.staticTexts["Hi! 👋\nWhich year are you in?"]
        XCTAssertTrue(yearSelectionTitle.waitForExistence(timeout: TestTimeouts.medium), "Should navigate back to Year Selection")
    }
    
    @MainActor
    func testNavigation_BackFromFlashcardSession() throws {
        let app = try launchApp()
        try navigateToFlashcardSession(app: app)
        
        let headerText = app.staticTexts["Today's Words"]
        XCTAssertTrue(headerText.exists)
        
        navigateBack(app: app)
        
        let dashboardTitle = app.staticTexts["Time to practise!"]
        XCTAssertTrue(dashboardTitle.waitForExistence(timeout: TestTimeouts.medium), "Should navigate back to Dashboard")
    }
    
    @MainActor
    func testNavigation_BackFromQuiz() throws {
        let app = try launchApp()
        try navigateToQuiz(app: app)
        
        let quizHeader = app.staticTexts["Flashcard Quiz"]
        XCTAssertTrue(quizHeader.exists)
        
        navigateBack(app: app)
        
        let dashboardTitle = app.staticTexts["Time to practise!"]
        XCTAssertTrue(dashboardTitle.waitForExistence(timeout: TestTimeouts.medium), "Should navigate back to Dashboard")
    }
    
    @MainActor
    func testNavigation_BackFromSentenceFill() throws {
        let app = try launchApp()
        try navigateToSentenceFill(app: app)
        
        let sentenceFillHeader = app.staticTexts["Sentence Quiz"]
        XCTAssertTrue(sentenceFillHeader.exists)
        
        navigateBack(app: app)
        
        let dashboardTitle = app.staticTexts["Time to practise!"]
        XCTAssertTrue(dashboardTitle.waitForExistence(timeout: TestTimeouts.medium), "Should navigate back to Dashboard")
    }
}
