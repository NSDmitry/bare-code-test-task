//
//  MainViewController.swift
//  test-task
//
//  Created by admin on 14/11/2018.
//  Copyright © 2018 nsdmitry. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestCameraAccess()
    }

    @IBAction func openCamera(_ sender: UIButton) {
        guard checkCameraPermission() else {
            // TODO: - show camera desctiption alert
            return
        }
    }
    
    private func checkCameraPermission() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized
    }
    
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { (access) in
            print("camera access: - \(access)")
            // TODO: - show camera desctiption alert
        }
    }
}
