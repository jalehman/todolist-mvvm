//
//  QueueScheduler+Extensions.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/12/15.
//  Copyright © 2015 JL. All rights reserved.
//

import Foundation
import ReactiveCocoa

var GlobalBackgroundQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
}

extension QueueScheduler {        
    class var backgroundQueueScheduler: QueueScheduler {
        get {
            return QueueScheduler(queue: GlobalBackgroundQueue)
        }
    }
}