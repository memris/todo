//
//  todoApp.swift
//  todo
//
//  Created by USER on 20.11.2024.
//

import SwiftUI

@main
struct todoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TaskListRouter.createModule()
        }
    }
}
