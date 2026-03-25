//
//  AlarmRepeatOptions.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import AlarmKit

struct AlarmRepeatOptions: OptionSet, Sendable {
    static let sunday = AlarmRepeatOptions(rawValue: 1 << 0)
    static let monday = AlarmRepeatOptions(rawValue: 1 << 1)
    static let tuesday = AlarmRepeatOptions(rawValue: 1 << 2)
    static let wednesday = AlarmRepeatOptions(rawValue: 1 << 3)
    static let thursday = AlarmRepeatOptions(rawValue: 1 << 4)
    static let friday = AlarmRepeatOptions(rawValue: 1 << 5)
    static let saturday = AlarmRepeatOptions(rawValue: 1 << 6)
    
    let rawValue: UInt8
}

extension AlarmRepeatOptions {
    
    mutating func toggle(_ option: AlarmRepeatOptions) {
        formSymmetricDifference(option)
    }
}

extension AlarmRepeatOptions {
    
    static let weekend: AlarmRepeatOptions = [.sunday, .saturday]
    static let weekdays: AlarmRepeatOptions = [.monday, .tuesday, .wednesday, .thursday, .friday]
    static let everyday: AlarmRepeatOptions = [.weekend, .weekdays]
}

extension AlarmRepeatOptions {
    
    var options: [AlarmRepeatOption] {
        Self.allCases.map {
            let title = if $0 == .sunday {
                String(localized: "Every Sunday")
                
            } else if $0 == .monday {
                String(localized: "Every Monday")
                
            } else if $0 == .tuesday {
                String(localized: "Every Tuesday")
                
            } else if $0 == .wednesday {
                String(localized: "Every Wednesday")
                
            } else if $0 == .thursday {
                String(localized: "Every Thursday")
                
            } else if $0 == .friday {
                String(localized: "Every Friday")
                
            } else if $0 == .saturday {
                String(localized: "Every Saturday")
                
            } else {
                String(localized: "Never")
            }
            
            return AlarmRepeatOption(title: title, option: $0.rawValue, isOn: contains($0))
        }
    }
    
    var repeats: Alarm.Schedule.Relative.Recurrence {
        weekdays.isEmpty ? .never : .weekly(weekdays)
    }
    
    var weekdays: [Locale.Weekday] {
        Self.allCases.reduce(into: [Locale.Weekday]()) { result, option in
            guard contains(option) else { return }

            if option == .sunday {
                result.append(.sunday)

            } else if option == .monday {
                result.append(.monday)

            } else if option == .tuesday {
                result.append(.tuesday)

            } else if option == .wednesday {
                result.append(.wednesday)

            } else if option == .thursday {
                result.append(.thursday)

            } else if option == .friday {
                result.append(.friday)

            } else if option == .saturday {
                result.append(.saturday)
            }
        }
    }
}

extension AlarmRepeatOptions: CustomStringConvertible {
    
    var description: String {
        if self.isEmpty { return String(localized: "Never") }
        if self == .everyday { return String(localized: "Every day") }
        if self == .weekdays { return String(localized: "Weekdays") }
        if self == .weekend { return String(localized: "Weekends") }

        let short = Calendar.current.shortWeekdaySymbols
        let labels: [String] = Self.allCases.compactMap { type in
            guard contains(type) else { return nil }
            switch type {
            case .sunday:    return short[0]
            case .monday:    return short[1]
            case .tuesday:   return short[2]
            case .wednesday: return short[3]
            case .thursday:  return short[4]
            case .friday:    return short[5]
            case .saturday:  return short[6]
            default:         return nil
            }
        }
        
        return ListFormatter.localizedString(byJoining: labels)
    }
}

extension AlarmRepeatOptions: CustomDebugStringConvertible {
    
    var debugDescription: String {
        description
    }
}

extension AlarmRepeatOptions: Identifiable {
    
    var id: UInt8 {
        rawValue
    }
}

extension AlarmRepeatOptions: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AlarmRepeatOptions: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension AlarmRepeatOptions: CaseIterable {
    
    static var allCases: [Self] {
        [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    }
}

extension AlarmRepeatOptions: Codable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rawValue: try container.decode(UInt8.self))
    }
}
