//
//  ViewController.swift
//  TodoIOSApp
//
//  Created by Phatcharaphan Ananpreechakun on 7/22/18.
//  Copyright © 2018 Phatcharaphan Ananpreechakun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ItemDetailControllerDelegate {
    var todo = Todo()
    
    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.totalItem
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = todo.item(at: indexPath.row).title
        cell.accessoryType = todo.item(at: indexPath.row).isDone ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "openEditPage", sender: todo.item(at: indexPath.row))
    }

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

        controller.dismiss(animated: true, completion: nil)
    }

    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todo.add(item: TodoItem(title: "Angular"))
        todo.add(item: TodoItem(title: "React"))
        todo.add(item: TodoItem(title: "Vue", isDone: true))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openAddPage" {
            let navigationController = segue.destination as? UINavigationController
            let controller = navigationController?.topViewController as? ItemDetailViewController
            controller?.delegate = self
        } else if segue.identifier == "openEditPage" {
            let navigationController = segue.destination as? UINavigationController
            let controller = navigationController?.topViewController as? ItemDetailViewController
            controller?.todoItem = sender as? TodoItem
            controller?.delegate = self
        }
    }

}

