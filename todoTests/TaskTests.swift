//
//  TaskTests.swift
//  todoTests
//
//  Created by USER on 24.11.2024.
//

import XCTest
@testable import todo

final class TaskTests: XCTestCase {
    func testTaskInitialization() {
        let task = Task(id: 1, title: "Test Task", isCompleted: false, taskDescription: "Test Description")

        XCTAssertEqual(task.id, 1)
        XCTAssertEqual(task.title, "Test Task")
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.taskDescription, "Test Description")
    }
}
