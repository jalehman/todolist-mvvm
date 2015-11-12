//
//  DateService.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/10/15.
//  Copyright © 2015 JL. All rights reserved.
//

import Foundation

protocol DateServiceProtocol {
    func format(date: NSDate) -> String
}

struct DateService: DateServiceProtocol {
    
    private let formatter = NSDateFormatter()
    
    init() {
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
    }
    
    func format(date: NSDate) -> String {
        return formatter.stringFromDate(date)
    }
}