//
//  AlarmRegisterData.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI
import Foundation
import AlarmKit
import OSLog

@MainActor
@Observable
final class AlarmRegisterData {
    
    // MARK: - Value
    // MARK: Public
    var title = String(localized: "Alarm")
    var date = Date().addingTimeInterval(15)
    var sound: AlarmSound = .beep
    var snoozeDuration: Duration = .seconds(1 * 60)
    var isSnooze = false
    var isEnabled = true
    var repeatOptions: AlarmRepeatOptions = []
    var alarm: Alarm?
    var type: AlarmType = .sleep
    
    var scheduledAlarmItem: AlarmItem?
    
    
    // MARK: Private
    @ObservationIgnored
    private var id = UUID()
    
    
    // MARK: - Function
    // MARK: Public
    func update(_ item: AlarmItem?) {
        guard let item else { return }
        id = item.id
        title = item.title
        date = item.date
        sound = item.sound
        snoozeDuration = item.snoozeDuration
        isSnooze = item.isSnooze
        isEnabled = item.isEnabled
        repeatOptions = item.repeatOptions
        type = item.type
    }
    
    func schedule() {
        var item = AlarmItem(id: id, title: title, date: date, sound: sound,
                             snoozeDuration: snoozeDuration, isSnooze: isSnooze, isEnabled: isEnabled,
                             repeatOptions: repeatOptions, alarm: alarm, type: type)
        
        let repeats = repeatOptions.repeats
        let alertSound = sound.alertSound
        Task { @concurrent in
            do {
                try await requestAuthorization()
                
                let schedule = try schedule(date: item.date, repeats: repeats)
                let alert = alert(item)
                
                let attributes = AlarmAttributes<AlarmItem>(presentation: AlarmPresentation(alert: alert), tintColor: Color.accentColor)
                let configuration = AlarmManager.AlarmConfiguration<AlarmItem>(countdownDuration: countdownDuration(item),
                                                                               schedule: schedule,
                                                                               attributes: attributes,
                                                                               sound: alertSound)
                
                item.alarm = try await AlarmManager.shared.schedule(id: item.id, configuration: configuration)
                
                let scheduledAlarmItem = item
                await MainActor.run { self.scheduledAlarmItem = scheduledAlarmItem }
                
            } catch {
                Logger(subsystem: "Register", category: "Schedule").error("Error encountered when scheduling alarm: \(error)")
            }
        }
    }
    
    // MARK: Private
    nonisolated
    private func schedule(date: Date, repeats: Alarm.Schedule.Relative.Recurrence) throws -> Alarm.Schedule {
        switch repeats {
        case .never:
            guard Date() < date else { throw AlarmError.invalidDate }
            return .fixed(date)
            
        case .weekly:
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            guard let hour = components.hour, let minute = components.minute else {
                throw AlarmError.invalidDate
            }
            
            let time = Alarm.Schedule.Relative.Time(hour: hour, minute: minute)
            return .relative(.init(time: time, repeats: repeats))
        
        @unknown default:
            throw AlarmError.invalidDate
        }
    }
    
    nonisolated
    private func requestAuthorization() async throws {
        switch AlarmManager.shared.authorizationState {
        case .authorized:
            break
        
        case .notDetermined:
            let state = try await AlarmManager.shared.requestAuthorization()
            guard state == .authorized else { throw AlarmError.unauthorized }
            
        case .denied:
            throw AlarmError.denied
            
        @unknown default:
            throw AlarmError.unknown
        }
    }

    nonisolated
    private func alert(_ item: AlarmItem) -> AlarmPresentation.Alert {
        guard item.isSnooze else { return AlarmPresentation.Alert(title: "\(item.title)") }
        let snoozeButton = AlarmButton(text: "Snooze", textColor: Color(.label), systemImageName: "zzz")
        
        return AlarmPresentation.Alert(title: "\(item.title)", secondaryButton: snoozeButton, secondaryButtonBehavior: .countdown)
    }

    nonisolated
    private func countdownDuration(_ item: AlarmItem) -> Alarm.CountdownDuration? {
        guard item.isSnooze else { return nil }
        let components = item.snoozeDuration.components
        let timeinterval = TimeInterval(components.seconds) + (Double(components.attoseconds) / 1_000_000_000_000_000_000)
        
        return Alarm.CountdownDuration(preAlert: nil, postAlert: timeinterval)
    }
}
