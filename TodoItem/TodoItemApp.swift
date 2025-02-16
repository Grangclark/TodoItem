//
//  TodoItemApp.swift
//  TodoItem
//
//  Created by 長橋和敏 on 2025/02/16.
//

import SwiftUI

@main
struct TodoItemApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
