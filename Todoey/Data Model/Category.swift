//
//  Category.swift
//  Todoey
//
//  Created by Subhankar Acharya on 05/03/18.
//  Copyright © 2018 Subhankar. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object { //Subclassing...Object is a Realm object
    @objc dynamic var name : String = ""
    let items = List<Item>() //this defines the forward realtionship
}

