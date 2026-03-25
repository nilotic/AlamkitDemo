//
//  AlarmSoundPicker.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI

struct AlarmSoundPicker: View {
    
    // MARK: - Value
    // MARK: Public
    @Binding var data: AlarmSound
    
    // MARK: Private
    @State private var options = [AlarmSoundOption]()
    @State private var selectedIndex = 0
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        contentView
            .task {
                var options = [AlarmSoundOption]()
                for (i, sound) in AlarmSound.allCases.enumerated() {
                    let option = AlarmSoundOption(index: i, title: sound.description, sound: sound, isOn: data == sound)
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
            soundsView
            
        } label: {
            HStack {
                Text("Sound")
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
    private var soundsView: some View {
        ForEach($options) { $option in
            Button {
                if selectedIndex < options.count {
                    options[selectedIndex].isOn = false
                }
                
                $option.wrappedValue.isOn = true
                selectedIndex = option.index
                
                data = option.sound
                
            } label: {
                Toggle(option.title, isOn: $option.isOn)
            }
        }
    }
}


#if DEBUG
#Preview {
    @Previewable @State var data: AlarmSound = .beep
    
    Form {
        Section {
            AlarmSoundPicker(data: $data)
        }
    }
}
#endif
