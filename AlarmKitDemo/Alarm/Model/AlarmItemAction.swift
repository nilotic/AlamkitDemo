//
//  AlarmItemAction.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import Foundation

enum AlarmItemAction: Sendable {
    case select(AlarmItem)
    case remove(AlarmItem)
}

extension AlarmItemAction: RawRepresentable {
    
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

extension AlarmItemAction: CustomStringConvertible {
    
    var description: String {
        id
    }
}

extension AlarmItemAction: CustomDebugStringConvertible {
    
    var debugDescription: String {
        description
    }
}

extension AlarmItemAction: Identifiable {
    
    var id: String {
        switch self {
        case .select:  "select"
        case .remove:  "remove"
        }
    }
}

extension AlarmItemAction: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AlarmItemAction: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension AlarmItemAction: Codable {
    
    private enum Key: String, CodingKey {
        case id
        case item
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        switch self {
        case .select(let item):
            try container.encode(id, forKey: .id)
            try container.encode(item, forKey: .item)
            
        case .remove(let item):
            try container.encode(id, forKey: .id)
            try container.encode(item, forKey: .item)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        let name = (try? container.decode(String.self, forKey: .id)) ?? ""
        let item = (try? container.decode(AlarmItem.self, forKey: .item)) ?? AlarmItem()
        
        switch name {
        case "select":  self = .select(item)
        case "remove":  self = .remove(item)
        default:        self = .select(item)
        }
    }
}

