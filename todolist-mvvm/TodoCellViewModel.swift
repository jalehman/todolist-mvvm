//
//  TodoCellViewModel.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/6/15.
//  Copyright © 2015 JL. All rights reserved.
//

import Foundation
import ReactiveCocoa

class TodoCellViewModel: ViewModel {
    
    // MARK: Properties
    
    let note: String
    let dueDateText: String
    
    let completed: MutableProperty<Bool>
    
    var todo: Todo { return _todo.value }
    private var _todo: MutableProperty<Todo>
    
    // MARK: API
    
    init(services: ViewModelServicesProtocol, todo: Todo) {
        self._todo = MutableProperty(todo)
        self.note = todo.note
        self.dueDateText = "Due: \(services.date.format(todo.dueDate))"
        self.completed = MutableProperty(todo.completed)        
        
        super.init(services: services)
        
        _todo <~ completed.producer
            .skip(1) // skip the initial value
            .map(_todo.value.markAs) // transform
            .flatMap(.Latest, transform: services.todo.update) // update via service
    }
    
    
}