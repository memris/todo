//
//  Task.swift
//  todo
//
//  Created by USER on 20.11.2024.
//


struct Task: Decodable, Identifiable {
    let id: Int
    var title: String
    var isCompleted: Bool
    
    private enum CodingKeys: String, CodingKey {
           case id
           case title = "todo"
           case isCompleted = "completed"
    }
}
