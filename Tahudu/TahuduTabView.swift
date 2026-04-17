//
//  TahuduTabView.swift
//  Tahudu
//

import SwiftUI

struct TahuduTabView: View {
    @State private var selectedTab: Tabs = .search
    let dependencies: AppDependencies
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    var body: some View {
        TabView(selection: $selectedTab) {
            SearchView(listingService: dependencies.listingService, keyValueStore: dependencies.keyValueStore)
                .tag(Tabs.search)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            SettingsView()
                .tag(Tabs.settings)
                .tabItem {
                    Label("My Account", systemImage: "person")
                }
                .edgesIgnoringSafeArea(.all)
        }
        .tint(.brand)
    }
}

enum Tabs: Int, CaseIterable {
    case search = 0
    case settings

    var name: String {
        switch self {
        case .search:
            return "Search"
        case .settings:
            return "Settings"
        }
    }
}

struct TahuduTabView_Previews: PreviewProvider {
    static var previews: some View {
        TahuduTabView(dependencies: .preview())
    }
}
