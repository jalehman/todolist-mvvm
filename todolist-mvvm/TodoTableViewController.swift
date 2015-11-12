//
//  TodoTableViewController.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/6/15.
//  Copyright © 2015 JL. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SnapKit

class TodoTableViewController: ReactiveViewController<TodoTableViewModel>, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    let todoTableView = UITableView(frame: CGRectZero, style: .Plain)
    var createTodoButton: UIBarButtonItem!
    var clearTodosButton: UIBarButtonItem!
    
    private var didSetupConstraints = false
    
    // MARK: API
    
    init(viewModel: TodoTableViewModel) {
        super.init(viewModel: viewModel, nibName: nil, bundle: nil)
        
        createTodoButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "createTodoButtonPressed")
        clearTodosButton = UIBarButtonItem(title: "Clear", style: .Plain, target: viewModel, action: "clearCompleted")
        
        todoTableView.estimatedRowHeight = 80
        todoTableView.rowHeight = UITableViewAutomaticDimension
        todoTableView.dataSource = self
        todoTableView.delegate = self
        todoTableView.registerClass(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.reuseIdentifier())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    
    override func loadView() {
        super.loadView()
        view.addSubview(todoTableView)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if !didSetupConstraints {
            
            todoTableView.snp_makeConstraints { make in
                make.edges.equalTo(self.view)
            }
            
            didSetupConstraints = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsUpdateConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todos"
        navigationItem.leftBarButtonItem = clearTodosButton
        navigationItem.rightBarButtonItem = createTodoButton
        
        func insertRow(indexPath: NSIndexPath) {
            todoTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
        }
        
        // Insert a row whenever a Todo is created.
        viewModel.presentCreateTodo.values
            .flatMap(.Latest) { vm in vm.create.values }
            .map { _ in NSIndexPath(forRow: 0, inSection: 0) }
            .observeOn(UIScheduler())
            .observeNext(insertRow)
        
        func removeRow(indexPath: NSIndexPath?) {
            todoTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Left)
        }
        
        // Remove a row whenever a Todo is deleted
        viewModel.deleteTodo.values
            .filter { $0 != nil }
            .observeOn(UIScheduler())
            .observeNext(removeRow)                
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todos.value.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let vm = viewModel.todos.value[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(TodoTableViewCell.reuseIdentifier()) as! ReactiveTableViewCell<TodoCellViewModel>
        
        cell.bindViewModel(vm)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let vm = viewModel.todos.value[indexPath.row]
            viewModel.deleteTodo.apply((todos: viewModel.todos.value, cell: vm))
                .startOn(QueueScheduler.backgroundQueueScheduler)
                .start()
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vm = viewModel.todos.value[indexPath.row]
        vm.completed.value = !vm.completed.value
    }
    
    // MARK: Actions
    
    func createTodoButtonPressed() {
        viewModel.presentCreateTodo.apply().start()
    }
        
}
