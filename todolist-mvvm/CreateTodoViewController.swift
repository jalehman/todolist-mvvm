//
//  CreateTodoViewController.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/9/15.
//  Copyright © 2015 JL. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SnapKit

class CreateTodoViewController: ReactiveViewController<CreateTodoViewModel> {
    
    // MARK: Properties
    
    let noteLabel = UILabel()
    let noteTextField = UITextField()
    
    let dueDateLabel = UILabel()
    let dueDatePicker = UIDatePicker()
    
    var saveButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    private var didSetupConstraints = false
    
    // MARK: API
    
    init(viewModel: CreateTodoViewModel) {
        super.init(viewModel: viewModel, nibName: nil, bundle: nil)
        
        // Bar buttons
        saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "save")
        cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        
        // Note
        noteLabel.text = "What do you have to do?"
        noteLabel.font = UIFont.boldSystemFontOfSize(16)
        
        noteTextField.backgroundColor = UIColor.whiteColor()
        noteTextField.borderStyle = .RoundedRect
        noteTextField.placeholder = "e.g. get more sleep"
        
        // Due date
        dueDateLabel.font = UIFont.boldSystemFontOfSize(16)
        
        dueDatePicker.date = viewModel.dueDate.value
        dueDatePicker.minimumDate = NSDate()
    }
    
    // MARK: UIViewController
    
    override func loadView() {
        super.loadView()
        view.addSubview(noteLabel)
        view.addSubview(noteTextField)
        view.addSubview(dueDateLabel)
        view.addSubview(dueDatePicker)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if !didSetupConstraints {
            
            noteLabel.snp_makeConstraints { [weak self] make in
                make.left.equalTo(self!.view).offset(8)
                make.top.equalTo(self!.view).offset(8)
            }

            noteTextField.snp_makeConstraints { [weak self] make in
                make.left.right.equalTo(self!.noteLabel)
                make.right.equalTo(self!.view).offset(-8)
                make.top.equalTo(self!.noteLabel.snp_bottom).offset(8)
            }
            
            dueDateLabel.snp_makeConstraints { [weak self] make in
                make.left.equalTo(self!.noteLabel)
                make.top.equalTo(self!.noteTextField.snp_bottom).offset(16)
            }
            
            dueDatePicker.snp_makeConstraints { [weak self] make in
                make.width.equalTo(self!.view)
                make.top.equalTo(self!.dueDateLabel.snp_bottom).offset(4)
            }
            
            didSetupConstraints = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None
        
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
        
        title = "New Todo"
        view.backgroundColor = UIColor.whiteColor()
        
        // MARK: Bindings
        
        // Enable "saveButton" iff viewModel's "create" action is enabled
        saveButton.rex_enabled <~ viewModel.create.enabled
        
        // Bind "noteTextField"'s text to the viewModel's "note" property
        viewModel.note <~ noteTextField.rex_text
        
        // bind "dueDatePicker"'s date to the ViewModel's "dueDate" property
        viewModel.dueDate <~ dueDatePicker.rex_controlEvents(.ValueChanged)
            .filter { $0 != nil }
            .map { (control: UIControl?) -> NSDate in
                return (control as! UIDatePicker).date
        }
        
        dueDateLabel.rex_text <~ viewModel.dueDateText.producer
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsUpdateConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        noteTextField.becomeFirstResponder()
    }
    
    // MARK: Actions
    
    func save() {
        viewModel.create
            .apply((note: viewModel.note.value, date: viewModel.dueDate.value))
            .start()
    }
    
    func cancel() {
        viewModel.cancel.apply().start()
    }
}