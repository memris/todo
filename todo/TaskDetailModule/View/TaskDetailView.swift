//
//  TaskDetailView.swift
//  todo
//
//  Created by USER on 20.11.2024.
//

import SwiftUI

struct TaskDetailView: View {
    @Binding var task: Task
    @ObservedObject var presenter: TaskListPresenter
    var isNewTask: Bool = false
    var onSave: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Заголовок задачи")
                .font(.headline)
            TextField("Введите заголовок", text: $task.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onTapGesture {
                    clearTitleIfNew()
                }
            Text(presenter.formatShortDate(date: task.creationDate))
                .fontWeight(.light)
                .font(.caption)
            Text("Описание задачи")
                .font(.headline)
            TextField("Введите описание", text: $task.taskDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            Spacer()
        }
        .padding()
        .navigationTitle(task.title.isEmpty ? "Новая задача" : task.title)
    }

        private func saveTaskChanges() {
            if isNewTask {
                onSave?()
            } else {
                CoreDataManager.shared.saveContext()
            }
        }
        private func clearTitleIfNew() {
            if isNewTask && task.title == "Новая задача" {
                task.title = ""
            }
        }
    }
