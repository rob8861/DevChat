//
//  AuthService.swift
//  DevChat
//
//  Created by Rob Fazio on 3/25/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//

import FirebaseAuth

typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

class AuthService {
    
    static var instance: AuthService {
        return _instance
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    if errorCode == .errorCodeUserNotFound {
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            
                            if error != nil {
                                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                            } else {
                                if user?.uid != nil {
                                    
                                    DataService.instance.saveUser(uid: user!.uid)
                                    // Sign-in
                                    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                                        
                                        if error != nil {
                                            self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                                        } else {
                                            onComplete?(nil, user)
                                        }
                                    })
                                }
                            }
                        })
                    } else {
                        // handle all other errors
                        self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                    }
                } else {
                    // successfully logged in
                    onComplete?(nil, user)
                }
            }
        })
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        
        print(error.debugDescription)
        
        if let error = FIRAuthErrorCode(rawValue: error._code) {
            switch error {
            case .errorCodeInvalidEmail:
                onComplete?("Invalid email address", nil)
                break
            case .errorCodeWrongPassword:
                onComplete?("Invalid Password", nil)
                break
            case .errorCodeEmailAlreadyInUse, .errorCodeAccountExistsWithDifferentCredential:
                onComplete?("Could not create an account. Email already in use", nil)
                break
            default:
                onComplete?("There was a problem authenticating. Try again", nil)
            }
        }
    }
    
    
    private static let _instance = AuthService()
}
