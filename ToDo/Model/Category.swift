//
//  Category.swift
//  ToDo
//
//  Created by Vasil Vasilev on 22.10.19.
//  Copyright © 2019 Vasil Vasilev. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var bgColor: String = ""
    let items = List<Item>()
}
