//
//  AlarmsView.swift
//  AlarmKitDemo
//
//  Created by Den on 3/25/26.
//

import SwiftUI

struct AlarmsView: View {
    
    // MARK: - Value
    // MARK: Private
    @State private var data = AlarmsData()
    @ScaledMetric(relativeTo: .title2) private var dimension = 64
    @Environment(\.scenePhase) private var scenePhase
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Alarm")
                .toolbar {
                    calendarToolbarItem
                    ToolbarSpacer(.fixed)
                    plusToolbarItem
                }
                .onChange(of: scenePhase) { _, phase in
                    data.handle(phase)
                }
                .sheet(isPresented: $data.isLogsViewPresented) {
                    LogsView()
                }
                .sheet(isPresented: $data.isRegisterViewPresented) {
                    AlarmRegisterView(item: data.selectedItem) {
                        data.handle($0)
                    }
                }
                .alert(data.alertTitle, isPresented: $data.isLogAlertPresented, presenting: data.alertingItem) { item in
                    Button("OK") {
                        data.log(item)
                    }
                    
                    Button("Cancel", role: .cancel) {
                        data.remove(item)
                    }
                }
                .task {
                    data.request()
                }
        }
    }
    
    // MARK: Private
    private var contentView: some View {
        ZStack {
            sectionsView
            emptyView
            
            if data.isProgressing {
                ProgressView()
            }
        }
        .transition(.opacity)
        .animation(.smooth, value: data.sections)
    }
    
    @ViewBuilder
    private var sectionsView: some View {
        if !data.sections.isEmpty, !data.isProgressing {
            List($data.sections) { $section in
                AlarmSectionView(data: $section) {
                    data.handle($0)
                }
            }
            .listStyle(.sidebar)
            .accentColor(.gray)
        }
    }
    
    @ViewBuilder
    private var emptyView: some View {
        if data.sections.isEmpty, !data.isProgressing {
            GeometryReader { proxy in
                VStack(spacing: 12) {
                    Image(systemName: "clock.badge.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: dimension)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.orange, .secondary)
                        .fontWeight(.medium)
                    
                    Text("No Alarms")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Text("Add a new alarm by tapping + button.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, proxy.safeAreaInsets.top / 2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
        }
    }
    
    private var calendarToolbarItem: some ToolbarContent {
        ToolbarItem {
            Button {
                data.isLogsViewPresented = true
                
            } label: {
                Image(systemName: "calendar")
            }
        }
    }
    
    private var plusToolbarItem: some ToolbarContent {
        ToolbarItem {
            Button {
                data.isRegisterViewPresented = true
                
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

#if DEBUG
#Preview {
    AlarmsView()
}
#endif
