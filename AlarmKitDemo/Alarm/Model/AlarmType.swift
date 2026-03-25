//
//  AlarmType.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI

enum AlarmType: String, Sendable {
    case sleep
    case other
}

extension AlarmType {
    
    var symbolName: String {
        switch self {
        case .sleep:    "bed.double.fill"
        case .other:    "alarm.fill"
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .sleep:    .blue
        case .other:    .orange
        }
    }
    
    var secondaryColor: Color {
        switch self {
        case .sleep:    .cyan
        case .other:    .orange
        }
    }
}

extension AlarmType: CustomStringConvertible {
   
    var description: String {
        switch self {
        case .sleep:    String(localized: "Sleep | Wake Up")
        case .other:    String(localized: "Other")
        }
    }
}

extension AlarmType: CustomDebugStringConvertible {
    
    var debugDescription: String {
        description
    }
}

extension AlarmType: Identifiable {
    
    var id: RawValue {
        rawValue
    }
}

extension AlarmType: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AlarmType: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension AlarmType: CaseIterable {
    
    static var allCases: [AlarmType] {
        [.sleep, .other]
    }
}

extension AlarmType: Codable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = AlarmType(rawValue: (try? container.decode(RawValue.self)) ?? "") ?? .other
    }
}
