# WordWizards - Vocabulary Learning App

A kid-friendly iOS app that helps students in **Year 3–6** learn vocabulary through interactive flashcards, quizzes, and sentence-fill games.

## Features

- **Flashcard Learning**: Interactive flashcards with word definitions, antonyms, and text-to-speech
- **Flashcard Quiz**: Multiple-choice quizzes using mastered words
- **Sentence Fill**: Fill-in-the-blank sentence practice
- **Progress Tracking**: Local persistence of mastered words
- **Year Groups**: Support for Year 3, 4, 5, and 6 vocabulary

## Tech Stack

- **Language**: Swift
- **Framework**: SwiftUI
- **Minimum iOS**: iOS 16+
- **Architecture**: MVVM (Model-View-ViewModel)
- **Data Storage**: Local JSON files + UserDefaults
- **Testing**: XCTest (Unit + UI Tests)

## Project Structure

```
Vocabulary/
├── Vocabulary/
│   ├── Models/              # Domain models (VocabularyItem, YearGroup, etc.)
│   ├── Data/                # Repository and storage abstractions
│   ├── ViewModels/          # Business logic and state management
│   ├── Views/               # SwiftUI views
│   │   ├── Components/      # Reusable UI components
│   │   └── ...
│   ├── Services/            # Services (TextToSpeech, etc.)
│   └── Resources/           # JSON vocabulary files (Year3-6.json)
├── VocabularyTests/         # Unit tests
└── VocabularyUITests/       # UI tests
    ├── BaseUITestCase.swift # Common test utilities
    ├── WelcomeViewTests.swift
    ├── YearDashboardViewTests.swift
    ├── FlashcardSessionViewTests.swift
    ├── QuizViewTests.swift
    ├── SentenceFillViewTests.swift
    └── NavigationTests.swift
```

## Architecture

### MVVM Pattern

- **Models**: Simple domain models (`VocabularyItem`, `YearGroup`, `QuizQuestion`, `SentenceQuestion`)
- **ViewModels**: `@MainActor ObservableObject` classes that manage state and business logic
- **Views**: Declarative SwiftUI views focused on layout and styling
- **Data Layer**: Repository pattern with `VocabularyRepository` and `ProgressStore` abstractions

### Key Components

- **VocabularyRepository**: Protocol for vocabulary data access
- **ProgressStore**: Protocol for progress persistence
- **TextToSpeechService**: Service for audio pronunciation

## Setup

1. **Prerequisites**:
   - Xcode 15.0 or later
   - iOS 16.0+ deployment target

2. **Clone and Open**:
   ```bash
   git clone <repository-url>
   cd Vocabulary
   open Vocabulary.xcodeproj
   ```

3. **Run**:
   - Select a simulator or device
   - Press `Cmd + R` to build and run

## Testing

### Unit Tests

Run unit tests with `Cmd + U` or:
```bash
xcodebuild test -scheme Vocabulary -destination 'platform=iOS Simulator,name=iPhone 17'
```

### UI Tests

The UI test suite is organized by screen/module:

- **WelcomeViewTests**: Welcome screen and year selection
- **YearDashboardViewTests**: Dashboard functionality
- **FlashcardSessionViewTests**: Flashcard learning features
- **QuizViewTests**: Quiz flow and interactions
- **SentenceFillViewTests**: Sentence fill-in-the-blank
- **NavigationTests**: Navigation flows between screens

**Test Coverage**: 27/31 tests passing (87% pass rate)

**Quality Features**:
- No `sleep()` calls - uses proper `waitForExistence()` waits
- Standardized error handling with `XCTSkip` for conditional tests
- Reusable test helpers in `BaseUITestCase`
- Timeout constants for maintainability

## Adding Vocabulary

Edit the JSON files in `Vocabulary/Resources/`:
- `Year3.json`
- `Year4.json`
- `Year5.json`
- `Year6.json`

Each file contains an array of vocabulary items with:
- `word`: The vocabulary word
- `meaning`: Definition
- `antonyms`: Array of opposite words
- `exampleSentences`: Array of example sentences

## Design Guidelines

The app follows the **Stitch design pack** structure:
- Bright, kid-friendly colors
- Rounded cards and clear typography
- Good accessibility (large tap targets, legible fonts, good contrast)
- High visual fidelity to design specifications

## Recent Improvements

### UI Test Refactoring (Latest)

- ✅ Split UI tests into separate files organized by screen/module
- ✅ Created `BaseUITestCase` with common utilities and timeout constants
- ✅ Removed all `sleep()` calls (25 occurrences) - replaced with proper waits
- ✅ Standardized error handling - use `XCTSkip` for conditional tests
- ✅ Extracted common navigation patterns to reduce duplication
- ✅ Improved test reliability and maintainability

## Contributing

When working on this project:

1. **Respect the architecture**: Work through protocols and abstractions
2. **Keep views declarative**: Business logic belongs in ViewModels
3. **Follow MVVM**: Models → ViewModels → Views
4. **Add tests**: Update unit and UI tests when adding features
5. **Maintain design fidelity**: Follow the Stitch design pack

## License

[Add your license here]

## Author

Created by Shakir Ali

