//
//  Item.swift
//  Todoey
//
//  Created by 林宏諭 on 2021/5/23.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated:Date?
    @objc dynamic var backgroundColor: String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property:"items")
}
