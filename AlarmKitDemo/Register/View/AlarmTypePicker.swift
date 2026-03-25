//
//  AlarmTypePicker.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI

struct AlarmTypePicker: View {
    
    // MARK: - Value
    // MARK: Pubilc
    @Binding var data: AlarmType
    
    // MARK: Private
    @State private var options = [AlarmTypeOption]()
    @State private var selectedIndex = 0
    
    
    // MARK: - View
    // MARK: Pubilc
    var body: some View {
        contentView
            .task {
                var options = [AlarmTypeOption]()
                for (i, type) in AlarmType.allCases.enumerated() {
                    let option = AlarmTypeOption(index: i, isOn: data == type, type: type)
                    options.append(option)
                
                    guard option.isOn else { continue }
                    selectedIndex = option.index
                }
                
                self.options = options
            }
    }
    
    // MARK: Private
    private var contentView: some View {
        Menu {
            typesView
            
        } label: {
            HStack {
                Text("Type")
                    .foregroundStyle(Color(.label))
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(data.description)
                    .tint(Color(.label))
            }
        }
        .id(options.count)
    }
    
    @ViewBuilder
    private var typesView: some View {
        ForEach($options) { $option in
            Button {
                if selectedIndex < options.count {
                    options[selectedIndex].isOn = false
                }
                
                $option.wrappedValue.isOn = true
                selectedIndex = option.index
                
                data = option.type
                
            } label: {
                Toggle(option.type.description, isOn: $option.isOn)
            }
        }
    }
}

#if DEBUG
#Preview {
    @Previewable @State var data: AlarmType = .sleep
    
    Form {
        Section {
            AlarmTypePicker(data: $data)
        }
    }
}
#endif
