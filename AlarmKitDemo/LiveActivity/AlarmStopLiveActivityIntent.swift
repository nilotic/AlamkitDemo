//
//  AlarmStopLiveActivityIntent.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import AlarmKit
import AppIntents

struct AlarmStopLiveActivityIntent: LiveActivityIntent {
    
    // MARK: - Value
    // MARK: Pubilc
    static var title = LocalizedStringResource("Stop")
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
    func perform() throws -> some IntentResult {
        try AlarmManager.shared.stop(id: UUID(uuidString: alarmID)!)
        return .result()
    }
}
