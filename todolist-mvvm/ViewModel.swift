//
//  ViewModel.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/6/15.
//  Copyright © 2015 JL. All rights reserved.
//

import Foundation

class ViewModel: NSObject, ViewModelProtocol {
    
    let services: ViewModelServicesProtocol
    
    init(services: ViewModelServicesProtocol) {
        self.services = services
        super.init()
    }
}