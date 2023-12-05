//
//  BarcodeScannerView.swift
//  Barcode-scanner-sean
//
//  Created by iMuse on 23/10/2023.
//

import SwiftUI



struct BarcodeScannerView: View {
    
    @State private var scannedCode = ""
    @State private var alertItem: AlertItem?
    
    var body: some View {
        NavigationView {
            VStack {
                ScannerView(scannedCode: $scannedCode, alertItem: $alertItem)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                Spacer()
                    .frame(height: 50)
                
                Label("Scan Barcode", systemImage: "barcode.viewfinder")
                    .font(.title)
                
                Text(scannedCode.isEmpty ? "Not yet scanned" : scannedCode)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(scannedCode.isEmpty ? .red : .green)
                    .padding()
                
            }.navigationTitle("Barcode Scanner")
                .alert(item: $alertItem) { item in
                    Alert(title: Text(item.title),
                          message: Text(item.message),
                          dismissButton: item.dismissButton)
                }
                
        }
    }
}

struct BarcodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
    }
}
