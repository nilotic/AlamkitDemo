//
//  AlarmSoundOption.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import Foundation

struct AlarmSoundOption: Sendable {
    var index = 0
    let title: String
    let sound: AlarmSound
    var isOn = false
}

extension AlarmSoundOption: RawRepresentable {
    
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

extension AlarmSoundOption: Identifiable {
    
    var id: String {
        sound.rawValue
    }
}

extension AlarmSoundOption: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AlarmSoundOption: Equatable {
    
    static func == (lhs: AlarmSoundOption, rhs: AlarmSoundOption) -> Bool {
        lhs.id == rhs.id
    }
}

extension AlarmSoundOption: CustomStringConvertible {
   
    var description: String {
        rawValue
    }
}

extension AlarmSoundOption: CustomDebugStringConvertible {
    
    var debugDescription: String {
        rawValue
    }
}

extension AlarmSoundOption: Codable {
    
    private enum Key: String, CodingKey {
        case title
        case sound
        case isOn
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(sound, forKey: .sound)
        try container.encode(isOn, forKey: .isOn)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        title = try container.decode(String.self, forKey: .title)
        sound = try container.decode(AlarmSound.self, forKey: .sound)
        isOn = try container.decode(Bool.self, forKey: .isOn)
    }
}

#if DEBUG
extension AlarmSoundOption {
 
    static var placeholder: AlarmSoundOption {
        AlarmSoundOption(title: String(localized: "Beep"), sound: .beep)
    }
}
#endif
