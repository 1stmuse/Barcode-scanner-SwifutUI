//
//  CameraViewController.swift
//  Barcode-scanner-sean
//
//  Created by iMuse on 23/10/2023.
//

import Foundation
import AVFoundation
import UIKit

enum CameraError: String {
    case invalidDeviceInput     = "Something is wrong woth camera"
    case invalidScannedValue    = "This app scans only ean varcode type"
}



protocol ScannerVCDelegate: class {
    func didFind(barcode: String)
    func didSurface(error: CameraError)
}

final class CameraViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var scannerDelegate: ScannerVCDelegate!
    
    init(scannerDelegate: ScannerVCDelegate){
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let previewLayer = previewLayer else {
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
        }catch {
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        }
        
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        }else {
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let metadataOutout = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutout){
            captureSession.addOutput(metadataOutout)
            metadataOutout.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutout.metadataObjectTypes = [.ean8, .ean13]
        }else {
            scannerDelegate.didSurface(error: .invalidDeviceInput)
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        
        captureSession.startRunning()
        
    }
    
}

extension CameraViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            scannerDelegate.didSurface(error: .invalidScannedValue)
            return
        }
        
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate.didSurface(error: .invalidScannedValue)
            return
        }
        
        guard let barcode = machineReadableObject.stringValue else {
            scannerDelegate.didSurface(error: .invalidScannedValue)
            return
        }
        
        scannerDelegate.didFind(barcode: barcode)
    }
}
