//
//  AlarmsData.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI
import AlarmKit
import OSLog

@Observable
@MainActor
final class AlarmsData {
    
    // MARK: - Value
    // MARK: Public
    var sections = [AlarmSection]()
    var selectedItem: AlarmItem?
    var alertingItem: AlarmItem?
    var isProgressing = true
    
    var isLogsViewPresented = false
    var isRegisterViewPresented = false
    var isLogAlertPresented = false
    var alertTitle = String(localized: "log.alert.title")
    
    // MARK: Private
    @ObservationIgnored
    private let sectionsKey = "AlarmSections"
    
    @ObservationIgnored
    private var pendingStoppedAlarmID: UUID?
    
    @ObservationIgnored
    private var previousAlertingIDs = Set<UUID>()
    
    @ObservationIgnored
    private var task: Task<Void, Never>?
    
    @ObservationIgnored
    private var scenePhase: ScenePhase = .active
    
    
    // MARK: - Initializer
    init() {
        updateAlarms()
    }
    
    
    // MARK: - Function
    // MARK: Public
    func request() {
        Task { @concurrent in
            await MainActor.run { isProgressing = true }
            
            do {
                var sections = try await load()
                for i in 0..<sections.count {
                    sections[i].update(index: i)
                }
                
                let updatedSections = sections
                await MainActor.run { self.sections = updatedSections }
                
            } catch {
                Logger(subsystem: "Alarm", category: "Request").error("\(error.localizedDescription)")
            }
            
            await MainActor.run { isProgressing = false }
        }
    }
    
    func handle(_ action: AlarmItemAction) {
        switch action {
        case .select(let item):
            selectedItem = item
            isRegisterViewPresented = true
            
        case .remove(let item):
            remove(item)
        }
    }
    
    func handle(_ item: AlarmItem?) {
        defer { selectedItem = nil }
        
        guard let item else { return }
        if selectedItem == item {
            update(item)
            
        } else {
            add(item)
        }
    }
    
    func save() {
        let sections = sections
        let sectionsKey = sectionsKey
        
        Task(priority: .background) {
            guard !sections.isEmpty else {
                UserDefaults.standard.removeObject(forKey: sectionsKey)
                return
            }
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            
            let encoded = try encoder.encode(sections)
            UserDefaults.standard.set(encoded, forKey: sectionsKey)
        }
    }

    func log(_ item: AlarmItem?) {
        if let item {
            LogsData().add(item)

            if item.repeatOptions.isEmpty {
                remove(item)
            }
        }
        
        alertTitle = String(localized: "log.alert.title")
        isLogAlertPresented = false
        alertingItem = nil
    }
    
    func remove(_ item: AlarmItem?) {
        if isLogAlertPresented, alertingItem?.id == item?.id {
            alertTitle = String(localized: "log.alert.title")
            isLogAlertPresented = false
            alertingItem = nil
        }
        
        guard let item, let index = sections.firstIndex(where: { $0.index == item.indexPath.section }) else { return }
        sections[index].remove(item)
        
        try? AlarmManager.shared.cancel(id: item.id)
        sections.removeAll { $0.items.isEmpty }
        
        save()
    }
    
    func handle(_ phase: ScenePhase) {
        scenePhase = phase
        guard phase == .active else { return }

        Task {
            do {
                let alarms = try AlarmManager.shared.alarms
                handle(alarms: alarms, state: .activation)

            } catch {
                Logger(subsystem: "Alarm", category: "Lifecycle").error("Failed to fetch alarms on active: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Private
    private func add(_ item: AlarmItem) {
        var item = item
        
        // Only one alarm item is allowed per type.
        if let index = sections.firstIndex(where: { $0.type == item.type }) {
            if let first = sections[index].items.first {
                try? AlarmManager.shared.cancel(id: first.id)
            }
            
            sections[index].items = [item]
            
        } else {
            switch item.type {
            case .sleep:
                item.indexPath = IndexPath(item: 0, section: 0)
                sections.insert(AlarmSection(items: [item], type: item.type), at: 0)
                
            case .other:
                item.indexPath = IndexPath(item: 0, section: sections.count)
                sections.append(AlarmSection(items: [item], type: item.type))
            }
        }
        
        save()
    }
    
    private func update(_ item: AlarmItem) {
        do {
            guard let index = sections.firstIndex(where: { $0.index == item.indexPath.section }) else {
                throw AlarmError.notFound
            }
            
            try sections[index].update(item)
            save()
            
        } catch {
            Logger(subsystem: "Alarm", category: "update").error("Failed to update item. \(item.debugDescription)")
        }
    }
    
    private func updateAlarms() {
        guard task == nil else { return }
        
        task = Task { [weak self] in
            for await alarms in AlarmManager.shared.alarmUpdates {
                guard !Task.isCancelled else { break }
                self?.handle(alarms: alarms, state: .stream)
            }
        }
    }
    
    private func handle(alarms: [Alarm], state: AlarmState) {
        let previousItems = Dictionary(uniqueKeysWithValues: sections.lazy.flatMap(\.items).map { ($0.id, $0) })
        
        let updatedAlarms = Dictionary(uniqueKeysWithValues: alarms.map { ($0.id, $0) })
        let alarmIDs = Set(updatedAlarms.keys)
        
        let currentAlertingIDs = Set(alarms.lazy.filter { $0.state == .alerting }.map(\.id))
        let resolvedAlertingIDs = previousAlertingIDs.subtracting(currentAlertingIDs)
        
        var protectedIDs = Set([pendingStoppedAlarmID, alertingItem?.id].compactMap { $0 })
        protectedIDs.formUnion(resolvedAlertingIDs)
        
        if pendingStoppedAlarmID == nil, let alertingID = currentAlertingIDs.first {
            pendingStoppedAlarmID = alertingID
        }
        
        var hasChanges = false
        
        for sectionIndex in sections.indices {
            let originalCount = sections[sectionIndex].items.count
            sections[sectionIndex].items.removeAll { !alarmIDs.contains($0.id) && !protectedIDs.contains($0.id) }
            
            if originalCount != sections[sectionIndex].items.count {
                hasChanges = true
            }
            
            for index in sections[sectionIndex].items.indices {
                let id = sections[sectionIndex].items[index].id
                sections[sectionIndex].items[index].alarm = updatedAlarms[id]
            }
        }
        
        let originalSectionCount = sections.count
        sections.removeAll { $0.items.isEmpty }
        
        if originalSectionCount != sections.count {
            hasChanges = true
        }
        
        if hasChanges {
            for index in sections.indices {
                sections[index].update(index: index)
            }
            
            save()
        }
        
        guard !isLogAlertPresented else {
            previousAlertingIDs = currentAlertingIDs
            return
        }
        
        let fallbackID: UUID? = if state == .activation {
            previousItems.values
                .filter { $0.repeatOptions.isEmpty && $0.date <= .now && !alarmIDs.contains($0.id) }
                .sorted(by: { $0.date > $1.date })
                .first?.id
            
        } else {
            nil
        }
        
        let candidateID: UUID? = if let pendingStoppedAlarmID, !currentAlertingIDs.contains(pendingStoppedAlarmID) {
            pendingStoppedAlarmID
            
        } else if let resolvedID = resolvedAlertingIDs.first {
            resolvedID
            
        } else {
            fallbackID
        }
        
        if let candidateID, let item = previousItems[candidateID] ?? sections.lazy.flatMap(\.items).first(where: { $0.id == candidateID }) {
            alertingItem = item
            if state == .stream, scenePhase == .active {
                alertTitle = String(localized: "log.alert.title")
                
            } else {
                alertTitle = String(localized: "log.alert.pending.title")
            }
            
            isLogAlertPresented = true
            pendingStoppedAlarmID = nil
        }
        
        previousAlertingIDs = currentAlertingIDs
    }
    
    nonisolated
    private func load() async throws -> [AlarmSection] {
        guard let data = UserDefaults.standard.data(forKey: sectionsKey) else { return [] }
        let decodear = JSONDecoder()
        decodear.dateDecodingStrategy = .iso8601
        
        return try decodear.decode([AlarmSection].self, from: data)
    }
}
