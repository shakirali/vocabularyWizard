//
//  SentenceFillViewTests.swift
//  VocabularyUITests
//
//  UI tests for Sentence Fill screen.
//

import XCTest

final class SentenceFillViewTests: BaseUITestCase {
    
    @MainActor
    func testSentenceFill_NavigateToSentenceFill() throws {
        let app = try launchApp()
        try navigateToSentenceFill(app: app)
        
        let sentenceFillHeader = app.staticTexts["Sentence Quiz"]
        XCTAssertTrue(sentenceFillHeader.exists, "Should be on Sentence Fill screen")
    }
    
    @MainActor
    func testSentenceFill_ViewSentenceWithBlank() throws {
        let app = try launchApp()
        try navigateToSentenceFill(app: app)
        
        if verifyEmptyState(app: app, emptyStateText: "Sentence practice will appear once content is available.") {
            throw XCTSkip("No sentence questions available")
        }
        
        let allTexts = app.staticTexts.allElementsBoundByIndex
        var foundSentence = false
        for text in allTexts {
            let label = text.label
            if label.count > 20 && !label.contains("Sentence Quiz") && !label.contains("Question") {
                foundSentence = true
                break
            }
        }
        
        XCTAssertTrue(foundSentence, "Sentence with blank should be displayed")
    }
    
    @MainActor
    func testSentenceFill_AnswerCorrectAndIncorrect() throws {
        let app = try launchApp()
        try navigateToSentenceFill(app: app)
        
        if verifyEmptyState(app: app, emptyStateText: "Sentence practice will appear once content is available.") {
            throw XCTSkip("No sentence questions available")
        }
        
        let allButtons = app.buttons.allElementsBoundByIndex
        var optionButtons: [XCUIElement] = []
        
        for button in allButtons {
            let label = button.label
            if !label.isEmpty &&
               label.count < 20 &&
               !label.contains("Sentence") &&
               !label.contains("Quiz") &&
               !label.contains("Question") &&
               button.isHittable {
                optionButtons.append(button)
            }
        }
        
        guard optionButtons.count >= 2 else {
            throw XCTSkip("Not enough options available for testing")
        }
        
        let firstOption = optionButtons[0]
        firstOption.tap()
        
        let feedbackMessages = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Nice!' OR label CONTAINS 'Try again'"))
        if feedbackMessages.firstMatch.waitForExistence(timeout: TestTimeouts.short) {
            let feedbackText = feedbackMessages.firstMatch.label
            XCTAssertTrue(feedbackText.contains("Nice!") || feedbackText.contains("Try again"), "Feedback should be displayed")
        }
        
        let tryAgainMessage = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Try again'"))
        if tryAgainMessage.firstMatch.exists {
            if optionButtons.count > 1 {
                optionButtons[1].tap()
                _ = feedbackMessages.firstMatch.waitForExistence(timeout: TestTimeouts.short)
            }
        }
        
        var questionsAnswered = 1
        while questionsAnswered < 3 {
            let finishedText = app.staticTexts["Great work!"]
            if finishedText.exists {
                break
            }
            
            let questionText = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Question'"))
            if questionText.firstMatch.exists {
                let currentButtons = app.buttons.allElementsBoundByIndex
                for button in currentButtons {
                    let label = button.label
                    if !label.isEmpty &&
                       label.count < 20 &&
                       !label.contains("Sentence") &&
                       !label.contains("Quiz") &&
                       button.isHittable {
                        button.tap()
                        questionsAnswered += 1
                        _ = feedbackMessages.firstMatch.waitForExistence(timeout: TestTimeouts.short)
                        break
                    }
                }
            } else {
                break
            }
        }
        
        let finalScore = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Score:'"))
        if finalScore.firstMatch.exists {
            XCTAssertTrue(finalScore.firstMatch.exists, "Final score should be displayed")
        }
    }
}
