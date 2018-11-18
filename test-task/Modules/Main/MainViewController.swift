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

    @IBAction func openCamera(_ sender: QRReadingButton) {
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
    
    private func downloadProductList(at QRCode: String) {
        productManager.getProduct(at: QRCode, success: { (productList) in
            if productList.products.isEmpty {
                // TODO: - show empty error
            } else {
                guard let firstProduct = productList.products.first else { return }
                DispatchQueue.main.async {
                    self.openProductDetail(firstProduct)
                }
            }
        }) { (error) in
            print(error ?? "неизвестная ошибка")
        }
    }
    
    private func openProductDetail(_ product: Product) {
        let productDetailViewController = ProductDetailViewController()
        productDetailViewController.product = product
        self.navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}

extension MainViewController: QRCodeReaderDeleagte {
    func getQRCode(qrCode: String) {
        downloadProductList(at: qrCode)
    }
    
    func showError() {
        showAlert(at: .qrReaderError)
    }
}
