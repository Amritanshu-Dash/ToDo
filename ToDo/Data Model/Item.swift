//
//  Item.swift
//  ToDo
//
//  Created by Amritanshu Dash on 24/08/23.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //inverse relationship link each item back to its parent category.
}
