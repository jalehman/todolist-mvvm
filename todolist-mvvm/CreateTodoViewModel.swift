//
//  CreateTodoViewModel.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/9/15.
//  Copyright © 2015 JL. All rights reserved.
//

import Foundation
import ReactiveCocoa

class CreateTodoViewModel: ViewModel {
    
    // MARK: Properties
    
    let note = MutableProperty<String>("")
    
    let dueDateText = MutableProperty<String>("")
    let dueDate: MutableProperty<NSDate>
    
    let cancel: Action<(), (), NoError>
    let create: Action<(note: String, date: NSDate), Todo, NoError>
    
    // MARK: API
    
    override init(services: ViewModelServicesProtocol) {
        // an hour from now
        self.dueDate = MutableProperty(NSDate().dateByAddingTimeInterval(60 * 60))
        
        let createEnabled = MutableProperty(false)

        self.create = Action(enabledIf: createEnabled) { (note: String, due: NSDate) -> SignalProducer<Todo, NoError> in
            return services.todo.create(note, dueDate: due)
        }
        
        self.cancel = Action { () -> SignalProducer<(), NoError> in
            return SignalProducer(value: ())
        }
        
        super.init(services: services)
        
        // Only enabled when there's a value in the note
        createEnabled <~ note.producer
            .map { note -> Bool in
                return note.characters.count > 0
        }
        
        dueDateText <~ dueDate.producer
            .map { date -> String in
                return "Due at: \(services.date.format(date))"
        }
    }
}