//
//  TaskListView.swift
//  todo
//
//  Created by USER on 20.11.2024.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var presenter: TaskListPresenter
    @State private var searchQuery = ""
    @State private var newTask: Task? = nil
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color(UIColor.secondarySystemBackground).ignoresSafeArea()
                VStack {
                    List {
                        ForEach(presenter.tasks.indices, id: \.self) { index in
                            HStack {
                                TaskCompletionButton(task: $presenter.tasks[index], presenter: presenter)
                                
                                NavigationLink(value: NavigationRoute.taskDetail(presenter.tasks[index])) {
                                    VStack(alignment: .leading) {
                                        Text(presenter.tasks[index].title)
                                            .strikethrough(presenter.tasks[index].isCompleted)
                                        Text(presenter.formatShortDate(date: presenter.tasks[index].creationDate))
                                            .fontWeight(.light)
                                            .font(.caption)
                                    }
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        presenter.deleteTask(presenter.tasks[index])
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Задачи")
                    .searchable(text: $presenter.searchQuery)
                    .onChange(of: presenter.searchQuery) {
                        presenter.searchTasks(query: presenter.searchQuery)
                    }
                    Button(action: {
                        let newId = (presenter.tasks.max(by: { $0.id < $1.id })?.id ?? 0) + 1
                        let newTask = Task(id: newId, title: "Новая задача", isCompleted: false, taskDescription: "")
                        self.newTask = newTask
                        presenter.addTask(newTask)
                        navigationPath.append(NavigationRoute.taskDetail(newTask))
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.title)
                            .padding(.leading,200)
                            .foregroundStyle(.yellow)
                            .shadow(radius: 0.2)
                    }
                }
                .navigationDestination(for: NavigationRoute.self) { route in
                    switch route {
                    case .taskDetail(let task):
                        if let taskIndex = presenter.tasks.firstIndex(where: { $0.id == task.id }) {
                            TaskDetailView(
                                task: $presenter.tasks[taskIndex],
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
}

//struct TaskListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let interactor = TaskListInteractor()
//        let presenter = TaskListPresenter(interactor: interactor)
//        return TaskListView(presenter: presenter)
//    }
//}
