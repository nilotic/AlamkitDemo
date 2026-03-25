//
//  AlarmLiveActivityData.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import Foundation

struct AlarmLiveActivityData {
    
    // MARK: - Value
    // MARK: Private
    private static let key = "AlarmLiveActivityAction"

    
    // MARK: - Function
    // MARK: Public
    static func save(type: AlarmAlarmLiveActivityActionType, alarmID: UUID) {
        let action = AlarmLiveActivityAction(alarmID: alarmID, createDate: .now, type: type)
        
        guard let data = try? JSONEncoder().encode(action) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func consume(maxAge: TimeInterval = 30) -> AlarmLiveActivityAction? {
        defer { UserDefaults.standard.removeObject(forKey: key) }

        guard let data = UserDefaults.standard.data(forKey: key), let action = try? JSONDecoder().decode(AlarmLiveActivityAction.self, from: data),
            Date().timeIntervalSince(action.createDate) <= maxAge else {
            return nil
        }
        
        return action
    }
}
