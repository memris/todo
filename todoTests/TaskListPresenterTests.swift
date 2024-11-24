//
//  TaskListPresenterTests.swift
//  todoTests
//
//  Created by USER on 24.11.2024.
//

import XCTest
@testable import todo

class TaskListPresenterTests: XCTestCase {
    var presenter: TaskListPresenter!
    var mockInteractor: MockTaskListInteractor!

    override func setUp() {
        super.setUp()
        mockInteractor = MockTaskListInteractor()
        presenter = TaskListPresenter(interactor: mockInteractor)
    }

    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        super.tearDown()
    }

    func testAddTask() {
        let initialCount = presenter.tasks.count
        let newTask = Task(id: 1, title: "Test Task", isCompleted: false, taskDescription: "")

        presenter.addTask(newTask)

        XCTAssertEqual(presenter.tasks.count, initialCount + 1)
        XCTAssertEqual(presenter.tasks.last?.title, "Test Task")
        XCTAssertTrue(mockInteractor.saveTaskCalled)
    }
}


class MockTaskListInteractor: TaskListInteractor {
    var saveTaskCalled = false
    var tasksList: [Task] = []

    override func saveTask(_ task: Task, completion: @escaping () -> Void) {
        saveTaskCalled = true
        tasksList.append(task)
        completion()
    }

    override func fetchTasks(completion: @escaping ([Task]) -> Void) {
        completion(tasksList)
    }
}
