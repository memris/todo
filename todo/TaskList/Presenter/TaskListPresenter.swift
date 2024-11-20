//
//  TaskListPresenter.swift
//  todo
//
//  Created by USER on 20.11.2024.
//

import SwiftUI

class TaskListPresenter: ObservableObject {
    @Published var tasks: [Task] = []
    private let interactor: TaskListInteractor

    init(interactor: TaskListInteractor) {
        self.interactor = interactor
    }

    func loadTasks() {
        interactor.fetchTasks { [weak self] tasks in
            self?.tasks = tasks
        }
    }
}

