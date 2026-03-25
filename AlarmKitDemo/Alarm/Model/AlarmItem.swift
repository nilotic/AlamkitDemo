//
//  AlarmItem.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI
import AlarmKit

struct AlarmItem: Identifiable, Sendable {
    let id: UUID
    var title = ""
    var date: Date = .distantPast
    var sound: AlarmSound = .beep
    var volume: Float = 1
    var snoozeDuration: Duration = .zero
    var isSnooze = false
    var isEnabled = true
    var indexPath = IndexPath(item: 0, section: 0)
    var repeatOptions: AlarmRepeatOptions = []
    var alarm: Alarm?
    var type: AlarmType = .sleep
}

extension AlarmItem: AlarmMetadata {
    
    init(id: UUID = UUID()) {
        self.id = id
    }
}

extension AlarmItem: RawRepresentable {
    
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

extension AlarmItem: Hashable {
    
    nonisolated
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AlarmItem: Equatable {
    
    nonisolated
    static func == (lhs: AlarmItem, rhs: AlarmItem) -> Bool {
        lhs.id == rhs.id
    }
}

extension AlarmItem: CustomStringConvertible {
   
    var description: String {
        rawValue
    }
}

extension AlarmItem: CustomDebugStringConvertible {
    
    var debugDescription: String {
        rawValue
    }
}

extension AlarmItem: nonisolated Codable {
    
    private enum Key: String, CodingKey {
        case id
        case title
        case date
        case sound
        case volume
        case snoozeDuration
        case isSnooze
        case repeatOptions
        case isEnabled
        case alarm
        case type
    }

    nonisolated
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(date, forKey: .date)
        try container.encode(sound, forKey: .sound)
        try container.encode(volume, forKey: .volume)
        try container.encode(snoozeDuration, forKey: .snoozeDuration)
        try container.encode(isSnooze, forKey: .isSnooze)
        try container.encode(isEnabled, forKey: .isEnabled)
        try container.encode(repeatOptions, forKey: .repeatOptions)
        try container.encodeIfPresent(alarm, forKey: .alarm)
        try container.encode(type, forKey: .type)
    }
    
    nonisolated
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        date = try container.decode(Date.self, forKey: .date)
        sound = try container.decodeIfPresent(AlarmSound.self, forKey: .sound) ?? .beep
        volume = try container.decodeIfPresent(Float.self, forKey: .volume) ?? 1
        snoozeDuration = try container.decodeIfPresent(Duration.self, forKey: .snoozeDuration) ?? .seconds(1 * 60)
        isSnooze = try container.decode(Bool.self, forKey: .isSnooze)
        isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
        repeatOptions = try container.decodeIfPresent(AlarmRepeatOptions.self, forKey: .repeatOptions) ?? AlarmRepeatOptions(rawValue: 0)
        alarm = try container.decodeIfPresent(Alarm.self, forKey: .alarm)
        type = try container.decodeIfPresent(AlarmType.self, forKey: .type) ?? .other
    }
}

#if DEBUG
extension AlarmItem {
 
    static var placeholder: AlarmItem {
        AlarmItem(id: UUID(), title: String(localized: "Tomorrow Morning"), type: .sleep)
    }
    
    static var alarm1: AlarmItem {
        AlarmItem(id: UUID(), title: String(localized: "Alarm"), date: Date().addingTimeInterval(60), type: .sleep)
    }
    
    static var snoozeAlarm: AlarmItem {
        AlarmItem(id: UUID(), title: String(localized: "Snooze"), date: Date().addingTimeInterval(120), isSnooze: true)
    }
    
    static var repeatAlarm: AlarmItem {
        AlarmItem(id: UUID(), title: String(localized: "Repeat"), date: Date().addingTimeInterval(180), repeatOptions: .monday)
    }
    
    static var disabledAlarm: AlarmItem {
        AlarmItem(id: UUID(), title: String(localized: "Alarm Off"), date: Date().addingTimeInterval(180), isEnabled: true)
    }
}
#endif
