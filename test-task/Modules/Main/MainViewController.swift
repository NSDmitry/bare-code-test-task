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

    @IBOutlet private weak var qrReadingView: UIView!
    @IBOutlet private weak var descriptionView: UIView!
    @IBOutlet private weak var qrReadingButton: QRReadingButton!
    @IBOutlet weak var qrCodeFrame: UIView!
    
    private var qrCodeReader: QRCodeReaderProtocol = QRCodeReader()
    private let productManager: ProductManagerProtocol = ProductManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestCameraAccess()
        qrCodeReader.delegate = self
        self.descriptionView.alpha = 0
        
        qrCodeFrame.layer.borderColor = UIColor.white.cgColor
        qrCodeFrame.layer.borderWidth = 3
        qrCodeFrame.layer.cornerRadius = 3
        
        view.bringSubviewToFront(qrCodeFrame)
    }

    @IBAction func openCamera(_ sender: QRReadingButton) {
        sender.isReading.toggle()

        if sender.isReading {
            guard checkCameraPermission() else {
                self.present(ErrorAlertFactory.cameraAccess.alert, animated: true, completion: nil)
                return
            }
            
            qrCodeReader.startRecording(in: self.qrReadingView)
            description(isHidden: false)
        } else {
            qrCodeReader.stopRecording()
            description(isHidden: true)
        }
    }
    
    private func description(isHidden: Bool) {
        let alpha: CGFloat = isHidden ? 0 : 1
        UIView.animate(withDuration: 0.5, animations: {
            self.descriptionView.alpha = alpha
        })
    }
    
    private func checkCameraPermission() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized
    }
    
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { (access) in
            if !access {
                self.present(ErrorAlertFactory.cameraAccess.alert, animated: true, completion: nil)
            }
        }
    }
    
    private func downloadProductList(at QRCode: String) {
        productManager.getProduct(at: QRCode, success: { (productList) in
            if productList.products.isEmpty {
                self.present(ErrorAlertFactory.productNonFound.alert, animated: true, completion: nil)
            } else {
                guard let firstProduct = productList.products.first else { return }
                DispatchQueue.main.async {
                    self.openProductDetail(firstProduct)
                }
            }
        }) { (error) in
            self.present(ErrorAlertFactory.unknowError.alert, animated: true, completion: nil)
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
        description(isHidden: true)
        qrReadingButton.isReading = false
    }
    
    func showError() {
        self.present(ErrorAlertFactory.qrReaderError.alert, animated: true, completion: nil)
    }
}
