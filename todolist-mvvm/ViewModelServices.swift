//
//  ViewModelServices.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/6/15.
//  Copyright © 2015 JL. All rights reserved.
//

import Foundation

class ViewModelServices: NSObject, ViewModelServicesProtocol {
    
    // MARK: Properties
    
    let todo: TodoServiceProtocol
    let date: DateServiceProtocol
    
    private weak var delegate: ViewModelServicesDelegate?
    
    // MARK: API
    
    init(delegate: ViewModelServicesDelegate?) {
        self.delegate = delegate
        self.todo = TodoService()
        self.date = DateService()
        super.init()
    }
    
    func push(viewModel: ViewModelProtocol) {
        delegate?.services(self, navigate: NavigationEvent(viewModel))
    }
    
    func pop(viewModel: ViewModelProtocol) {
        delegate?.services(self, navigate: .Pop)
    }
    
}