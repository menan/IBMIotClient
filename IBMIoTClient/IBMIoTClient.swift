//
//  IBMIoTClient.swift
//  IBMIoTClient
//
//  Created by Vadivelpillai, menan on 4/2/19.
//  Copyright © 2019 Tinrit Labs Inc. All rights reserved.
//

import UIKit

public class IBMIoTClient {

    public static let shared = IBMIoTClient()
    
    public static var orgId = ""
    public static var apiKey = ""
    public static var appToken = ""
    
    static var endPoint: String {
        return "https://\(IBMIoTClient.orgId).internetofthings.ibmcloud.com/api/v0002"
    }
    
    var header: String? {
        let credentialData = "\(IBMIoTClient.apiKey):\(IBMIoTClient.appToken)".data(using: .utf8)
        guard let cred = credentialData else { return nil }
        return cred.base64EncodedString()
    }
    
    var session: URLSession {
        let config = URLSessionConfiguration.default
        if let header = header {
            config.httpAdditionalHeaders = ["Authorization": "Basic \(header)", "Content-Type" : "application/json"]
        }
        
        return URLSession(configuration: config)
    }
    
    
    public func getDevices(typeId: String, completionHandler: @escaping (Any?) -> Void) {
        guard let devicesURL = URL(string: "\(IBMIoTClient.endPoint)/device/types/\(typeId)/devices") else { return }
        print("URL", devicesURL)
        
        let request = NSMutableURLRequest(url: devicesURL)
        request.httpMethod = "GET"
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else { return }
            
            do {
                let deviceData = try JSONDecoder().decode(ResultsData.self, from: data)
                completionHandler(deviceData)
            } catch let err {
                print("Err", err.localizedDescription)
                
                let jsonString = String(data: data, encoding: .utf8)
                print("Get Devices Error: " + jsonString!)
                
                
                completionHandler(err)
            }
        }.resume()
    }
    
    public func getDevice(device: DeviceData, completionHandler: @escaping (Any?) -> Void) {
        guard let typeId = device.typeId else { return }
        guard let deviceId = device.deviceId else { return }
        guard let devicesURL = URL(string: "\(IBMIoTClient.endPoint)/device/types/\(typeId)/devices/\(deviceId)") else { return }
        print("URL", devicesURL)
        
        let request = NSMutableURLRequest(url: devicesURL)
        request.httpMethod = "GET"
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else { return }
            do {
                let deviceData = try JSONDecoder().decode(DeviceData.self, from: data)
                completionHandler(deviceData)
            } catch let err {
                print("Err", err.localizedDescription)
                guard let res = response as? HTTPURLResponse else { return completionHandler(err) }
                completionHandler(res.statusCode)
            }
            }.resume()
    }
    
    
    public func deleteDevice(device: DeviceData, completionHandler: @escaping (Any?) -> Void) {
        guard let typeId = device.typeId else { return }
        guard let deviceId = device.deviceId else { return }
        guard let devicesURL = URL(string: "\(IBMIoTClient.endPoint)/device/types/\(typeId)/devices/\(deviceId)") else { return }
        print("URL", devicesURL)
        
        let request = NSMutableURLRequest(url: devicesURL)
        request.httpMethod = "DELETE"
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let res = response as? HTTPURLResponse else { return completionHandler(error) }
            completionHandler(res.statusCode)
            }.resume()
    }
    
    public func updateDevice(device: DeviceData, completionHandler: @escaping (Any?) -> Void) {
        guard let typeId = device.typeId else { return }
        guard let deviceId = device.deviceId else { return }
        guard let devicesURL = URL(string: "\(IBMIoTClient.endPoint)/device/types/\(typeId)/devices/\(deviceId)") else { return }
        print("URL", devicesURL)
        
        let request = NSMutableURLRequest(url: devicesURL)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(device)
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else { return }
            do {
                let deviceData = try JSONDecoder().decode(DeviceData.self, from: data)
                completionHandler(deviceData)
            } catch let err {
                print("Err", err.localizedDescription)
                completionHandler(err)
            }
            }.resume()
    }
    
    public func addDevice( device: inout DeviceData, completionHandler: @escaping (Any?) -> Void) {
        guard let typeId = device.typeId else { return }
        guard let devicesURL = URL(string: "\(IBMIoTClient.endPoint)/device/types/\(typeId)/devices") else { return }
        print("URL", devicesURL)
        
        let request = NSMutableURLRequest(url: devicesURL)
        request.httpMethod = "POST"
        
        let jsonEncoder = JSONEncoder()
        do {
            device.typeId = nil
            let jsonData = try jsonEncoder.encode(device)
            request.httpBody = jsonData
        }
        catch let err {
            print("Error parsing data \(err.localizedDescription)")
        }
        
        
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let res = response as? HTTPURLResponse else { return }
            
            guard let data = data else { return }
            if res.statusCode != 201 {
                let jsonString = String(data: data, encoding: .utf8)
                print("Add Device Error: " + jsonString!)
                return completionHandler(res.statusCode)
            }
            do {
                let deviceData = try JSONDecoder().decode(DeviceData.self, from: data)
                completionHandler(deviceData)
            } catch let err {
                print("Err", err.localizedDescription)
                completionHandler(err)
            }
            }.resume()
    }
}




public struct ResultsData: Codable {
    public var results: [DeviceData]
}

public struct DeviceData: Codable {
    public init() {}
    public var clientId: String?
    public var authToken: String?
    public var typeId: String?
    public var deviceId: String?
    public var deviceInfo: DeviceInfoData?
    public var metadata: Metadata?
}

public struct DeviceInfoData: Codable {
    public init() {}
    public var serialNumber: String?
    public var manufacturer: String?
    public var model: String?
    public var deviceClass: String?
    public var description : String?
    public var fwVersion: String?
    public var hwVersion: String?
    public var descriptiveLocation: String?
}

public struct Metadata: Codable {
    public init() {}
    public var name: String?
    public var armed: Bool?
    public var fire: Bool?
    public var co: Bool?
    public var pir: Bool?
    public var mic: Bool?
    public var scream: Bool?
}
