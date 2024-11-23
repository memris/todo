//
//  TaskListPresenter.swift
//  todo
//
//  Created by USER on 20.11.2024.
//

import SwiftUI
import Foundation

class TaskListPresenter: ObservableObject {
    @Published var tasks: [Task] = []
    private let interactor: TaskListInteractor

    init(interactor: TaskListInteractor) {
        self.interactor = interactor
        loadTasks()
    }

    func loadTasks() {
        interactor.fetchTasks { [weak self] tasks in
            DispatchQueue.main.async {
                self?.tasks = tasks
            }
        }
    }

    func addTask(_ task: Task) {
        tasks.insert(task, at: 0)
    }

    func deleteTask(_ task: Task) {
        interactor.deleteTask(task) { [weak self] in
            self?.tasks.removeAll { $0.id == task.id }
        }
    }

    func updateTask(_ updatedTask: Task) {
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
        }
    }

    func formatShortDate(date: Date) -> String {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yy"
          return formatter.string(from: date)
      }

    func searchTasks(query: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let filteredTasks = self.tasks.filter { $0.title.lowercased().contains(query.lowercased()) }
            DispatchQueue.main.async {
                self.tasks = filteredTasks
            }
        }
    }
}
