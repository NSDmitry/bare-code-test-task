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

    private var qrCodeReader: QRCodeReaderProtocol = QRCodeReader()
    private let productManager: ProductManagerProtocol = ProductManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestCameraAccess()
        qrCodeReader.delegate = self
    }

    @IBAction func openCamera(_ sender: UIButton) {
        guard checkCameraPermission() else {
            showAlert(at: .cameraAccess)
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
                self.showAlert(at: .cameraAccess)
            }
        }
    }
    
    private func showAlert(at type: ErrorAlertType) {
        self.present(type.alertController, animated: true, completion: nil)
    }
    
    private func openProductDetail(at QRCode: String) {
        productManager.getProduct(at: QRCode)
    }
}

extension MainViewController: QRCodeReaderDeleagte {
    func getQRCode(qrCode: String) {
        openProductDetail(at: qrCode)
    }
    
    func showError() {
        showAlert(at: .qrReaderError)
    }
}
