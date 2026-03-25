//
//  LogsView.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI

struct LogsView: View {
    
    // MARK: - Value
    // MARK: Private
    @State private var data = LogsData()
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Log")
                .navigationBarTitleDisplayMode(.inline)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .task { data.request() }
        }
    }
    
    // MARK: Private
    private var contentView: some View {
        MultiDatePicker("Log", selection: $data.dates)
            .datePickerStyle(.graphical)
            .overlay(overlay)
    }
    
    /// Block all touch interactions while keeping the calendar visible.
    private var overlay: some View {
        GeometryReader { proxy in
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { }
                .padding(.top, 130)
        }
    }
}


#if DEBUG
#Preview {
    ZStack {
        
    }
    .sheet(isPresented: .constant(true)) {
        LogsView()
    }
}
#endif
