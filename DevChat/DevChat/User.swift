//
//  User.swift
//  DevChat
//
//  Created by Rob Fazio on 3/26/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//

import UIKit

struct User {
    
    var uid: String {
        return _uid
    }
    
    var firstName: String {
        return _firstName
    }
    
    
    init(uid: String, firstName: String) {
        _uid = uid
        _firstName = firstName
    }
    
    
    private var _firstName: String!
    private var _uid: String!
    
}
