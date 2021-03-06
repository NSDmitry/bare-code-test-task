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
    
    private var video: AVCaptureVideoPreviewLayer?
    private var session: AVCaptureSession?
    private var frameView: UIView?
    
    func startRecording(in view: UIView) {
        let session = AVCaptureSession()
        self.session = session
        
        guard let captureDevice = AVCaptureDevice.default(for: .video), let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            delegate?.showError()
            return
        }
        
        session.addInput(input)

        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417, .code128, .code39]
        
        let video = AVCaptureVideoPreviewLayer(session: session)
        video.videoGravity = .resizeAspectFill
        video.connection?.videoOrientation = .portrait
        
        self.video = video
        
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)

        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
        
        addQRReaderFrame(view: view)
    }
    
    private func addQRReaderFrame(view: UIView) {
        let frameView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width - 60, height: 150))
        self.frameView = frameView
        frameView.center = view.center
        frameView.backgroundColor = .clear
        frameView.layer.borderColor = UIColor.white.cgColor
        frameView.layer.borderWidth = 3
        frameView.layer.cornerRadius = 6
        
        view.bringSubviewToFront(frameView)
        view.layer.addSublayer(frameView.layer)
    }
    
    func stopRecording() {
        session?.stopRunning()
        video?.removeFromSuperlayer()
        frameView?.removeFromSuperview()
        
        session = nil
        video = nil
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
        stopRecording()
    }
}
