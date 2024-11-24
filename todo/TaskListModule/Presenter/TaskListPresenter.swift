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
    @Published var searchQuery = "" 
    private let interactor: TaskListInteractor

    init(interactor: TaskListInteractor) {
        self.interactor = interactor
        interactor.fetchTasks { [weak self] tasks in
                  DispatchQueue.main.async {
                      self?.tasks = tasks
                  }
              }
    }

//    func addTask(_ task: Task) {
//        tasks.insert(task, at: 0)
//        CoreDataManager.shared.saveContext()
//    }
    func addTask(_ task: Task) {
        let context = CoreDataManager.shared.context
        let entity = TaskEntity(context: context)

        entity.id = Int64(task.id)
        entity.title = task.title
        entity.isCompleted = task.isCompleted
        entity.taskDescription = task.taskDescription
        entity.creationDate = task.creationDate

        do {
            try context.save()
            tasks.insert(task, at: 0)
        } catch {
            print("Failed to save new task: \(error)")
        }
    }


    func deleteTask(_ task: Task) {
        interactor.deleteTask(task) { [weak self] in
            self?.tasks.removeAll { $0.id == task.id }
            CoreDataManager.shared.saveContext()
        }
    }

//    func updateTask(_ updatedTask: Task) {
//        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
//            tasks[index] = updatedTask
//        }
//    }

    func formatShortDate(date: Date) -> String {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yy"
          return formatter.string(from: date)
      }

    func searchTasks(query: String) {
        print("search in presenter")
        interactor.searchTasks(query: query) { tasks in
            DispatchQueue.main.async {
                self.tasks = tasks 
            }
        }
    }}
