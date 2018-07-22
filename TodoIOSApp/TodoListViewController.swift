//
//  ViewController.swift
//  TodoIOSApp
//
//  Created by Phatcharaphan Ananpreechakun on 7/22/18.
//  Copyright © 2018 Phatcharaphan Ananpreechakun. All rights reserved.
//

import UIKit

class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ItemDetailControllerDelegate, TodoItemTableViewCellDelegate, UITableViewDragDelegate, UITableViewDropDelegate {
    var todo = Todo()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.dropDelegate = self
        loadData()
    }

    func loadData() {
        do {
            let fileManager = FileManager.default
            var destinationURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            destinationURL.appendPathComponent("todo")
            destinationURL.appendPathExtension("plist")

            print(destinationURL.path)

            if fileManager.fileExists(atPath: destinationURL.path) {
                let data = try Data(contentsOf: destinationURL)
                let decoder = PropertyListDecoder()
                todo = try decoder.decode(Todo.self, from: data)
                tableView.reloadData()
            }
        } catch {
            print("cannot open file: \(error)")
        }
    }

    func saveData() {
        do {
            let fileManager = FileManager.default
            var destinationURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

            destinationURL.appendPathComponent("todo")
            destinationURL.appendPathExtension("plist")

            print(destinationURL.path)

            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml

            let data = try encoder.encode(todo)
            try data.write(to: destinationURL)
        } catch {
            print("cannot open file: \(error)")
        }
    }

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }

    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.localDragSession != nil
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
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

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        todo.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
        saveData()
    }

    //MARK - TableViewDelegate
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todo.remove(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveData()
        }
    }

    func itemDetailViewController(controller: ItemDetailViewController, didAdd item: TodoItem) {
        todo.add(item: item)
        if let index = todo.index(of: item) {
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            saveData()
        }
        
        controller.dismiss(animated: true, completion: nil)
    }

    func itemDetailViewController(controller: ItemDetailViewController, didEdit item: TodoItem) {
        if let index = todo.index(of: item) {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            saveData()
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
            saveData()
            todo.item(at: indexPath.row).toggleIsDone()
            tableView.reloadData()
        }
    }

    //MARK - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openAddPage" {
            let navigationController = segue.destination as? UINavigationController
            let con = navigationController?.topViewController as? ItemDetailViewController
            con?.delegate = self
        } else if segue.identifier == "openEditPage" {
            let con = segue.destination as? ItemDetailViewController
            con?.delegate = self
            con?.todoItem = sender as? TodoItem
        }
    }

}

