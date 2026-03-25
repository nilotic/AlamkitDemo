//
//  AlarmState.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import Foundation

enum AlarmState: String, Sendable {
    case stream
    case activation
}

extension AlarmState: CustomStringConvertible {
    
    var description: String {
        rawValue
    }
}

extension AlarmState: CustomDebugStringConvertible {
    
    var debugDescription: String {
        description
    }
}

extension AlarmState: Identifiable {
    
    var id: RawValue {
        rawValue
    }
}

extension AlarmState: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AlarmState: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension AlarmState: CaseIterable {
    
    static var allCases: [Self] {
        [.stream, .activation]
    }
}

extension AlarmState: Codable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = AlarmState(rawValue: (try? container.decode(RawValue.self)) ?? "") ?? .activation
    }
}
