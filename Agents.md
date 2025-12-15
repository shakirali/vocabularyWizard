## Agents Guide for the Vocabulary App

### Purpose of This Project

- **Goal**: This repo contains a kid-friendly iOS app that helps students in **Year 3–6** learn vocabulary using **flashcards**, **quizzes**, and **sentence-fill** games.
- **Tech stack**: Swift, SwiftUI, iOS 16+, MVVM architecture, local JSON-backed vocabulary, and local progress persistence.
- **Design source**: The UI should follow the provided `stitch_vocabularybuilder` designs with **high visual fidelity** (layout, colors, typography, spacing).

### How Agents Should Work on This Repo

- **Respect the architecture**:
  - **Models**: Keep domain models simple (`YearGroup`, `VocabularyItem`, `QuizQuestion`, `SentenceQuestion`, plus any future `UserProgress` or similar types).
  - **Data layer**: Work through the `VocabularyRepository` protocol and `ProgressStore` abstraction. Do **not** access JSON files or `UserDefaults` directly from views or view models.
  - **ViewModels**: Add new state/logic in view models, not in views. Keep them `@MainActor` and `ObservableObject`, and expose state via `@Published` properties.
  - **Views**: Keep SwiftUI views declarative, focused on layout and styling. Use dependency injection to pass repositories, stores, and services from `VocabularyApp`.
  - **Services**: Add functionality like text-to-speech in small, focused services (e.g. `TextToSpeechService`).

- **Navigation + flow**:
  - Root entry point is `VocabularyApp`, which creates shared instances of `LocalJSONVocabularyRepository`, `UserDefaultsProgressStore`, and `DefaultTextToSpeechService`.
  - The primary user flow is:
    - Year selection (`YearSelectionView`) →
    - Year dashboard / mode selection (`YearDashboardView`) →
    - Flashcards (`FlashcardSessionView`) / Quiz (`QuizView`) / Sentence practice (`SentenceFillView`).
  - Prefer `NavigationStack` and keep navigation logic inside views while keeping business logic in view models.

- **Design & UX guidelines**:
  - Follow the **Stitch design pack** structure:
    - `welcome_screen` → welcome/landing experience (mapped to the app’s initial screen).
    - `year_selection_screen` → year selection grid.
    - `quiz_selection_screen` → mode selection for the chosen year.
    - `flashcard_learning_screen` → flashcard learning UI.
    - `flashcard_quiz_screen` → multiple-choice flashcard quiz.
    - `fill-in-the-blanks_quiz_screen` → sentence-fill game.
  - Use bright, kid-friendly colors, rounded cards, and clear typography that roughly match the design pack.
  - Maintain good accessibility:
    - Use sufficiently large tap targets, legible font sizes, and good contrast.
    - Add descriptive labels where needed (e.g. speaker icon for text-to-speech).

- **Data and persistence**:
  - When adding/changing vocabulary, edit the bundled JSON in `Resources/Year3.json`–`Year6.json`.
  - If you need new fields, update:
    - The JSON structure.
    - `RawVocabularyItem` in `LocalJSONVocabularyRepository`.
    - `VocabularyItem` in `Models`.
  - For progress, work only through `ProgressStore`:
    - Extend `ProgressStore` and `UserDefaultsProgressStore` if you add new progress metrics (e.g. quiz stats, streaks).

- **Testing expectations**:
  - Add or update **unit tests** in `VocabularyTests` when you modify:
    - Models (especially decoding/encoding).
    - The repository and progress store behavior.
    - View model logic (quiz generation, batch logic, etc.).
  - Add or update **UI tests** in `VocabularyUITests` when you change:
    - Core navigation flows.
    - The structure or labeling of main screens.
  - Keep tests readable and focused on core behavior rather than implementation details.

### Common Tasks for Future Agents

- **Add a new year level**:
  - Extend `YearGroup` with a new case and update related display/short-code logic.
  - Add a matching JSON file under `Resources` and ensure `LocalJSONVocabularyRepository` maps the new year to the new file.
  - Confirm `YearSelectionView` automatically includes the new year via `YearGroup.allCases`.

- **Change content source to an API**:
  - Create a new implementation of `VocabularyRepository` (e.g. `RemoteAPIVocabularyRepository`) that fetches from the backend.
  - Add configuration to switch between `LocalJSONVocabularyRepository` and the remote one (e.g. via compile-time flag or simple app-level toggle).
  - Do **not** change views or view models—swap the repository implementation in `VocabularyApp` instead.

- **Tweak quiz logic**:
  - Modify question generation in `QuizViewModel` or `SentenceFillViewModel` only.
  - Keep the public surface area of models (`QuizQuestion`, `SentenceQuestion`) stable, or update tests alongside any changes.
  - Ensure you still generate at least 4 options per question (1 correct + 3 distractors) and randomize order.

- **Add a new game mode**:
  - Create a new model (if needed), view model, and SwiftUI view.
  - Add a new navigation option from `YearDashboardView`.
  - Wire any new persistence needs through `ProgressStore`.

### Working Style for Agents

- Prefer **small, focused commits/changes** that are easy to review.
- Keep code **well-commented** only where behavior is non-obvious; avoid noisy comments elsewhere.
- Maintain consistency with existing naming, formatting, and architectural patterns.
- When in doubt, follow the **plan file** in `.cursor/plans/vocabulary-kids-app-plan_ce7fbfe2.plan.md` and update tests together with behavior changes.

This document explains how AI agents should work on and extend the **Vocabulary** iOS app.

### Project Purpose

The app helps children in **Year 3–6** learn and practise vocabulary using:

- Flashcard-based learning (5 words at a time).
- Quizzes generated from words they have already memorized.
- Sentence-based fill-in-the-blank questions.

The current v1 ships as an **iOS app for iPhone and iPad**, built with **Swift + SwiftUI** and targeting **iOS 16+**.

### Architecture Overview

- **UI**: SwiftUI with a `NavigationStack` starting at `YearSelectionView`.
- **Pattern**: MVVM with a thin repository layer.
- **Layers**:
  - `Models`: core types like `YearGroup`, `VocabularyItem`, `QuizQuestion`, `SentenceQuestion`.
  - `Data`: `VocabularyRepository` protocol, `LocalJSONVocabularyRepository`, `ProgressStore` (`UserDefaultsProgressStore`).
  - `Services`: `TextToSpeechService` (`DefaultTextToSpeechService` using `AVSpeechSynthesizer`).
  - `ViewModels`: `YearSelectionViewModel`, `FlashcardSessionViewModel`, `QuizViewModel`, `SentenceFillViewModel`.
  - `Views`: `YearSelectionView`, `YearDashboardView`, `FlashcardSessionView`, `FlashcardView`, `QuizView`, `SentenceFillView`.
  - `Resources`: Bundled JSON files (`Year3.json`, `Year4.json`, `Year5.json`, `Year6.json`).

`VocabularyApp` wires a single `VocabularyRepository`, `ProgressStore`, and `TextToSpeechService` into the root `YearSelectionView`.

### Content Model

Vocabulary content is bundled as JSON per year with fields:

- `id`: string UUID (optional, generated if missing).
- `word`: the vocabulary word.
- `meaning`: a short child-friendly definition.
- `antonyms`: at least two antonyms (for the flashcard back).
- `exampleSentences`: one or more sentences including the target word, used for sentence practice.

Agents should treat the `VocabularyRepository` protocol as the main abstraction boundary when changing how content is loaded (e.g. switching to a backend API).

### Best Practices for Future Changes

- **Respect MVVM boundaries**:
  - Keep business logic and state transformations in view models.
  - Keep views declarative and focused on layout/interaction.
- **Use the repository and progress store abstractions**:
  - Do not access JSON files or `UserDefaults` directly from views or view models.
  - Create new repository or store implementations when changing storage/backends.
- **Keep the app kid-friendly**:
  - Use clear, simple copy and supportive feedback messages.
  - Maintain accessible font sizes and good contrast.
- **Tests are required for non-trivial changes**:
  - Add or update **unit tests** in `VocabularyTests` for new logic.
  - Add or update **UI tests** in `VocabularyUITests` for new flows.

### Common Tasks for Agents

- **Adding new vocabulary content**:
  - Update or add JSON files under `Vocabulary/Resources`.
  - Ensure each entry includes `word`, `meaning`, `antonyms`, and at least one `exampleSentence`.
- **Changing content source to an API**:
  - Create a new type conforming to `VocabularyRepository` that fetches from a backend.
  - Keep the existing `LocalJSONVocabularyRepository` for offline / fallback use.
  - Avoid breaking the view models’ use of the `VocabularyRepository` protocol.
- **Tweaking quiz or sentence logic**:
  - Adjust question creation in `QuizViewModel` and `SentenceFillViewModel`.
  - Add corresponding unit tests to confirm behaviour.
- **Adding new modes or screens**:
  - Create new view + view model pairs.
  - Integrate via `YearDashboardView` (or a similar hub) and keep navigation within `NavigationStack`.

Agents should keep changes small, well-tested, and consistent with the existing architecture to make the app easy to maintain and extend.

Testing the app:
# Note: swift test and swift build don't work for Xcode projects, only Swift Package Manager projects
# Run tests sequentially on a single iOS simulator (prevents multiple simulator creation):
xcodebuild test -scheme Vocabulary -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -parallel-testing-enabled NO 2>&1 | xcsift
# Or for a specific test target:
xcodebuild test -scheme Vocabulary -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -parallel-testing-enabled NO -only-testing:VocabularyTests 2>&1 | xcsift

### check quality
**When the user says "let's check quality"**, follow this clean session-protocol

1. **Go through all the code.
2. **Identify and remove the obsolete code, comments and files.
3. **Run the tests.
