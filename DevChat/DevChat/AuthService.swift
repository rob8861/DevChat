//
//  AuthService.swift
//  DevChat
//
//  Created by Rob Fazio on 3/25/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//

import FirebaseAuth

class AuthService {
    
    static var instance: AuthService {
        return _instance
    }
    
    func login(email: String, password: String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    if errorCode == .errorCodeUserNotFound {
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            
                            if error != nil {
                                // show error to user
                            } else {
                                if user?.uid != nil {
                                    // Sign-in
                                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                                        
                                        if error != nil {
                                            // show error to user
                                        } else {
                                            // successfully logged in
                                        }
                                    })
                                }
                            }
                        })
                    } else {
                        // handle all other errors
                    }
                } else {
                    // successfully logged in
                }
            }
        })
    }
    
    
    private static let _instance = AuthService()
}
