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
    
    private var video = AVCaptureVideoPreviewLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestCameraAccess()
    }

    @IBAction func openCamera(_ sender: UIButton) {
        guard checkCameraPermission() else {
            showCameraAccessAlert()
            return
        }
        
        startRecordingQR()
    }
    
    private func startRecordingQR() {
        let session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            print("error")
            // TODO: - add alert for error capture
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        session.startRunning()
    }
    
    private func checkCameraPermission() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized
    }
    
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { (access) in
            if !access {
                self.showCameraAccessAlert()
            }
        }
    }
    
    private func showCameraAccessAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Разрешите приложению доступ к камере в настройках приложения", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: AVCaptureMetadataOutputObjectsDelegate {
    
}
