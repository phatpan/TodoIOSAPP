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
    func addTodoViewControllerDidCancel(controller: AddTodoViewController)
}

class AddTodoViewController: UIViewController {
    weak var delegate: AddTodoViewControllerDelegate?

    @IBOutlet weak var isDoneSwitch: UISwitch!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelButtonDidtap(_ sender: UIBarButtonItem) {
        delegate?.addTodoViewControllerDidCancel(controller: self)
    }

    @IBAction func doneButtonDidtab() {
        if let title = titleTextField.text, !title.isEmpty {
            delegate?.addTodoViewController(controller: self, didAdd: TodoItem(title: title, isDone: isDoneSwitch.isOn))
        }
    }
}
