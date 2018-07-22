//
//  ViewController.swift
//  TodoIOSApp
//
//  Created by Phatcharaphan Ananpreechakun on 7/22/18.
//  Copyright © 2018 Phatcharaphan Ananpreechakun. All rights reserved.
//

import UIKit

class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ItemDetailControllerDelegate, TodoItemTableViewCellDelegate {
    var todo = Todo()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        todo.add(item: TodoItem(title: "Angular"))
        todo.add(item: TodoItem(title: "React"))
        todo.add(item: TodoItem(title: "Vue", isDone: true))
    }

    //MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.totalItem
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath) as! TodoItemTableViewCell
        let item = todo.item(at: indexPath.row)
        cell.titleLabel.text = item.title
        cell.delegate = self
        cell.checkboxButton.setImage(UIImage(named: item.isDone ? "check" : "uncheck"), for: .normal)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "openEditPage", sender: todo.item(at: indexPath.row))
    }

    //MARK - TableViewDelegate
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todo.remove(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func itemDetailViewController(controller: ItemDetailViewController, didAdd item: TodoItem) {
        todo.add(item: item)
        if let index = todo.index(of: item) {
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        
        controller.dismiss(animated: true, completion: nil)
    }

    func itemDetailViewController(controller: ItemDetailViewController, didEdit item: TodoItem) {
        if let index = todo.index(of: item) {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        navigationController?.popViewController(animated: true)
    }

    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        if controller.isInEditMode {
            navigationController?.popViewController(animated: true)
        } else {
             controller.dismiss(animated: true, completion: nil)
        }
    }

    func todoItemViewCellCheckboxButtonDidtap(cell: TodoItemTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            todo.item(at: indexPath.row).toggleIsDone()
            tableView.reloadData()
        }
    }

    //MARK - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openAddPage" {
            let con = segue.destination as? ItemDetailViewController
            con?.delegate = self
        } else if segue.identifier == "openEditPage" {
            let con = segue.destination as? ItemDetailViewController
            con?.delegate = self
            con?.todoItem = sender as? TodoItem
        }
    }

}

