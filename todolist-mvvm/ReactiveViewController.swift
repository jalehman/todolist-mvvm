//
//  ReactiveViewController.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/6/15.
//  Copyright © 2015 JL. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ReactiveViewController<T: ViewModelProtocol>: UIViewController {
    
    // MARK: Properties    
    
    let viewModel: T
    
    // MARK: API
    
    init(viewModel: T, nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(viewModel: T) {
        self.init(viewModel: viewModel, nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}