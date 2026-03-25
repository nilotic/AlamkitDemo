//
//  AlarmRegisterView.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI

struct AlarmRegisterView: View {
    
    // MARK: - Value
    // MARK: Public
    var item: AlarmItem?
    var action: ((AlarmItem?) -> Void)?
    
    // MARK: Private
    @State private var data = AlarmRegisterData()
    
    @Environment(\.dismiss) private var dismiss
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Add Alarm")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
                .toolbar {
                    leadingBarButtonItem
                    trailingBarButtonItem
                }
                .onChange(of: data.scheduledAlarmItem) {
                    action?(data.scheduledAlarmItem)
                    dismiss()
                }
                .task {
                    data.update(item)
                }
        }
    }
    
    // MARK: Private
    private var contentView: some View {
        Form {
            datePicker
            
            Section {
                AlarmRepeatOptionsPicker(data: $data.repeatOptions)
                titleTextField
                AlarmSoundPicker(data: $data.sound)
                snoozeToggle
                SnoozeDurationPicker(data: $data.snoozeDuration)
                AlarmTypePicker(data: $data.type)
            }
        }
    }
    
    private var datePicker: some View {
        AlarmTimePicker(data: $data.date)
            .listRowBackground(Color.clear)
    }
    
    private var titleTextField: some View {
        HStack {
            Text("Title")
                .fontWeight(.medium)
            
            TextField("Alarm", text: $data.title)
                .multilineTextAlignment(.trailing)
        }
    }
    
    private var snoozeToggle: some View {
        Toggle(isOn: $data.isSnooze) {
            Text("Snooze")
                .fontWeight(.medium)
        }
    }
    
    private var leadingBarButtonItem: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
                
            } label: {
                Image(systemName: "xmark")
            }
        }
    }
    
    private var trailingBarButtonItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                data.schedule()
                
            } label: {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
            }
        }
    }
}

#if DEBUG
#Preview {
    AlarmRegisterView()
}
#endif

