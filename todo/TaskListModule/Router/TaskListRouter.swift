//
//  TaskListRouter.swift
//  todo
//
//  Created by USER on 20.11.2024.
//

import SwiftUI

class TaskListRouter {
    static func createModule() -> some View {
        let interactor = TaskListInteractor()
        let presenter = TaskListPresenter(interactor: interactor)
        return TaskListView(presenter: presenter)
    }
}
enum NavigationRoute: Hashable {
    case taskDetail(Task)
}
