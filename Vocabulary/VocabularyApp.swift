//
//  VocabularyApp.swift
//  Vocabulary
//
//  Created by Shakir Ali on 15/12/2025.
//

import SwiftUI

@main
struct VocabularyApp: App {
    private let repository = LocalJSONVocabularyRepository()
    private let progressStore = UserDefaultsProgressStore()
    private let ttsService = DefaultTextToSpeechService()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomeView(
                    repository: repository,
                    progressStore: progressStore,
                    tts: ttsService
                )
            }
        }
    }
}
