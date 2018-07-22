//
//  Todo.swift
//  TodoIOSApp
//
//  Created by Phatcharaphan Ananpreechakun on 7/22/18.
//  Copyright © 2018 Phatcharaphan Ananpreechakun. All rights reserved.
//

import Foundation

class Todo:Codable {
    private var items = [TodoItem]()
    var totalItem: Int {
        return items.count
    }

    func add(item: TodoItem) {
        items.insert(item, at: 0)
    }

    func remove(index: Int){
        items.remove(at: index)
    }

    func item(at index: Int)  -> TodoItem {
        return items[index]
    }

    func index(of item: TodoItem) -> Int? {
        return items.index { $0 === item }
    }
}
