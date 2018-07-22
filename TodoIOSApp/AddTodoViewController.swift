//
//  AddTodoViewController.swift
//  TodoIOSApp
//
//  Created by Phatcharaphan Ananpreechakun on 7/22/18.
//  Copyright © 2018 Phatcharaphan Ananpreechakun. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelButtonDidtap(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func doneButtonDidtab() {
        dismiss(animated: true, completion: nil)
    }
}
