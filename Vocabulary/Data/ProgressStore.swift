//
//  ProgressStore.swift
//  Vocabulary
//
//  Abstraction and implementation for tracking user progress locally.
//

import Foundation

protocol ProgressStore {
    func masteredWordIDs(for year: YearGroup) -> Set<UUID>
    func markWordMastered(_ id: UUID, year: YearGroup)
}

final class UserDefaultsProgressStore: ProgressStore {
    private let defaults: UserDefaults
    private let keyPrefix = "masteredWordIDs_"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func masteredWordIDs(for year: YearGroup) -> Set<UUID> {
        let key = storageKey(for: year)
        guard let raw = defaults.array(forKey: key) as? [String] else {
            return []
        }
        let uuids = raw.compactMap(UUID.init(uuidString:))
        return Set(uuids)
    }

    func markWordMastered(_ id: UUID, year: YearGroup) {
        let key = storageKey(for: year)
        var current = masteredWordIDs(for: year)
        current.insert(id)
        let strings = current.map { $0.uuidString }
        defaults.set(strings, forKey: key)
    }

    private func storageKey(for year: YearGroup) -> String {
        keyPrefix + year.shortCode
    }
}
