//
//  CodeReader.swift
//  test-task
//
//  Created by admin on 14/11/2018.
//  Copyright © 2018 nsdmitry. All rights reserved.
//

import Foundation
import AVFoundation

protocol CodeReaderProtocol {
    func startReading(completion: @escaping (String) -> Void)
    func stopReading()
    var videoPreview: CALayer { get }
}

class CodeReader: NSObject {
    fileprivate(set) var videoPreview = CALayer()
    
    fileprivate var captureSession: AVCaptureSession?
    fileprivate var didRead: ((String) -> Void)?
    
    override init() {
        super.init()
        
        guard let videoDevice = AVCaptureDevice.default(for: .video), let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
                return
        }

        captureSession = AVCaptureSession()
        captureSession?.addInput(deviceInput)

        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let captureVideoPreview = AVCaptureVideoPreviewLayer(session: captureSession!)
        captureVideoPreview.videoGravity = .resizeAspectFill
        self.videoPreview = captureVideoPreview
    }
}

extension CodeReader: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        guard let readableCode = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let code = readableCode.stringValue else {
                return
        }
        
        //Vibrate the phone
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        stopReading()
        
        didRead?(code)
    }
}

extension CodeReader: CodeReaderProtocol {
    func startReading(completion: @escaping (String) -> Void) {
        self.didRead = completion
        captureSession?.startRunning()
    }
    func stopReading() {
        captureSession?.stopRunning()
    }
}
