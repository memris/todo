//
//  TaskListInteractor.swift
//  todo
//
//  Created by USER on 20.11.2024.
//

import SwiftUI

class TaskListInteractor {
    private var tasks: [Task] = []

    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            print("invalid URL")
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
}
