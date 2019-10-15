//
//  ViewController.swift
//  CarController
//
//  Created by Samuel Behrens on 10/14/19.
//  Copyright © 2019 Samuel Behrens. All rights reserved.
//

import UIKit
import CoreBluetooth

let serviceCBUUID = CBUUID(string: "b848f29a-7089-407c-8d73-22461900c71d")
let characteristicCBUUID = CBUUID(string: "4b55ae61-a529-4b2c-85f9-82c7401db550")

class ViewController: UIViewController {
    
    @IBOutlet weak var speedLabel: UILabel!
    
    var centralManager: CBCentralManager!
    var carPeripheral: CBPeripheral!
    var speedCharacteristic: CBCharacteristic!
    
    var leftSpeed: Int = 0
    var rightSpeed: Int = 0
    var speedChange: Int = 100

    override func viewDidLoad() {
        super.viewDidLoad()

        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func onNotificationReceived(_ value: Int) {
        speedLabel.text = String(value)
        print("Value received: \(value)")
    }
    
    func sendSpeed() {
        var leftSpeedString = String(leftSpeed)
        var rightSpeedString = String(rightSpeed)
        
        leftSpeedString = leftSpeedString.padding(toLength: 4, withPad: " ", startingAt: 0)
        rightSpeedString = rightSpeedString.padding(toLength: 4, withPad: " ", startingAt: 0)
        
        print(leftSpeedString)
        print(rightSpeedString)
        
        writeData(data: "\(leftSpeedString)\(rightSpeedString)".data(using: .utf8)!)
    }
    
    @IBAction func onLeftForwardPress(_ sender: Any) {
        leftSpeed += speedChange
        sendSpeed()
    }
    @IBAction func onLeftForwardTouchUpInside(_ sender: Any) {
        leftSpeed -= speedChange
        sendSpeed()
    }
    @IBAction func onLeftForwardTouchUpOutside(_ sender: Any) {
        leftSpeed -= speedChange
        sendSpeed()
    }
    
    @IBAction func onLeftBackPress(_ sender: Any) {
        leftSpeed -= speedChange
        sendSpeed()
    }
    @IBAction func onLeftBackTouchUpInside(_ sender: Any) {
        leftSpeed += speedChange
        sendSpeed()
    }
    @IBAction func onLeftBackTouchUpOutside(_ sender: Any) {
        leftSpeed += speedChange
        sendSpeed()
    }
    
    @IBAction func onRightForwardPress(_ sender: Any) {
        rightSpeed += speedChange
        sendSpeed()
    }
    @IBAction func onRightForwardTouchUpInside(_ sender: Any) {
        rightSpeed -= speedChange
        sendSpeed()
    }
    @IBAction func onRightForwardTouchUpOutside(_ sender: Any) {
        rightSpeed -= speedChange
        sendSpeed()
    }
    
    @IBAction func onRightBackPress(_ sender: Any) {
        rightSpeed -= speedChange
        sendSpeed()
    }
    @IBAction func onRightBackTouchUpInside(_ sender: Any) {
        rightSpeed += speedChange
        sendSpeed()
    }
    @IBAction func onRightBackTouchUpOutside(_ sender: Any) {
        rightSpeed += speedChange
        sendSpeed()
    }
}

extension ViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: [serviceCBUUID])
        default:
            print("default case")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                      advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        carPeripheral = peripheral
        carPeripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(carPeripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        carPeripheral.discoverServices([serviceCBUUID])
    }
}

extension ViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            print(characteristic)

            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case characteristicCBUUID:
            let characteristicValue = getCharacteristicValue(from: characteristic)
            onNotificationReceived(characteristicValue)
            speedCharacteristic = characteristic
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
  
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        if error != nil {
            print("Problem writing data")
            print(error!)
        }
        else {
            print("Wrote data \(String(describing: descriptor.characteristic.value))")
        }
    }
  
    func writeData(data: Data) {
        if speedCharacteristic == nil {
            print("No speed characteristic found")
            return
        }

        carPeripheral.writeValue(data, for: speedCharacteristic, type: CBCharacteristicWriteType.withResponse)
    }

    private func getCharacteristicValue(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return -1 }
        let byteArray = [UInt8](characteristicData)
        print("Characteristic value: \(byteArray)")
    
        return Int(byteArray[0])
    }
}