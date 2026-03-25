//
//  SnoozeDurationPicker.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI

struct SnoozeDurationPicker: View {
    
    // MARK: - Value
    // MARK: Public
    @Binding var data: Duration
    
    // MARK: Private
    @State private var selection: Int64 = 1
    private let range: ClosedRange<Int64> = 1...15
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        contentView
            .onChange(of: selection) {
                data = .seconds(selection * 60)
            }
            .task {
                selection = data.components.seconds / 60
            }
    }
    
    // MARK: Private
    private var contentView : some View {
        HStack {
            Text("Snooze duration")
                .fontWeight(.medium)
            
            Spacer()
            
            picker
        }
    }
    
    private var picker: some View {
        Picker("", selection: $selection) {
            ForEach(range, id: \.self) {
                Text(Duration.seconds($0 * 60), format: .units(allowed: [.minutes], width: .abbreviated))
                    .tag($0)
            }
        }
        .tint(Color(.label))
    }
}

#if DEBUG
#Preview {
    @Previewable @State var data: Duration = .seconds(10 * 60)
    
    Form {
        Section {
            SnoozeDurationPicker(data: $data)
        }
    }
}
#endif
