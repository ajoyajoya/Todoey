//
//  Items.swift
//  Todoey
//
//  Created by Aji Prastio Wibowo on 20/06/19.
//  Copyright © 2019 AJOYAJOYA. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var colorItemBackground: String = ""
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
