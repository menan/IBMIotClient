//
//  ViewController.swift
//  IBMIoTClientExample
//
//  Created by Menan Vadivel on 2019-04-02.
//  Copyright © 2019 Tinrit Labs Inc. All rights reserved.
//

import UIKit
import IBMIoTClient

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        IBMIoTClient.apiKey = "a-axloj7-f2voz6prqr"
        IBMIoTClient.appToken = ")IT9D0ubrRP7DI90NO"
        IBMIoTClient.orgId = "axloj7"
        
        
//        IBMIoTClient.shared.getDevices(typeId: "hub") { (res) in
//            if let results = res as? ResultsData {
//                print("Get devices results", results.results)
//            }
//            else {
//                print("Error occured while getting all hubs")
//            }
//        }
//
//
//        var deviceData = DeviceData()
//        deviceData.typeId = "hub"
//        deviceData.deviceId = "239874sas"
//
//        IBMIoTClient.shared.getDevice(device: deviceData) { (res) in
//            if let device = res as? DeviceData {
//                print("Fetched Device Data", device)
//            }
//            else {
//                print("Error occured while fetching device data \(deviceData.deviceId!)", res!)
//            }
//        }
//
//        IBMIoTClient.shared.deleteDevice(device: deviceData) { (res) in
//            print("Device \(deviceData.deviceId!) delete response", res!)
//        }
//
//
//        var loadDeviceData = DeviceData()
//        loadDeviceData.typeId = "hub"
//        loadDeviceData.deviceId = "807d3ac552b0"
//
//        IBMIoTClient.shared.getDevices(device: loadDeviceData) { (res) in
//            print("Fetched Devices for \(loadDeviceData.deviceId!): ", res!)
//        }
        
        var newDevice = DeviceData()
        newDevice.typeId = "sensor"
        newDevice.deviceId = "3c71bf6c2d60"
        
        print("Getting device state...")
        IBMIoTClient.shared.getDeviceState(device: newDevice, withStateId: "5cb577f7ecbfc5002863bd25") { (res) in
            print("Got device state.")
            switch res {
            case .failure(let err):
                print("Failure: \(err.localizedDescription)")
            case .success(let deviceState):
                print("Success: \(deviceState)")
            }
            
        }
        
        
//        newDevice.metadata = Metadata()
//        newDevice.metadata?.armed = true
//        newDevice.metadata?.pir = true
//        newDevice.metadata?.co = true
//        newDevice.metadata?.fire = true
//        newDevice.metadata?.mic = true
//        newDevice.metadata?.scream = true
//
//        newDevice.metadata?.name = "Menans Hub"
//        newDevice.deviceInfo = DeviceInfoData()
//        newDevice.deviceInfo?.serialNumber = "OWL-123"
//        newDevice.deviceInfo?.manufacturer = "Owl Home Inc."
//        newDevice.deviceInfo?.model = "Hub"
//        newDevice.deviceInfo?.description = "Owl Hub"
//        newDevice.deviceInfo?.descriptiveLocation = "Menans Hub"
//
//        IBMIoTClient.shared.updateDevice(device: newDevice) { (res) in
//
//            if let device = res as? DeviceData {
//                print("Added Device Data", device)
//            }
//            else {
//                print("Error occured while Adding device data \(newDevice.deviceId!)", res!)
//            }
//        }
//
        
    }


}

