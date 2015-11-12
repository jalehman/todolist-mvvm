//
//  TodoTableViewCell.swift
//  todolist-mvvm
//
//  Created by Josh Lehman on 11/6/15.
//  Copyright © 2015 JL. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Rex
import SnapKit

class TodoTableViewCell: ReactiveTableViewCell<TodoCellViewModel> {
    
    // MARK: Properties
    
    let noteLabel = UILabel()
    let dueDateLabel = UILabel()
    
    private var didSetupConstraints = false
    
    // MARK: API
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        contentView.addSubview(noteLabel)
        
        dueDateLabel.font = UIFont.systemFontOfSize(12)
        contentView.addSubview(dueDateLabel)
        
        noteLabel.rex_text <~ vm_signal
            .map { $0.note }
            .skipRepeats()
            .observeOn(UIScheduler())
        
        func markCompleted(completed: Bool) {
            accessoryType = completed ? .Checkmark : .None
        }
        
        vm_signal
            .flatMap(.Latest) { $0.completed.producer }
            .skipRepeats()
            .observeOn(UIScheduler())
            .observeNext(markCompleted)
        
        dueDateLabel.rex_text <~ vm_signal
            .map { $0.dueDateText }
            .skipRepeats()
            .observeOn(UIScheduler())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func reuseIdentifier() -> String {
        return "com.jl.TodoTableViewCell"
    }
    
    // MARK: UITableViewCell
    
    override func updateConstraints() {
        super.updateConstraints()
        if !didSetupConstraints {
            
            noteLabel.snp_makeConstraints { [weak self] make in
                make.left.equalTo(self!.contentView.snp_left).offset(8)
                make.top.equalTo(self!.contentView.snp_top).offset(8)
                make.right.equalTo(self!.contentView.snp_right).offset(-16)
                //make.right.equalTo(self!.accessoryView)
                //make.right.equalTo(self!.completedSwitch.snp_left).offset(-8)
            }
            
            dueDateLabel.snp_makeConstraints { make in
                make.left.right.equalTo(self.noteLabel)
                make.top.equalTo(self.noteLabel.snp_bottom).offset(4)
                make.bottom.equalTo(self.contentView).offset(-8)
            }
            
            didSetupConstraints = true
        }
    }
}
