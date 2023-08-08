//
//  Item.swift
//  ToDo
//
//  Created by Amritanshu Dash on 08/08/23.
//

import Foundation

class Item: Encodable, Decodable{
    
    var title: String = ""
    var done: Bool = false
}
