//
//  Task.swift
//  todo
//
//  Created by USER on 20.11.2024.
//

import Foundation

struct Task: Decodable, Identifiable, Hashable, Encodable {
    let id: Int
    var title: String
    var isCompleted: Bool
    var taskDescription: String
    let creationDate: Date
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "todo"
        case isCompleted = "completed"
        case taskDescription = "description"
        case creationDate
    }

    init(id: Int, title: String, isCompleted: Bool, taskDescription: String) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.taskDescription = taskDescription
        self.creationDate = Date()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        taskDescription = try container.decodeIfPresent(String.self, forKey: .taskDescription) ?? ""
        creationDate = try container.decodeIfPresent(Date.self, forKey: .creationDate) ?? Date()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(taskDescription, forKey: .taskDescription)
        try container.encode(creationDate, forKey: .creationDate)
    }
}

