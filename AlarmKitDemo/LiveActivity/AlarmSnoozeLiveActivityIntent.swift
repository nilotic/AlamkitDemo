//
//  AlarmSnoozeLiveActivityIntent.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import AlarmKit
import AppIntents
import ActivityKit

struct AlarmSnoozeLiveActivityIntent: LiveActivityIntent {
    
    // MARK: - Value
    // MARK: Public
    static var title = LocalizedStringResource("Snooze")
    static var openAppWhenRun = false

    @Parameter(title: "Alarm")
    var alarmID: String

    
    // MARK: - Initializer
    init() {
        alarmID = ""
    }

    init(alarmID: UUID) {
        self.alarmID = alarmID.uuidString
    }

    
    // MARK: - Function
    // MARK: Public
    func perform() async throws -> some IntentResult {
        guard let id = UUID(uuidString: alarmID) else { return .result() }
        await AlarmLiveActivityData.save(type: .snooze, alarmID: id)
        
        try? AlarmManager.shared.countdown(id: id)
        return .result()
    }
}
