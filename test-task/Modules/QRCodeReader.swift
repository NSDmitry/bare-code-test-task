//
//  QRCodeReader.swift
//  test-task
//
//  Created by Dmitry Serov on 16/11/2018.
//  Copyright © 2018 nsdmitry. All rights reserved.
//

import AVFoundation
import UIKit

protocol QRCodeReaderDeleagte: class {
    func getQRCode(qrCode: String)
    func showError()
}

protocol QRCodeReaderProtocol {
    var delegate: QRCodeReaderDeleagte? { get set }
    
    func startRecording(in view: UIView)
    func stopRecording()
}

class QRCodeReader: NSObject, QRCodeReaderProtocol {
    var delegate: QRCodeReaderDeleagte?
    
    private var video = AVCaptureVideoPreviewLayer()
    private let session = AVCaptureSession()
    
    func startRecording(in view: UIView) {
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            delegate?.showError()
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417, .code128, .code39]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        session.startRunning()
    }
    
    func stopRecording() {
        session.stopRunning()
        video.removeFromSuperlayer()
    }
}

extension QRCodeReader: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard !metadataObjects.isEmpty,
            let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let qrCode = object.stringValue else {
                return
        }

        print(object.type)
        delegate?.getQRCode(qrCode: qrCode)
        session.stopRunning()
        video.removeFromSuperlayer()
    }
}
