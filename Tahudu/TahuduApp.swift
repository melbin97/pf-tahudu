//
//  TahuduApp.swift
//  Tahudu
//

import SwiftUI

@main
struct TahuduApp: App {
    let dependencies = AppDependencies.live()
    var body: some Scene {
        WindowGroup {
            TahuduTabView(dependencies: dependencies)
        }
    }
}
