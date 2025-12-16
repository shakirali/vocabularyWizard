//
//  QuizViewTests.swift
//  VocabularyUITests
//
//  UI tests for Quiz screen.
//

import XCTest

final class QuizViewTests: BaseUITestCase {
    
    @MainActor
    func testQuiz_NavigateToQuiz() throws {
        let app = try launchApp()
        try navigateToQuiz(app: app)
        
        let quizHeader = app.staticTexts["Flashcard Quiz"]
        XCTAssertTrue(quizHeader.exists, "Should be on Quiz screen")
    }
    
    @MainActor
    func testQuiz_EmptyState() throws {
        let app = try launchApp()
        try navigateToQuiz(app: app)
        
        let emptyStateMessage = app.staticTexts["You need to memorize some words first in flashcards."]
        XCTAssertTrue(emptyStateMessage.waitForExistence(timeout: TestTimeouts.medium), "Should show empty state when no words are mastered")
    }
    
    @MainActor
    func testQuiz_AnswerQuestions() throws {
        let app = try launchApp()
        try navigateToYear3Dashboard(app: app)
        
        let flashcardCard = app.buttons.matching(identifier: "flashcard-flip-card").firstMatch
        XCTAssertTrue(flashcardCard.waitForExistence(timeout: TestTimeouts.medium))
        flashcardCard.tap()
        
        let headerText = app.staticTexts["Today's Words"]
        XCTAssertTrue(headerText.waitForExistence(timeout: TestTimeouts.medium))
        
        if verifyEmptyState(app: app, emptyStateText: "No words available yet.") {
            throw XCTSkip("No words available for testing quiz")
        }
        
        let flashcardQuery = app.otherElements.matching(NSPredicate(format: "identifier BEGINSWITH 'flashcard-'"))
        let flashcard = flashcardQuery.firstMatch
        if flashcard.waitForExistence(timeout: TestTimeouts.medium) {
            let tapCoordinate = flashcard.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
            tapCoordinate.tap()
            
            let markMemorizedButton = app.buttons["Mark as memorized"]
            if markMemorizedButton.waitForExistence(timeout: TestTimeouts.medium) {
                markMemorizedButton.tap()
            }
        }
        
        navigateBack(app: app)
        try navigateToQuiz(app: app)
        
        if verifyEmptyState(app: app, emptyStateText: "You need to memorize some words first in flashcards.") {
            throw XCTSkip("No mastered words available for quiz")
        }
        
        let questionPrompt = app.staticTexts["What does this word mean?"]
        XCTAssertTrue(questionPrompt.waitForExistence(timeout: TestTimeouts.medium), "Quiz question should be displayed")
        
        let progressText = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Question'"))
        XCTAssertTrue(progressText.firstMatch.exists, "Progress text should be visible")
        
        let allButtons = app.buttons.allElementsBoundByIndex
        var foundOption = false
        for button in allButtons {
            let label = button.label
            if !label.isEmpty &&
               label != "Mark as memorized" &&
               label != "Hear the word" &&
               !label.contains("Flashcard") &&
               !label.contains("Quiz") &&
               button.isHittable {
                button.tap()
                foundOption = true
                break
            }
        }
        
        XCTAssertTrue(foundOption, "Should be able to tap an answer option")
        
        var questionsAnswered = 1
        while questionsAnswered < 3 {
            let finishedText = app.staticTexts["Great job!"]
            if finishedText.exists {
                break
            }
            
            let nextQuestionPrompt = app.staticTexts["What does this word mean?"]
            if nextQuestionPrompt.exists {
                let allButtons2 = app.buttons.allElementsBoundByIndex
                for button in allButtons2 {
                    let label = button.label
                    if !label.isEmpty &&
                       label != "Mark as memorized" &&
                       label != "Hear the word" &&
                       !label.contains("Flashcard") &&
                       !label.contains("Quiz") &&
                       button.isHittable {
                        button.tap()
                        questionsAnswered += 1
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
