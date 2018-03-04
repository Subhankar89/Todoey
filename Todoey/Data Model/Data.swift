//
//  Data.swift
//  Todoey
//
//  Created by Subhankar Acharya on 04/03/18.
//  Copyright © 2018 Subhankar. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
