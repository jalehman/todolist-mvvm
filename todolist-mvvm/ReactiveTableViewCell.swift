//
//  ReactiveTableViewCell.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/6/15.
//  Copyright © 2015 JL. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ReactiveTableViewCell<T: ViewModelProtocol>: UITableViewCell {
    
    var vm_signal: Signal<T, NoError> { return signal }
    
    private let (signal, observer) = Signal<T, NoError>.pipe()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel(viewModel: T) {
        observer.sendNext(viewModel)
        
        updateConstraintsIfNeeded()
        setNeedsLayout()
    }
    
    class func reuseIdentifier() -> String {
        return "com.jl.ReactiveTableViewCell"
    }
}