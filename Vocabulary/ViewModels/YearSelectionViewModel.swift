//
//  YearSelectionViewModel.swift
//  Vocabulary
//
//  Handles selection of school year groups.
//

import Foundation

@MainActor
final class YearSelectionViewModel: ObservableObject {
    @Published var years: [YearGroup] = []

    init(repository: VocabularyRepository) {
        years = repository.getYears()
    }
}
