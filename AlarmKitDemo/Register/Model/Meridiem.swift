//
//  Meridiem.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import Foundation

enum Meridiem: String, Sendable {
    case am
    case pm
}

extension Meridiem {
    
    init(hour: Int) {
        self = hour < 12 ? .am : .pm
    }
}

extension Meridiem {
    
    mutating func toggle() {
        switch self {
        case .am:   self = .pm
        case .pm:   self = .am
        }
    }
}

extension Meridiem {
    
    var symbol: String {
        switch self {
        case .am:   DateFormatter().amSymbol
        case .pm:   DateFormatter().pmSymbol
        }
    }
}

extension Meridiem: CustomStringConvertible {
    
    var description: String {
        symbol
    }
}

extension Meridiem: CustomDebugStringConvertible {
    
    var debugDescription: String {
        description
    }
}

extension Meridiem: Identifiable {
    
    var id: RawValue {
        rawValue
    }
}

extension Meridiem: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Meridiem: Equatable {
    
    static func == (lhs: Meridiem, rhs: Meridiem) -> Bool {
        lhs.id == rhs.id
    }
}

extension Meridiem: CaseIterable {
    
    static var allCases: [Self] {
        [.am, .pm]
    }
}


extension Meridiem: Codable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = Meridiem(rawValue: (try? container.decode(RawValue.self)) ?? "") ?? .am
    }
}
