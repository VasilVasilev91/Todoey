//
//  Item.swift
//  ToDo
//
//  Created by Vasil Vasilev on 22.10.19.
//  Copyright © 2019 Vasil Vasilev. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
