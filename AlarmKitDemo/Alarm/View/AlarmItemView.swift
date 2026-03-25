//
//  AlarmItemView.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI

struct AlarmItemView: View {
    
    // MARK: - Value
    // MARK: Public
    @Binding var data: AlarmItem
    var action: ((AlarmItemAction) -> Void)?
    
    // MARK: Private
    @State private var isEnabled = true
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        contentView
            .contentShape(Rectangle())
            .onTapGesture {
                action?(.select(data))
            }
            .swipeActions(edge: .trailing) {
                removeButton
            }
            .task {
                isEnabled = data.isEnabled
            }
    }
    
    // MARK: Private
    private var contentView: some View {
        HStack {
            VStack(alignment: .leading) {
                titleView
                dateView
            }
            
            Spacer()
            
            toggle
        }
    }
    
    private var titleView: some View {
        Text(data.title)
            .font(.caption)
            .foregroundStyle(isEnabled ? .primary : .secondary)
    }
    
    private var dateView: some View {
        Text(data.date, format: Date.FormatStyle(date: .omitted, time: .shortened))
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundStyle(isEnabled ? .primary : .secondary)
    }
    
    private var toggle: some View {
        Toggle("", isOn: $isEnabled)
            .onChange(of: isEnabled) {
                data.isEnabled = isEnabled
            }
    }
    
    private var removeButton: some View {
        Button(role: .destructive) {
            action?(.remove(data))
            
        } label: {
            Label("Remove", systemImage: "trash")
        }
    }
}

#if DEBUG
#Preview {
    @Previewable @State var data: AlarmItem = .placeholder
    
    List {
        AlarmItemView(data: $data)
    }
    .listStyle(.sidebar)
    .accentColor(.gray)
}
#endif

