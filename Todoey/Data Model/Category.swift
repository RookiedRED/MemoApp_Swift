//
//  Category.swift
//  Todoey
//
//  Created by 林宏諭 on 2021/5/23.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class  Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundColor: String = ""
    let items = List<Item>()
}
