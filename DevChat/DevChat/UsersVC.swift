//
//  UsersVC.swift
//  DevChat
//
//  Created by Rob Fazio on 3/26/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pullRequestBtn: UIButton!
    
    
    var users = [User]()
    var selectedUsers = Dictionary<String, User>()
    
    var snapData: Data {
        set {
            _snapData = newValue
        }
        get {
            return _snapData!
        }
    }
    
    var videoURL: URL {
        set {
            _videoURL = newValue
        }
        get {
            return _videoURL!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
        pullRequestBtn.isEnabled = false
        
        DataService.instance.usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let users = snapshot.value as? Dictionary<String, AnyObject> {
                
                for (key, value) in users {
                    
                    if let dict = value as? Dictionary<String, AnyObject> {
                        
                        if let profile = dict["profile"] as? Dictionary<String, AnyObject> {
                            
                            if let firstName = profile["firstName"] as? String {
                                
                                let uid = key
                                let user = User(uid: uid, firstName: firstName)
                                self.users.append(user)
                            }
                        }
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        pullRequestBtn.isEnabled = true
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: true)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: false)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = nil
        
        if selectedUsers.count <= 0 {
            pullRequestBtn.isEnabled = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        cell.updateUI(user: user)
        return cell
    }
    
    @IBAction func sendPRBtnPressed(_ sender: UIButton) {
        
        if let url = _videoURL {
            
            let videoName = "\(NSUUID().uuidString)\(url)"
            let ref = DataService.instance.videoStorageRef.child(videoName)
            
            _ = ref.putFile(url, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Error uploading video: \(error?.localizedDescription)")
                } else {
                    let downloadURL  = metadata!.downloadURL()
                    DataService.instance.sendMediaPullRequest(senderUID: FIRAuth.auth()!.currentUser!.uid, sendingTo: self.selectedUsers, mediaURL: downloadURL!, textSnipper: "Coding today was LEGIT")
                    
                }
            })
            self.dismiss(animated: true, completion: nil)
        } else if let snap = _snapData {
            
            let ref = DataService.instance.imagesStorageRef.child("\(NSUUID().uuidString).jpg")
            
            _ = ref.put(snap, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Error uploading snapshot: \(error?.localizedDescription)")
                } else {
                    
                    let downloadURL = metadata?.downloadURL()
                    DataService.instance.sendMediaPullRequest(senderUID: FIRAuth.auth()!.currentUser!.uid, sendingTo: self.selectedUsers, mediaURL: downloadURL!)
                }
            })
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private var _snapData: Data?
    private var _videoURL: URL?
}
