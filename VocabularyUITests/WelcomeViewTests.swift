//
//  WelcomeViewTests.swift
//  VocabularyUITests
//
//  UI tests for Welcome screen and Year Selection screen.
//

import XCTest

final class WelcomeViewTests: BaseUITestCase {
    
    @MainActor
    func testWelcomeScreen_StartAdventure() throws {
        let app = try launchApp()
        
        let welcomeTitle = app.staticTexts["WordWizards"]
        XCTAssertTrue(welcomeTitle.exists, "Welcome title should be visible")
        
        let startButton = app.buttons["Start Adventure"]
        XCTAssertTrue(startButton.waitForExistence(timeout: TestTimeouts.medium), "Start Adventure button should exist")
        startButton.tap()
        
        let yearSelectionTitle = app.staticTexts["Hi! 👋\nWhich year are you in?"]
        XCTAssertTrue(yearSelectionTitle.waitForExistence(timeout: TestTimeouts.medium), "Should navigate to Year Selection screen")
    }
    
    @MainActor
    func testYearSelection_SelectYear3() throws {
        let app = try launchApp()
        try navigateToYearSelection(app: app)
        
        let year3Button = app.buttons.matching(identifier: "year-Y3").firstMatch
        XCTAssertTrue(year3Button.waitForExistence(timeout: TestTimeouts.medium), "Year 3 button should exist")
        year3Button.tap()
        
        let dashboardTitle = app.staticTexts["Time to practise!"]
        XCTAssertTrue(dashboardTitle.waitForExistence(timeout: TestTimeouts.medium), "Should navigate to dashboard")
        
        let year3Text = app.staticTexts["Year 3"]
        XCTAssertTrue(year3Text.waitForExistence(timeout: TestTimeouts.medium), "Year 3 should be displayed on dashboard")
    }
    
    @MainActor
    func testYearSelection_SelectYear4() throws {
        let app = try launchApp()
        try navigateToYearSelection(app: app)
        
        let year4Button = app.buttons.matching(identifier: "year-Y4").firstMatch
        XCTAssertTrue(year4Button.waitForExistence(timeout: TestTimeouts.medium), "Year 4 button should exist")
        year4Button.tap()
        
        let dashboardTitle = app.staticTexts["Time to practise!"]
        XCTAssertTrue(dashboardTitle.waitForExistence(timeout: TestTimeouts.medium), "Should navigate to dashboard")
        
        let year4Text = app.staticTexts["Year 4"]
        XCTAssertTrue(year4Text.waitForExistence(timeout: TestTimeouts.medium), "Year 4 should be displayed on dashboard")
    }
    
    @MainActor
    func testYearSelection_SelectYear5() throws {
        let app = try launchApp()
        try navigateToYearSelection(app: app)
        
        let year5Button = app.buttons.matching(identifier: "year-Y5").firstMatch
        XCTAssertTrue(year5Button.waitForExistence(timeout: TestTimeouts.medium), "Year 5 button should exist")
        year5Button.tap()
        
        let dashboardTitle = app.staticTexts["Time to practise!"]
        XCTAssertTrue(dashboardTitle.waitForExistence(timeout: TestTimeouts.medium), "Should navigate to dashboard")
        
        let year5Text = app.staticTexts["Year 5"]
        XCTAssertTrue(year5Text.waitForExistence(timeout: TestTimeouts.medium), "Year 5 should be displayed on dashboard")
    }
    
    @MainActor
    func testYearSelection_SelectYear6() throws {
        let app = try launchApp()
        try navigateToYearSelection(app: app)
        
        let year6Button = app.buttons.matching(identifier: "year-Y6").firstMatch
        XCTAssertTrue(year6Button.waitForExistence(timeout: TestTimeouts.medium), "Year 6 button should exist")
        year6Button.tap()
        
        let dashboardTitle = app.staticTexts["Time to practise!"]
        XCTAssertTrue(dashboardTitle.waitForExistence(timeout: TestTimeouts.medium), "Should navigate to dashboard")
        
        let year6Text = app.staticTexts["Year 6"]
        XCTAssertTrue(year6Text.waitForExistence(timeout: TestTimeouts.medium), "Year 6 should be displayed on dashboard")
    }
    
    @MainActor
    func testYearSelection_BackButton() throws {
        let app = try launchApp()
        try navigateToYearSelection(app: app)
        
        let screen = app.windows.firstMatch
        let backCoordinate = screen.coordinate(withNormalizedOffset: CGVector(dx: 0.05, dy: 0.1))
        backCoordinate.tap()
        
        let welcomeTitle = app.staticTexts["WordWizards"]
        XCTAssertTrue(welcomeTitle.waitForExistence(timeout: TestTimeouts.medium), "Should navigate back to Welcome screen")
    }
    
    @MainActor
    func testYearSelection_SkipButton() throws {
        let app = try launchApp()
        try navigateToYearSelection(app: app)
        
        let skipButton = app.buttons["Skip"]
        XCTAssertTrue(skipButton.waitForExistence(timeout: TestTimeouts.medium), "Skip button should exist")
        XCTAssertTrue(skipButton.isHittable, "Skip button should be hittable")
        
        skipButton.tap()
        
        let yearSelectionTitle = app.staticTexts["Hi! 👋\nWhich year are you in?"]
        XCTAssertTrue(yearSelectionTitle.exists, "Should still be on year selection screen after Skip")
    }
}
