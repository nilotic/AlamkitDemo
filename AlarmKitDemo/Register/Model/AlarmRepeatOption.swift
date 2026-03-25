//
//  AlarmRepeatOption.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import Foundation

struct AlarmRepeatOption: Sendable {
    let title: String
    let option: UInt8
    var isOn = false
}

extension AlarmRepeatOption: RawRepresentable {
    
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

extension AlarmRepeatOption: Identifiable {
    
    var id: UInt8 {
        option
    }
}

extension AlarmRepeatOption: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AlarmRepeatOption: Equatable {
    
    static func == (lhs: AlarmRepeatOption, rhs: AlarmRepeatOption) -> Bool {
        lhs.id == rhs.id
    }
}

extension AlarmRepeatOption: CustomStringConvertible {
   
    var description: String {
        rawValue
    }
}

extension AlarmRepeatOption: CustomDebugStringConvertible {
    
    var debugDescription: String {
        rawValue
    }
}

extension AlarmRepeatOption: Codable {
    
    private enum Key: String, CodingKey {
        case title
        case option
        case isOn
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(option, forKey: .option)
        try container.encode(isOn, forKey: .isOn)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        title = try container.decode(String.self, forKey: .title)
        option = try container.decode(UInt8.self, forKey: .option)
        isOn = try container.decode(Bool.self, forKey: .isOn)
    }
}

#if DEBUG
extension AlarmRepeatOption {
 
    static var placeholder: AlarmRepeatOption {
        AlarmRepeatOption(title: "Every Monday", option: AlarmRepeatOptions.monday.rawValue)
    }
}
#endif

