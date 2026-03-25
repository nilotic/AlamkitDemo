//
//  AlarmTimePicker.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI

struct AlarmTimePicker: View {
    
    // MARK: - Value
    // MARK: Public
    @Binding var data: Date
    
    // MARK: Private
    @State private var hour: UInt = 0
    @State private var minute: UInt = 0
    @State private var second: UInt = 0
    @State private var meridiem: Meridiem = .am
    
    private let hourRange: ClosedRange<UInt> = 0...(12 * 50)
    private let minuteRange: ClosedRange<UInt> = 0...(60 * 50)
    private let secondRange: ClosedRange<UInt> = 0...(60 * 50)
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        contentView
            .task {
                let components = Calendar.current.dateComponents([.hour, .minute, .second], from: data)
                let hourValue = components.hour ?? 0
                let minuteValue = components.minute ?? 0
                let secondValue = components.second ?? 0

                meridiem = Meridiem(hour: hourValue)
                hour = UInt(hourValue % 12) + 12 * 24
                minute = UInt(minuteValue) + 60 * 24
                second = UInt(secondValue) + 60 * 24
            }
    }
    
    // MARK: Private
    private var contentView: some View {
        HStack(spacing: 0) {
            meridiemView
            hourView
            minuteView
            secondView
        }
        .clipped()
    }
    
    private var meridiemView: some View {
        Picker("", selection: $meridiem) {
            ForEach(Meridiem.allCases) {
                Text($0.description)
                    .tag($0)
            }
        }
        .pickerStyle(.wheel)
        .onChange(of: meridiem) {
            update()
        }
    }
    
    private var hourView: some View {
        Picker("Hour", selection: $hour) {
            ForEach(hourRange, id: \.self) { hour in
                Text("\((((hour % 12 + 11) % 12) + 1))")
                    .tag(hour)
            }
        }
        .pickerStyle(.wheel)
        .onChange(of: hour) {
           update()
        }
    }
    
    private var minuteView: some View {
        Picker("Minute", selection: $minute) {
            ForEach(minuteRange, id: \.self) {
                Text("\($0 % 60)")
                    .tag($0)
            }
        }
        .pickerStyle(.wheel)
        .onChange(of: minute) {
            update()
        }
    }
    
    private var secondView: some View {
        Picker("Second", selection: $second) {
            ForEach(secondRange, id: \.self) {
                Text("\($0 % 60)")
                    .tag($0)
            }
        }
        .pickerStyle(.wheel)
        .onChange(of: second) {
            update()
        }
    }
    
    // MARK: - Function
    // MARK: Private
    private func update() {
        let hourValue = Int(hour % 12)
        let hour = meridiem == .pm ? (hourValue == 0 ? 12 : hourValue + 12) : hourValue
        
        guard let updatedDate = Calendar.current.date(bySettingHour: hour, minute: Int(minute % 60), second: Int(second % 60), of: data) else { return }
        data = updatedDate
    }
}

#if DEBUG
#Preview {
    @Previewable @State var data = Date()
    
    AlarmTimePicker(data: $data)
}
#endif
