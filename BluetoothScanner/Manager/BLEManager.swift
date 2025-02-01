//
//  BLEManager.swift
//  BluetoothScanner
//
//  Created by Engin Bolat on 1.02.2025.
//

import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    
    var discoveredDevices: [BluetoothDevice] = []
    var connectedPeripheral: CBPeripheral?
    var isConnected = false

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let deviceName = peripheral.name, !deviceName.isEmpty else { return }
        if !discoveredDevices.contains(where: { $0.name == peripheral.name }) {
            let newDevice = BluetoothDevice(id: peripheral.identifier.uuidString, name: deviceName, peripheral: peripheral)
            DispatchQueue.main.async {
                self.discoveredDevices.append(newDevice)
                NotificationCenter.default.post(name: .bluetoothDevicesUpdated, object: nil)
            }
        }
    }

    func connectToPeripheral(_ peripheral: CBPeripheral) {
        if let connectedPeripheral = connectedPeripheral {
            if connectedPeripheral != peripheral {
                print("Önce mevcut cihazın bağlantısını kesiyoruz: \(connectedPeripheral.name ?? "Bilinmeyen Cihaz")")
                centralManager.cancelPeripheralConnection(connectedPeripheral)
            }
        }

        print("Yeni cihaza bağlanılıyor: \(peripheral.name ?? "Bilinmeyen Cihaz")")
        connectedPeripheral = peripheral
        connectedPeripheral?.delegate = self
        centralManager.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        DispatchQueue.main.async {
            self.isConnected = true
            self.connectedPeripheral = peripheral
            self.centralManager.stopScan()
            print("Bağlandı: \(peripheral.name ?? "Bilinmeyen Cihaz")")
        }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.async {
            self.isConnected = false
            self.connectedPeripheral = nil
            print("Bağlantı kesildi: \(peripheral.name ?? "Bilinmeyen Cihaz")")
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
}

extension Notification.Name {
    static let bluetoothDevicesUpdated = Notification.Name("bluetoothDevicesUpdated")
}
