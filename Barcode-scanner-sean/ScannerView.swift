//
//  ScannerView.swift
//  Barcode-scanner-sean
//
//  Created by iMuse on 23/10/2023.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    @Binding var scannedCode: String
    @Binding var alertItem: AlertItem?
   
    
    func makeUIViewController(context: Context) -> CameraViewController {
        CameraViewController(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        
    }
    
    final class Coordinator: NSObject, ScannerVCDelegate {
        
        private let scannerView: ScannerView
        
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        func didFind(barcode: String) {
            scannerView.scannedCode = barcode
            print(barcode)
        }
        
        func didSurface(error: CameraError) {
            scannerView.scannedCode = error.rawValue
            switch error {
            case .invalidDeviceInput:
                scannerView.alertItem = AlertContext.invalideDeviceInput
            case .invalidScannedValue:
                scannerView.alertItem = AlertContext.invalidScan
            }
            print(error.rawValue)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self)
    }
    
}


