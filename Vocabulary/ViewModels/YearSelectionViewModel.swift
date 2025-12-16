//
//  YearSelectionViewModel.swift
//  Vocabulary
//
//  Handles selection of school year groups.
//

import Foundation
import Combine

@MainActor
final class YearSelectionViewModel: ObservableObject {
    @Published var years: [YearGroup] = []

    init(repository: VocabularyRepository) {
        years = repository.getYears()
    }
}
