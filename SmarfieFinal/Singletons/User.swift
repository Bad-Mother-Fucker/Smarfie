//
//  User.swift
//  Smarfie
//
//  Created by Michele De Sena on 20/02/2018.
//  Copyright © 2018 Michele De Sena. All rights reserved.
//

import Foundation

class User {
    static let shared = User()
    var bestSide:FaceSide = .right
    var username:String!
}
