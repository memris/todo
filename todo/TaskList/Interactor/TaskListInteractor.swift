//
//  TaskListInteractor.swift
//  todo
//
//  Created by USER on 20.11.2024.
//

import SwiftUI

class TaskListInteractor {
    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: "https://dummyjson.com/todos")!
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("API Error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(self.getMockTasks())
                    }
                    return
                }
                
                guard let data = data else {
                    print("No data received from API")
                    DispatchQueue.main.async {
                        completion(self.getMockTasks())
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
                        completion(self.getMockTasks())
                    }
                }
            }.resume()
        }
    }
    
    private func getMockTasks() -> [Task] {
        return [
            Task(id: 1, title: "Buy groceries", isCompleted: false),
            Task(id: 2, title: "Walk the dog", isCompleted: true),
            Task(id: 3, title: "Finish project", isCompleted: false)
        ]
    }
}
