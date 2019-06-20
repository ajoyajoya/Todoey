//
//  Category.swift
//  Todoey
//
//  Created by Aji Prastio Wibowo on 20/06/19.
//  Copyright © 2019 AJOYAJOYA. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
