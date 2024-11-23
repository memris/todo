//
//  TaskCompletionButton.swift
//  todo
//
//  Created by USER on 23.11.2024.
//

import SwiftUI

struct TaskCompletionButton: View {
    @Binding var task: Task
    let presenter: TaskListPresenter
    
    var body: some View {
        Button(action: {
        }) {
            Circle()
                .stroke(task.isCompleted ? .yellow : .gray, lineWidth: 2)
                .frame(width: 20, height: 20)
                .overlay(
                    task.isCompleted ? Image(systemName: "checkmark").font(.caption).foregroundColor(.yellow) : nil
                )
                .opacity(0.8)
        }
    }
}

