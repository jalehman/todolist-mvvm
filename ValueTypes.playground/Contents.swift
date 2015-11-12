//: Playground - noun: a place where people can play

import UIKit

class Rectangle {
    var height: Int
    var width: Int
    
    init(height: Int, width: Int) {
        self.height = height
        self.width = width
    }
}

struct ValueRectangle {
    var height: Int
    var width: Int
    
    init(height: Int, width: Int) {
        self.height = height
        self.width = width
    }

    func scale(by: Int) -> ValueRectangle {
        return ValueRectangle(height: height * by, width: width * by)
    }
}


