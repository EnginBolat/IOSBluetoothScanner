//
//  BluetoothDevice.swift
//  BluetoothScanner
//
//  Created by Engin Bolat on 1.02.2025.
//

import CoreBluetooth

struct BluetoothDevice: Identifiable {
    let id: String
    let name: String
    let peripheral: CBPeripheral
}
