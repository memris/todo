//
//  TaskListView.swift
//  todo
//
//  Created by USER on 20.11.2024.
//

import SwiftUI

struct TaskListView: View {
    @StateObject var presenter: TaskListPresenter
    @State private var searchQuery = ""
    @State private var newTask: Task? = nil
    @State private var navigationPath = NavigationPath()
    
    var filteredTasks: [Task] {
        if searchQuery.isEmpty {
            return presenter.tasks
        } else {
            return presenter.tasks.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color(UIColor.secondarySystemBackground).ignoresSafeArea()
                VStack {
                    List(filteredTasks) { task in
                        NavigationLink(value: NavigationRoute.taskDetail(task)) {
                            Text(task.title)
                        }
                    }
                    .navigationTitle("Задачи")
                    .searchable(text: $searchQuery, prompt: "Найти")
                    
                    Button(action: {
                        let newId = (presenter.tasks.max(by: { $0.id < $1.id })?.id ?? 0) + 1
                        let newTask = Task(id: newId, title: "Новая задача", isCompleted: false, taskDescription: "")
                        presenter.addTask(newTask)
                        navigationPath.append(NavigationRoute.taskDetail(newTask))
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.title)
                            .padding(.leading,200)
                    }
                    
                }
                .navigationDestination(for: NavigationRoute.self) { route in
                    switch route {
                    case .taskDetail(let task):
                        TaskDetailView(
                            task: task,
                            presenter: presenter,
                            isNewTask: newTask != nil,
                            onSave: {
                                if let newTask {
                                    presenter.addTask(newTask)
                                    self.newTask = nil
                                }
                            }
                        )
                    }
                }
            }
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = TaskListInteractor()
        let presenter = TaskListPresenter(interactor: interactor)
        return TaskListView(presenter: presenter)
    }
}
