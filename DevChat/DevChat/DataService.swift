//
//  DataService.swift
//  DevChat
//
//  Created by Rob Fazio on 3/26/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//

import Firebase

class DataService {
    
    static var instance: DataService {
        return _instance
    }
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var usersRef: FIRDatabaseReference {
        return mainRef.child("users")
    }
    
    func saveUser(uid: String) {
        let profile: Dictionary<String, AnyObject> = ["firstName" : "" as AnyObject,
                                                      "lastName" : "" as AnyObject]
        
        mainRef.child("users").child(uid).child("profile").setValue(profile)
    }
    
    private static let _instance = DataService()
}
