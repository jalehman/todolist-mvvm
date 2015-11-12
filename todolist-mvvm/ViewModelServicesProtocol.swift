//
//  CoreProtocols.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/6/15.
//  Copyright © 2015 JL. All rights reserved.
//

import Foundation

protocol ViewModelServicesDelegate: class {
    func services(services: ViewModelServicesProtocol, navigate: NavigationEvent)
}

protocol ViewModelServicesProtocol {
    
    var todo: TodoServiceProtocol { get }
    var date: DateServiceProtocol { get }
    
    func push(viewModel: ViewModelProtocol)
    func pop(viewModel: ViewModelProtocol)
}