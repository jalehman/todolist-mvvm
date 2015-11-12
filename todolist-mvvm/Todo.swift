//
//  Todo.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/6/15.
//  Copyright © 2015 JL. All rights reserved.
//

import Foundation

struct Todo: Equatable {
    
    // MARK: Properties
    
    let id: Int
    let note: String
    let createdAt: NSDate
    let dueDate: NSDate
    let completed: Bool
    
    // MARK: API
    
    init(id: Int, note: String, completed: Bool, dueDate: NSDate, createdAt: NSDate = NSDate()) {
        self.id = id
        self.note = note
        self.completed = completed
        self.createdAt = createdAt
        self.dueDate = dueDate
    }

    func markAs(completed: Bool) -> Todo {
        return Todo(id: id, note: note, completed: completed, dueDate: dueDate, createdAt: createdAt)
    }
}

func ==(lhs: Todo, rhs: Todo) -> Bool {
    return lhs.id == rhs.id && lhs.note == rhs.note && lhs.createdAt == rhs.createdAt && lhs.completed == rhs.completed && lhs.dueDate == rhs.dueDate
}