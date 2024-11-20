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
    
    var filteredTasks: [Task] {
        if searchQuery.isEmpty {
            return presenter.tasks
        } else {
            return presenter.tasks.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground).ignoresSafeArea()
            VStack {
                NavigationStack {
                    
                    List(filteredTasks) { task in
                        Text(task.title)
                    }
                    .onAppear {
                        presenter.loadTasks()
                    }
                    .navigationTitle("Задачи")
                    .searchable(text: $searchQuery, prompt: "Найти")
                }
                .padding(.bottom,20)
                Button { 
                    
                }
            label: {
                Image(systemName: "square.and.pencil")
            }
            .padding(.leading,200)
            .font(.title)
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
