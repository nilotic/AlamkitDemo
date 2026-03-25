//
//  AlarmAlarmLiveActivityActionType.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import Foundation

enum AlarmAlarmLiveActivityActionType: String, Sendable {
    case stop
    case snooze
}

extension AlarmAlarmLiveActivityActionType: CustomStringConvertible {
   
    var description: String {
        rawValue
    }
}

extension AlarmAlarmLiveActivityActionType: CustomDebugStringConvertible {
    
    var debugDescription: String {
        description
    }
}

extension AlarmAlarmLiveActivityActionType: Identifiable {
    
    var id: RawValue {
        rawValue
    }
}

extension AlarmAlarmLiveActivityActionType: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AlarmAlarmLiveActivityActionType: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension AlarmAlarmLiveActivityActionType: CaseIterable {
    
    static var allCases: [Self] {
        [.stop, .snooze]
    }
}

extension AlarmAlarmLiveActivityActionType: Codable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = AlarmAlarmLiveActivityActionType(rawValue: (try? container.decode(RawValue.self)) ?? "") ?? .stop
    }
}
