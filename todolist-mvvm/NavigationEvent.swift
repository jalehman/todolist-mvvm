//
//  NavigationEvent.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/11/15.
//  Copyright © 2015 JL. All rights reserved.
//

import Foundation

//
//  NavigationEvent.swift
//  Savvy
//
//  Created by Josh Lehman on 11/10/15.
//  Copyright © 2015 Section Technologies, Inc. All rights reserved.
//

import UIKit

enum NavigationEvent {
    
    enum PushStyle {
        case Push, Modal
    }
    
    case Push(UIViewController, PushStyle)
    case Pop
    
    init(_ viewModel: ViewModelProtocol) {
        
        if let vm = viewModel as? TodoTableViewModel {
            self = .Push(TodoTableViewController(viewModel: vm), .Push)
        } else if let vm = viewModel as? CreateTodoViewModel {
            self = .Push(CreateTodoViewController(viewModel: vm), .Modal)
        } else {
            self = .Push(UIViewController(), .Push)
        }
    }
    
}