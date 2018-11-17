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

    private let qrCodeReader: QRCodeReaderProtocol = QRCodeReader()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestCameraAccess()
        qrCodeReader.delegate = self
    }

    @IBAction func openCamera(_ sender: UIButton) {
        guard checkCameraPermission() else {
            showCameraAccessAlert()
            return
        }
        
        qrCodeReader.startRecording(in: self.view)
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
    
    private func showQRReaderError() {
        let alert = UIAlertController(title: "Ошибка", message: "Ошибка чтения QR, попробуйте позже", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: QRCodeReaderDeleagte {
    func getQRCode(qrCode: String) {
        print(qrCode)
    }
    
    func showError() {
        showQRReaderError()
    }
}
