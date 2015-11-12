//
//  TodoService.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/8/15.
//  Copyright © 2015 JL. All rights reserved.
//

import Foundation
import ReactiveCocoa

protocol TodoServiceProtocol {    
    func update(todo: Todo) -> SignalProducer<Todo, NoError>
    func delete(todo: Todo) -> SignalProducer<Bool, NoError>
    func create(note: String, dueDate: NSDate) -> SignalProducer<Todo, NoError>
}

class TodoService: NSObject, TodoServiceProtocol {
    
    func update(todo: Todo) -> SignalProducer<Todo, NoError> {
        return SignalProducer(value: todo)
    }
    
    func delete(todo: Todo) -> SignalProducer<Bool, NoError> {
        return SignalProducer(value: true)
    }
    
    func create(note: String, dueDate: NSDate) -> SignalProducer<Todo, NoError> {
        let id = randomInt(0, max: 1000000)
        let todo = Todo(id: id, note: note, completed: false, dueDate: dueDate)
        return SignalProducer(value: todo)
    }
}

// https://www.hackingwithswift.com/read/35/2/generating-random-numbers-in-ios-8-and-earlier
func randomInt(min: Int, max: Int) -> Int {
    if max < min { return min }
    return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
}