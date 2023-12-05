//
//  Alert.swift
//  Barcode-scanner-sean
//
//  Created by iMuse on 24/10/2023.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalideDeviceInput = AlertItem(title: "Invalid device input",
                                               message: "Somtehing wognjare",
                                               dismissButton: .default(Text("OKAY")))
    
    static let invalidScan = AlertItem(title: "Invalid Scan",
                                               message: "Somtehing wognjare",
                                               dismissButton: .default(Text("OKAY")))
}
