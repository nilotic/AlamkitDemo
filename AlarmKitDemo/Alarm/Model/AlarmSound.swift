//
//  AlarmSound.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import AlarmKit
import ActivityKit

enum AlarmSound: String, Sendable {
    case beep = "Beep"
    case cuckooBird = "CuckooBird"
    case forestBirds = "ForestBirds"
    case morningBirds = "MorningBirds"
    case windChime = "WindChime"
    case cheerful = "Cheerful"
}

extension AlarmSound {
    
    nonisolated
    var fileName: String {
        "\(rawValue).\(fileExtension)"
    }
    
    nonisolated
    var fileExtension: String {
        switch self {
        case .beep, .cuckooBird, .forestBirds, .morningBirds, .windChime:
            "wav"
            
        case .cheerful:
            "caf"
        }
    }
    
    var alertSound: AlertConfiguration.AlertSound {
        #if targetEnvironment(simulator)
            .default
        
        #else
            .named(fileName)
        #endif
    }
}

extension AlarmSound: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .beep:             String(localized: "Beep")
        case .cuckooBird:       String(localized: "Cuckoo Bird")
        case .forestBirds:      String(localized: "Forest Birds")
        case .morningBirds:     String(localized: "Morning Birds")
        case .windChime:        String(localized: "Wind Chime")
        case .cheerful:         String(localized: "Cheerful")
        }
    }
}

extension AlarmSound: CustomDebugStringConvertible {
    
    var debugDescription: String {
        description
    }
}

extension AlarmSound: Identifiable {
    
    var id: String {
        rawValue
    }
}

extension AlarmSound: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AlarmSound: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension AlarmSound: CaseIterable {
    
    nonisolated
    static var allCases: [Self] {
        [.beep, .cuckooBird, .forestBirds, .morningBirds, .windChime, .cheerful]
    }
}

extension AlarmSound: Codable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = AlarmSound(rawValue: (try? container.decode(RawValue.self)) ?? "beep") ?? .beep
    }
}
