//
//  ViewModelProtocol.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/11/15.
//  Copyright © 2015 JL. All rights reserved.
//

import Foundation

protocol ViewModelProtocol {
    var services: ViewModelServicesProtocol { get }
}