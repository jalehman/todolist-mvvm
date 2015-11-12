//
//  UIKit+Extensions.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/10/15.
//  Copyright © 2015 JL. All rights reserved.
//

import UIKit
import ReactiveCocoa

extension UITextField {
    var rex_text: SignalProducer<String, NoError> {
        return self.rac_textSignal().toSignalProducer()
            .map { $0 as? String ?? "" }
            .flatMapError { _ in SignalProducer<String, NoError>.empty }
    }
}