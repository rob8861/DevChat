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
        
        
    }
    
    func videoRecordingFailed() {
        
        
    }
    
    func snapshotTaken(_ snapshotData: Data!) {
        
        
    }
    
    func snapshotFailed() {
        
        
    }
}
