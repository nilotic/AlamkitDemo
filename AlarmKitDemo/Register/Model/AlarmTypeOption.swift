//
//  AlarmTypeOption.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import Foundation

struct AlarmTypeOption {
    var index = 0
    var isOn = false
    let type: AlarmType
}

extension AlarmTypeOption: RawRepresentable {
    
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

extension AlarmTypeOption: Identifiable {
    
    var id: String {
        type.rawValue
    }
}

extension AlarmTypeOption: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AlarmTypeOption: Equatable {
    
    static func == (lhs: AlarmTypeOption, rhs: AlarmTypeOption) -> Bool {
        lhs.id == rhs.id
    }
}

extension AlarmTypeOption: CustomStringConvertible {
   
    var description: String {
        rawValue
    }
}

extension AlarmTypeOption: CustomDebugStringConvertible {
    
    var debugDescription: String {
        rawValue
    }
}

extension AlarmTypeOption: Codable {
    
    private enum Key: String, CodingKey {
        case isOn
        case type
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(isOn, forKey: .isOn)
        try container.encode(type, forKey: .type)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        isOn = try container.decode(Bool.self, forKey: .isOn)
        type = try container.decode(AlarmType.self, forKey: .type)
    }
}

#if DEBUG
extension AlarmTypeOption {
 
    static var placeholder: AlarmTypeOption {
        AlarmTypeOption(type: .sleep)
    }
}
#endif
