//
//  todoApp.swift
//  todo
//
//  Created by USER on 20.11.2024.
//

import SwiftUI

@main
struct todoApp: App {
    var body: some Scene {
        WindowGroup {
            TaskListRouter.createModule()
                .environment(\.managedObjectContext, CoreDataManager.shared.context)
        }
    }
}
