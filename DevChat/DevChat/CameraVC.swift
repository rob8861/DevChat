//
//  CameraVC.swift
//  DevChat
//
//  Created by Rob Fazio on 3/25/17.
//  Copyright © 2017 Rob Fazio. All rights reserved.
//

import UIKit
import FirebaseAuth

class CameraVC: AAPLCameraViewController, AAPLCameraVCDelegate {

    @IBOutlet weak var previewView: AAPLPreviewView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    
    override func viewDidLoad() {
        
        delegate = self
        _previewView = previewView
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard FIRAuth.auth()?.currentUser != nil else {
            // load login vc
            performSegue(withIdentifier: "loginVC", sender: nil)
            return
        }
        
        
    }

    @IBAction func recordBtnPressed(_ sender: Any) {
        toggleMovieRecording()
    }

    @IBAction func changeCameraBtnPressed(_ sender: Any) {
        changeCamera()
    }
    
    // MARK: APPLCameraVCDelegate implementation
    
    func shouldEnableCameraUI(_ enable: Bool) {
        
       cameraBtn.isEnabled = enable
    }
    
    func shouldEnableRecordUI(_ enable: Bool) {
        
        recordBtn.isEnabled = enable
    }
    
    func recordingHasStarted() {
        
        
    }
    
    func canStartRecording() {
        
        
    }
    
    func videoRecordingComplete(_ videoURL: URL!) {
        
        performSegue(withIdentifier: "UsersVC", sender: ["videoURL" : videoURL])
    }
    
    func videoRecordingFailed() {
        
        
    }
    
    func snapshotTaken(_ snapshotData: Data!) {
        
        performSegue(withIdentifier: "UsersVC", sender: ["snapshotData" : snapshotData])
    }
    
    func snapshotFailed() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let userVC = segue.destination as? UsersVC {
            
            if let videoDict = sender as? Dictionary<String, URL> {
                
                let url = videoDict["videoURL"]
                userVC.videoURL = url!
            } else if let snapDict = sender as? Dictionary<String, Data> {
                
                let snapData = snapDict["snapshotData"]
                userVC.snapData = snapData!
            }
        }
    }
}

