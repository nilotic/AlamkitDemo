//
//  AlarmError.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import Foundation

enum AlarmError: String, Error, Sendable {
    case notFound
    case unavailable
    case invalidDate
    case unauthorized
    case denied
    case unknown
}

extension AlarmError: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .notFound:         String(localized: "alarm.error.notFound")
        case .unavailable:      String(localized: "alarm.error.unavailable")
        case .invalidDate:      String(localized: "alarm.error.invalidDate")
        case .unauthorized:     String(localized: "alarm.error.unauthorized")
        case .denied:           String(localized: "alarm.error.denied")
        case .unknown:          String(localized: "alarm.error.unknown")
        }
    }
}

extension AlarmError: CustomDebugStringConvertible {
    
    var debugDescription: String {
        description
    }
}

extension AlarmError: LocalizedError {
    
    var errorDescription: String? {
        description
    }
}

extension AlarmError: Identifiable {
    
    var id: RawValue {
        rawValue
    }
}

extension AlarmError: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AlarmError: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension AlarmError: Codable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = AlarmError(rawValue: (try? container.decode(RawValue.self)) ?? "") ?? .notFound
    }
}
