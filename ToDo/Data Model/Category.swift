//
//  Category.swift
//  ToDo
//
//  Created by Amritanshu Dash on 24/08/23.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>() // relation between category and item..........
}
