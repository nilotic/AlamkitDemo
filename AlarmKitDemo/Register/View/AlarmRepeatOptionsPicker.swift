//
//  AlarmRepeatOptionsPicker.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI

struct AlarmRepeatOptionsPicker: View {
    
    // MARK: - Value
    // MARK: Public
    @Binding var data: AlarmRepeatOptions
    
    // MARK: Private
    @State private var options = [AlarmRepeatOption]()
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        contentView
            .task { options = data.options }
    }
    
    // MARK: Private
    private var contentView: some View {
        Menu {
            repeatOptionsView
            
        } label: {
            HStack {
                Text("Repeat")
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
    private var repeatOptionsView: some View {
        ForEach($options) { $option in
            Button {
                $option.wrappedValue.isOn.toggle()
                
                let option = AlarmRepeatOptions(rawValue: $option.wrappedValue.option)
                if $option.wrappedValue.isOn {
                    data.insert(option)
                } else {
                    data.remove(option)
                }
                
            } label: {
                Toggle(option.title, isOn: $option.isOn)
            }
        }
    }
}

#if DEBUG
#Preview {
    @Previewable @State var data = AlarmRepeatOptions()
    
    Form {
        Section {
            AlarmRepeatOptionsPicker(data: $data)
        }
    }
}
#endif
