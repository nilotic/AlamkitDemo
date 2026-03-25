//
//  AlarmLiveActivityAction.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import Foundation

struct AlarmLiveActivityAction: Sendable {
    let alarmID: UUID
    let createDate: Date
    let type: AlarmAlarmLiveActivityActionType
}

extension AlarmLiveActivityAction: RawRepresentable {
    
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8) else { return nil }
        do { self = try JSONDecoder().decode(Self.self, from: data) } catch { return nil }
    }
    
    var rawValue: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        
        guard let data = try? encoder.encode(self), let string = String(data: data, encoding: .utf8) else { return "" }
        return string
    }
}

extension AlarmLiveActivityAction: Identifiable {
    
    var id: String {
        "\(alarmID.uuidString)-\(type.rawValue)-\(createDate.timeIntervalSince1970)"
    }
}

extension AlarmLiveActivityAction: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AlarmLiveActivityAction: Equatable {
    
    static func == (lhs: AlarmLiveActivityAction, rhs: AlarmLiveActivityAction) -> Bool {
        lhs.id == rhs.id
    }
}

extension AlarmLiveActivityAction: CustomStringConvertible {
   
    var description: String {
        rawValue
    }
}

extension AlarmLiveActivityAction: CustomDebugStringConvertible {
    
    var debugDescription: String {
        rawValue
    }
}

extension AlarmLiveActivityAction: Codable {
    
    private enum Key: String, CodingKey {
        case alarmID
        case createDate
        case type
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(alarmID, forKey: .alarmID)
        try container.encode(createDate, forKey: .createDate)
        try container.encode(type, forKey: .type)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        alarmID = try container.decode(UUID.self, forKey: .alarmID)
        createDate = try container.decode(Date.self, forKey: .createDate)
        type = try container.decode(AlarmAlarmLiveActivityActionType.self, forKey: .type)
    }
}
