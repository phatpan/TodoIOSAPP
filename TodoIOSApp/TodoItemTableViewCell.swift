//
//  TodoItemTableViewCell.swift
//  TodoIOSApp
//
//  Created by Phatcharaphan Ananpreechakun on 7/22/18.
//  Copyright © 2018 Phatcharaphan Ananpreechakun. All rights reserved.
//

import UIKit

protocol  TodoItemTableViewCellDelegate: class{
    func todoItemViewCellCheckboxButtonDidtap(cell: TodoItemTableViewCell)
}
class TodoItemTableViewCell: UITableViewCell {
    weak var delegate: TodoItemTableViewCellDelegate?
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    @IBAction func checkboxDidtap(_ sender: Any) {
        delegate?.todoItemViewCellCheckboxButtonDidtap(cell: self)
    }
}
