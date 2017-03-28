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
    
    var mainStorageRef: FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    var imagesStorageRef: FIRStorageReference {
        return mainStorageRef.child("images")
    }
    
    var videoStorageRef: FIRStorageReference {
        return mainStorageRef.child("videos")
    }
    
    func saveUser(uid: String) {
        let profile: Dictionary<String, AnyObject> = ["firstName" : "" as AnyObject,
                                                      "lastName" : "" as AnyObject]
        
        mainRef.child("users").child(uid).child("profile").setValue(profile)
    }
    
    func sendMediaPullRequest(senderUID: String, sendingTo: Dictionary<String, User>, mediaURL: URL, textSnipper: String? = nil) {
        
        var uids = [String]()
        for uid in sendingTo.keys {
            uids.append(uid)
        }
        
        let pr: Dictionary<String, AnyObject> =
            ["mediaURL" : mediaURL.absoluteString as AnyObject,
             "userID" : senderUID as AnyObject,
             "openCount" : 0 as AnyObject,
             "recipients" : uids as AnyObject]
        
        mainRef.child("pullRequests").childByAutoId().setValue(pr)
    }
    
    private static let _instance = DataService()
}
