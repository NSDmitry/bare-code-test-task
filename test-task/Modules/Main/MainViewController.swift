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
}

extension MainViewController: QRCodeReaderDeleagte {
    func getQRCode(qrCode: String) {
        print(qrCode)
        
        let parameters: [String: Any] = [
            "text": qrCode,
            "region": ["0c5b2444-70a0-4932-980c-b4dc0d3f02b5", nil, nil]
        ]
        
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        let urlString = "https://catalog.napolke.ru/search/catalog"
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Неизвестная ошибка")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let json = responseJSON as? [String: Any] {
                print(json)
            }
        }
        
        task.resume()
    }
    
    func showError() {
        showAlert(at: .qrReaderError)
    }
}
