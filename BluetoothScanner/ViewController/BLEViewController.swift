//
//  ViewController.swift
//  BluetoothScanner
//
//  Created by Engin Bolat on 31.01.2025.
//

import UIKit

class BLEViewController: UIViewController {
    let bleManager = BLEManager()
    var bleView = BLEView()
    
    override func viewDidLoad() {
         super.viewDidLoad()
         layout()
         print(bleManager.discoveredDevices.count)
         bleView.configure(devices: bleManager.discoveredDevices)
         NotificationCenter.default.addObserver(self, selector: #selector(updateDeviceList), name: .bluetoothDevicesUpdated, object: nil)
     }

     @objc private func updateDeviceList() {
         DispatchQueue.main.async {
             self.bleView.configure(devices: self.bleManager.discoveredDevices)
             self.bleView.tableView.reloadData()
         }
     }
}

extension BLEViewController {
    private func layout() {
        bleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bleView)
        NSLayoutConstraint.activate([
            bleView.topAnchor.constraint(equalTo: view.topAnchor),
            bleView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
