//
//  BLEView.swift
//  BluetoothScanner
//
//  Created by Engin Bolat on 31.01.2025.
//

import UIKit

let SPACE = 20.0

class BLEView: UIView, UITableViewDelegate, UITableViewDataSource {
    var devices: [BluetoothDevice] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Bluetooth Devices"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    func configure(devices: [BluetoothDevice]) {
        self.devices = devices
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        layout()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
        layout()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BluetoothDeviceCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension BLEView {
    private func layout() {
        self.addSubview(titleLabel)
        self.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: SPACE),
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: SPACE),
            titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -SPACE),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: SPACE),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension BLEView {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BluetoothDeviceCell
        cell.configure(with: devices[indexPath.row].name, device: devices[indexPath.row])
        return cell
    }
}

class BluetoothDeviceCell: UITableViewCell {
    var device: BluetoothDevice?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: SPACE),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -SPACE),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with text: String, device: BluetoothDevice) {
        titleLabel.text = text
        self.device = device
    }
}
