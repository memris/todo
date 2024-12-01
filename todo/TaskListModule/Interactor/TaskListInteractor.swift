//
//  TaskListInteractor.swift
//  todo
//
//  Created by USER on 20.11.2024.
//

import SwiftUI
import CoreData

class TaskListInteractor {
    @Published var tasks: [Task] = []
    
    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        print("fetchTasks")

        self.fetchTasksFromCoreData { coreDataTasks in
            if !coreDataTasks.isEmpty {
                print("Fetched tasks from Core Data: \(coreDataTasks.count) tasks")
                DispatchQueue.main.async {
                    self.tasks = coreDataTasks
                    completion(self.tasks)
                }
            } else {
                self.fetchTasksFromJSON { jsonTasks in
                    self.saveTasksToCoreData(jsonTasks) {
                        DispatchQueue.main.async {
                            self.tasks = jsonTasks
                            completion(self.tasks)
                        }
                    }
                }
            }
        }
    }

    private func fetchTasksFromJSON(completion: @escaping ([Task]) -> Void) {
        print("fetchTasksFromJSON")
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            print("Invalid URL")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("API Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            guard let data = data else {
                print("No data received from API")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            do {
                let response = try JSONDecoder().decode(TaskResponse.self, from: data)
                print("Fetched tasks from JSON: \(response.todos.count) tasks")
                DispatchQueue.main.async {
                    completion(response.todos)
                }
            } catch {
                print("JSON Parsing Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }

    private func saveTasksToCoreData(_ tasks: [Task], completion: @escaping () -> Void) {
        print("saveTasksToCoreData")
        let backgroundContext = CoreDataManager.shared.persistentContainer.newBackgroundContext()

        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskEntity.fetchRequest() as! NSFetchRequest<NSFetchRequestResult>
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try backgroundContext.execute(deleteRequest)
                print("Old tasks deleted successfully.")
            } catch {
                print("Failed to delete old tasks: \(error)")
            }

            for task in tasks {
                let entity = TaskEntity(context: backgroundContext)
                entity.id = Int64(task.id)
                entity.title = task.title
                entity.isCompleted = task.isCompleted
                entity.taskDescription = task.taskDescription
                entity.creationDate = task.creationDate
            }

            do {
                try backgroundContext.save()
                print("Successfully saved tasks")
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Failed to save tasks to CoreData: \(error)")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }

    private func fetchTasksFromCoreData(completion: @escaping ([Task]) -> Void) {
        print("fetchTasksFromCoreData function")
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            let tasks = entities.map { Task(entity: $0) }
            completion(tasks)
        } catch {
            print("Failed to fetch tasks from CoreData: \(error)")
            completion([])
        }
    }

    
    func saveTask(_ task: Task, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.tasks.append(task)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func deleteTask(_ task: Task, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.tasks.removeAll { $0.id == task.id }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func updateTask(_ updatedTask: Task, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let index = self.tasks.firstIndex(where: { $0.id == updatedTask.id }) {
                self.tasks[index] = updatedTask
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func searchTasks(query: String, completion: @escaping ([Task]) -> Void) {
        DispatchQueue.main.async {
            if query.isEmpty {
                completion(self.tasks)
            } else {
                let filteredTasks = self.tasks.filter { $0.title.lowercased().contains(query.lowercased()) }
                completion(filteredTasks)
            }
        }
    }
}
