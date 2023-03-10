//
//  ShareApp_okuboApp.swift
//  ShareApp-okubo
//
//  Created by 大久保徹郎 on 2023/02/15.
//

import SwiftUI

@main
struct ShareApp_okuboApp: App {
    // NSPersistentContainerの初期化
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
