//
//  AlarmSectionView.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI

struct AlarmSectionView: View {
    
    // MARK: - Value
    // MARK: Public
    @Binding var data: AlarmSection
    var action: ((AlarmItemAction) -> Void)?
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        if !data.items.isEmpty {
            Section(header: header) {
                ForEach($data.items) { $item in
                    AlarmItemView(data: $item, action: action)
                }
            }
        }
    }
    
    // MARK: Private
    @ViewBuilder
    private var header: some View {
        Image(systemName: data.type.symbolName)
            .symbolRenderingMode(.palette)
            .foregroundStyle(data.type.primaryColor, data.type.secondaryColor)
        
        Text(data.description)
            .font(.headline)
            .foregroundStyle(data.type.primaryColor)
    }
}


#if DEBUG
#Preview {
    @Previewable @State var sleepSection: AlarmSection = .placeholder
    @Previewable @State var otherSection: AlarmSection = .other
    
    List {
        AlarmSectionView(data: $sleepSection)
        AlarmSectionView(data: $otherSection)
    }
    .listStyle(.sidebar)
    .accentColor(.gray)
}
#endif

