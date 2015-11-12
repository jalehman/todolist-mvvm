//
//  TodoListViewModel.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/6/15.
//  Copyright © 2015 JL. All rights reserved.
//

import Foundation
import ReactiveCocoa

class TodoTableViewModel: ViewModel {
    
    // MARK: Properties
    
    let todos = MutableProperty<[TodoCellViewModel]>([])
    
    let presentCreateTodo: Action<(), CreateTodoViewModel, NoError>
    let deleteTodo: Action<(todos: [TodoCellViewModel], cell: TodoCellViewModel), NSIndexPath?, NoError>
    
    // MARK: API
    
    override init(services: ViewModelServicesProtocol) {
        
        self.presentCreateTodo = Action { () -> SignalProducer<CreateTodoViewModel, NoError> in
            return SignalProducer(value: CreateTodoViewModel(services: services))
        }
        
        self.deleteTodo = Action { (todos: [TodoCellViewModel], cell: TodoCellViewModel) -> SignalProducer<NSIndexPath?, NoError> in
            let deleteIndex = todos.indexOf { x -> Bool in
                return x.todo == cell.todo
            }
            
            if let idx = deleteIndex {
                return services.todo.delete(cell.todo)
                    .map { _ in NSIndexPath(forRow: idx, inSection: 0) }
            }
            
            return SignalProducer(value: nil)
        }
        
        let createdTodoSignal = presentCreateTodo.values
            .flatMap(.Latest) { (vm: CreateTodoViewModel) -> Signal<Todo, NoError> in
                return vm.create.values
        }
        
        // When "presentCreateTodo" sends a value, push the resulting ViewModel
        presentCreateTodo.values.observeNext(services.push)
        
        // When "cancel" sends a value from inside CreateTodoViewModel, pop
        presentCreateTodo.values
            .flatMap(.Latest) { vm in vm.cancel.values.map { _ in vm } }
            .observeNext(services.pop)
        
        // When "create" sends a value from inside CreateTodoViewModel, pop
        presentCreateTodo.values
            .flatMap(.Latest) { vm in vm.create.values.map { _ in vm } }
            .observeNext(services.pop)
        
        super.init(services: services)
        
        func prependTodo(todo: Todo) -> [TodoCellViewModel] {
            let new = TodoCellViewModel(services: services, todo: todo)
            var tmp = todos.value
            tmp.insert(new, atIndex: 0)
            return tmp
        }
        
        // Whenever a todo is created, create a new viewmodel for it, prepend it to the latest array of todos, and bind the result to todos
        todos <~ createdTodoSignal.map(prependTodo)
        
        func removeTodo(at: NSIndexPath?) -> [TodoCellViewModel] {
            var tmp = todos.value
            tmp.removeAtIndex(at!.row)
            return tmp
        }
        
        // Whenever a todo is deleted, remove it from the backing array
        todos <~ deleteTodo.values.filter { $0 != nil }.map(removeTodo)
    }
    
    func clearCompleted() {
        for todo in todos.value {
            if todo.completed.value {
                deleteTodo.apply((todos: todos.value, cell: todo)).start()
            }
        }
    }
}