//
//  YearGroup.swift
//  Vocabulary
//
//  Represents school year levels supported by the app.
//

import Foundation

enum YearGroup: String, CaseIterable, Identifiable, Codable {
    case year3 = "Year 3"
    case year4 = "Year 4"
    case year5 = "Year 5"
    case year6 = "Year 6"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var shortCode: String {
        switch self {
        case .year3: return "Y3"
        case .year4: return "Y4"
        case .year5: return "Y5"
        case .year6: return "Y6"
        }
    }
}


