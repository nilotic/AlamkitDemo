//
//  LogsData.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI
import SwiftData
import OSLog

@MainActor
@Observable
final class LogsData {
    
    // MARK: - Value
    // MARK: Public
    var dates = Set<DateComponents>()
    
    // MARK: Private
    @ObservationIgnored
    private let calendar = Calendar.current
    
    @ObservationIgnored
    private let context: ModelContext?
    
    
    // MARK: - Initializer
    init() {
        do {
            let container = try ModelContainer(for: LogEntity.self)
            context = ModelContext(container)
            
        } catch {
            context = nil
            Logger(subsystem: "Log", category: "Initializer").error("Failed to create model container. \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - Function
    // MARK: Public
    func request() {
        guard let context else { return }
        
        do {
            let descriptor = FetchDescriptor<LogEntity>(sortBy: [.init(\.date, order: .reverse)])
            let logs = try context.fetch(descriptor)
            
            dates = Set(logs.map { calendar.dateComponents([.year, .month, .day], from: $0.date) })
            
        } catch {
            Logger(subsystem: "Log", category: "Request").error("Failed to fetch logs. \(error.localizedDescription)")
        }
    }
    
    func add(_ item: AlarmItem?) {
        guard let context, let date = item?.date else { return }
        let normalizedDate = calendar.startOfDay(for: date)
        
        do {
            let logs = try context.fetch(FetchDescriptor<LogEntity>())
            let isExists = logs.contains { calendar.isDate($0.date, inSameDayAs: normalizedDate) }
           
            guard !isExists else {
                request()
                return
            }
            
            let log = LogEntity(date: normalizedDate)
            context.insert(log)
            
            try context.save()
            request()
            
        } catch {
            Logger(subsystem: "Log", category: "Add").error("Failed to save log. \(error.localizedDescription)")
        }
    }
}
