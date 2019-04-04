# IBMIotClient for  devices

## Overview
IBM IoT Watson Swift Client for managing devices

## Installation

### Carthage
- Add `github "menan/IBMIotClient" "master"` to your Cartfile
- Run `carthage update --platform ios` on Terminal to update your Carthage libraries
- Link **BIMIoTClient** framework to your project from Carthage/Build/iOS/IBMIotClient.framework
- Add `$(SRCROOT)/Carthage/Build/iOS/IBMIotClient.framework` to your projects *Build Phases* under *Carthage Copy Frameworks*.


## Supported Platforms
- iOS
- watchOS
- tvOS
- macOS

## Compatibility
Built with Swift 5 with Xcode 10.2

## Usage

### Import
Import IBMIoTClient to your swift file.
```swift 
import IBMIoTClient
```

### Setup
Set your credentials.
```swift
IBMIoTClient.apiKey = "" //Your IBM Watson IoT API Key
IBMIoTClient.appToken = "" //Your IBM Watson IoT App Token
IBMIoTClient.orgId = "" //Your IBM Watson IoT Organization ID
```

### Get Devices
Fetch all devices of type **hub**
```swift
IBMIoTClient.shared.getDevices(typeId: "hub") { (res) in
    if let results = res as? ResultsData {
        print("Get devices results", results.results)
    }
    else {
        print("Error occured while getting all hubs")
    }
}
```

### Get Device Info
Get a specific device's info

```swift
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
```

### Delete Device
Delete a device
```swift
var deviceData = DeviceData()
deviceData.typeId = "hub"
deviceData.deviceId = "239874sas"

IBMIoTClient.shared.deleteDevice(device: deviceData) { (res) in
    print("Device \(deviceData.deviceId!) delete response", res!)
}
```

### Add Device
Add a new device
```swift

var newDevice = DeviceData()
newDevice.typeId = "hub"
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
```
