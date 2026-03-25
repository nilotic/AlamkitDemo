//
//  AlarmSection.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI

struct AlarmSection: Sendable {
    var index = 0
    var items = [AlarmItem]()
    let type: AlarmType
}

extension AlarmSection {
    
    mutating func add(_ item: AlarmItem) {
        var item = item
        item.indexPath = IndexPath(item: items.count, section: index)
        items.append(item)
    }
    
    nonisolated
    mutating func update(index: Int) {
        self.index = index
        
        for i in 0..<items.count {
            items[i].indexPath = IndexPath(item: i, section: index)
        }
    }
    
    mutating func update(_ item: AlarmItem) throws {
        guard item.indexPath.item < items.count, items[item.indexPath.item] == item else {
            throw AlarmError.notFound
        }
        
        items[item.indexPath.item] = item
    }
    
    mutating func remove(_ item: AlarmItem) {
        guard item.indexPath.item < items.count, items[item.indexPath.item] == item else {
            return
        }
        
        items.remove(at: item.indexPath.item)
        
        for i in item.indexPath.item..<items.count {
            items[i].indexPath.item = i
        }
    }
}

extension AlarmSection: RawRepresentable {
    
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

extension AlarmSection: Identifiable {
    
    var id: AlarmType {
        type
    }
}

extension AlarmSection: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AlarmSection: Equatable {
    
    static func == (lhs: AlarmSection, rhs: AlarmSection) -> Bool {
        lhs.id == rhs.id
    }
}

extension AlarmSection: CustomStringConvertible {
   
    var description: String {
        type.description
    }
}

extension AlarmSection: CustomDebugStringConvertible {
    
    var debugDescription: String {
        description
    }
}

extension AlarmSection: Codable {
    
    private enum Key: String, CodingKey {
        case items
        case type
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        try container.encode(items, forKey: .items)
        try container.encode(type, forKey: .type)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        items = try container.decode([AlarmItem].self, forKey: .items)
        type = try container.decode(AlarmType.self, forKey: .type)
    }
}

#if DEBUG
extension AlarmSection {
 
    static var placeholder: AlarmSection {
        AlarmSection(items: [.placeholder, .alarm1], type: .sleep)
    }
    
    static var other: AlarmSection {
        AlarmSection(items: [.snoozeAlarm, .repeatAlarm, .disabledAlarm], type: .other)
    }
    
}
#endif
