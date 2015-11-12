//
//  Array+Extensions.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/6/15.
//  Copyright © 2015 JL. All rights reserved.
//

import Foundation

// Treat an array as a stack.
extension Array {
    
    mutating func push(newElement: Element) {
        self.append(newElement)
    }
    
    mutating func append(newElements: [Element]?) {
        for e in newElements ?? [] {
            self.append(e)
        }
    }
    
    mutating func pop() -> Element? {
        return self.removeLast()
    }
    
    func peekAtStack() -> Element? {
        return self.last
    }
}