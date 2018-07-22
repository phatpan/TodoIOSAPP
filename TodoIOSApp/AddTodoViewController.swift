//
//  AddTodoViewController.swift
//  TodoIOSApp
//
//  Created by Phatcharaphan Ananpreechakun on 7/22/18.
//  Copyright © 2018 Phatcharaphan Ananpreechakun. All rights reserved.
//

import UIKit
protocol AddTodoViewControllerDelegate: class {
    func addTodoViewController(controller: AddTodoViewController, didAdd item: TodoItem)
    func addTodoViewController(controller: AddTodoViewController, didEdit item: TodoItem)
    func addTodoViewControllerDidCancel(controller: AddTodoViewController)
}

class AddTodoViewController: UIViewController {
    weak var delegate: AddTodoViewControllerDelegate?
    var todoItem: TodoItem?
    @IBOutlet weak var isDoneSwitch: UISwitch!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = todoItem {
            titleTextField.text = item.title
            isDoneSwitch.isOn = item.isDone
            title = "Edit Item"
        } else {
            title = "Add New Item"
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         titleTextField.becomeFirstResponder()
    }

    @IBAction func cancelButtonDidtap(_ sender: UIBarButtonItem) {
        delegate?.addTodoViewControllerDidCancel(controller: self)
    }

    @IBAction func doneButtonDidtab() {
        if let title = titleTextField.text, let isDone = isDoneSwitch?.isOn, !title.isEmpty {
            if let item = todoItem {
                item.title = title
                item.isDone = isDone
                delegate?.addTodoViewController(controller: self, didEdit: item)
            } else {
                delegate?.addTodoViewController(controller: self, didAdd: TodoItem(title: title, isDone: isDone))
            }
        }
    }
}
