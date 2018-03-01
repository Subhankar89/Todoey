//
//  Item.swift
//  Todoey
//
//  Created by Subhankar Acharya on 28/02/18.
//  Copyright © 2018 Subhankar. All rights reserved.
//

import Foundation

class Item: Codable //Encodable,Decodable
{
    var title : String = ""
    var done : Bool = false
}
