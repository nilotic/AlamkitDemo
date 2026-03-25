//
//  LogEntity.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import Foundation
import SwiftData

@Model
final class LogEntity {
    var date: Date
    
    init(date: Date = .now) {
        self.date = date
    }
}
