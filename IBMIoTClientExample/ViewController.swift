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
        
        IBMIoTClient.apiKey = ""
        IBMIoTClient.appToken = ""
        IBMIoTClient.orgId = ""
        
        
        IBMIoTClient.shared.getDevices(typeId: "hub") { (res) in
            if let results = res as? ResultsData {
                print("Get devices results", results.results)
            }
            else {
                print("Error occured while getting all hubs")
            }
        }
        
        
        var deviceData = DeviceData()
        deviceData.typeId = "hub"
        deviceData.deviceId = "239874sas"
        
        IBMIoTClient.shared.getDevice(device: deviceData) { (res) in
            if let device = res as? DeviceData {
                print("Fetched Device Data", device)
            }
            else {
                print("Error occured while fetching device data \(deviceData.deviceId!)", res!)
            }
        }
        
        IBMIoTClient.shared.deleteDevice(device: deviceData) { (res) in
            print("Device \(deviceData.deviceId!) delete response", res!)
        }
        
        
        var newDevice = DeviceData()
        newDevice.typeId = "hub"
//        newDevice.authToken = "menna"
        newDevice.deviceId = "239874sasas"
        newDevice.metadata = Metadata()
        newDevice.metadata?.armed = true
        newDevice.metadata?.pir = true
        newDevice.metadata?.co = true
        newDevice.metadata?.fire = true
        newDevice.metadata?.mic = true
        newDevice.metadata?.scream = true
        
        newDevice.metadata?.name = "Menan's Hub"
        newDevice.deviceInfo = DeviceInfoData()
        newDevice.deviceInfo?.serialNumber = "OWL-123"
        newDevice.deviceInfo?.manufacturer = "Owl Home Inc."
        newDevice.deviceInfo?.model = "Hub"
        newDevice.deviceInfo?.description = "Owl Hub"
        newDevice.deviceInfo?.descriptiveLocation = "Menan's Hub"
        
        IBMIoTClient.shared.addDevice(device: &newDevice) { (res) in
            
            if let device = res as? DeviceData {
                print("Added Device Data", device)
            }
            else {
                print("Error occured while Adding device data \(newDevice.deviceId!)", res!)
            }
        }
        
        
    }


}

