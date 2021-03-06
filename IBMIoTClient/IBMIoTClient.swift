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
    
    public static var orgId = "" // your organization id
    public static var apiKey = "" // IBM Watson IoT api key
    public static var appToken = "" // IBM Watson IoT app token
    
    static var endPoint: String {
        return "https://\(IBMIoTClient.orgId).internetofthings.ibmcloud.com/api/v0002"
    }
    static var msgEndPoint: String {
        return "https://\(IBMIoTClient.orgId).messaging.internetofthings.ibmcloud.com/api/v0002"
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
    
    public enum NetworkError: Error {
        case badURL
        case noResponse
        case failed
        case devicedAlreadyExist
    }
    
    
    // MARK: - Device Operations
    public func getDevices(forType typeId: String, completionHandler: @escaping (Result<ResultsData, Error>) -> Void) {
        guard let devicesURL = URL(string: "\(IBMIoTClient.endPoint)/device/types/\(typeId)/devices") else { return completionHandler(.failure(NetworkError.badURL)) }
        
        let request = NSMutableURLRequest(url: devicesURL)
        request.httpMethod = "GET"
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error { return completionHandler(.failure(error)) }
            guard let data = data else { return completionHandler(.failure(NetworkError.noResponse)) }
            
            do {
                let deviceData = try JSONDecoder().decode(ResultsData.self, from: data)
                return completionHandler(.success(deviceData))
            } catch let err {
                return completionHandler(.failure(err))
            }
        }.resume()
    }
    
    
    public func getDevices(forDevice device: DeviceData, completionHandler: @escaping (Result<ResultsData, Error>) -> Void) {
        guard let typeId = device.typeId else { return }
        guard let deviceId = device.deviceId else { return }
        guard let devicesURL = URL(string: "\(IBMIoTClient.endPoint)/device/types/\(typeId)/devices/\(deviceId)/devices")  else { return completionHandler(.failure(NetworkError.badURL)) }
        
        let request = NSMutableURLRequest(url: devicesURL)
        request.httpMethod = "GET"
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error { return completionHandler(.failure(error)) }
            guard let data = data else { return completionHandler(.failure(NetworkError.noResponse)) }
            
            do {
                let deviceData = try JSONDecoder().decode(ResultsData.self, from: data)
                completionHandler(.success(deviceData))
            } catch let err {
                return completionHandler(.failure(err))
            }
        }.resume()
    }
    
    public func getDevice(device: DeviceData, completionHandler: @escaping (Result<DeviceData, Error>) -> Void) {
        guard let typeId = device.typeId else { return }
        guard let deviceId = device.deviceId else { return }
        guard let devicesURL = URL(string: "\(IBMIoTClient.endPoint)/device/types/\(typeId)/devices/\(deviceId)")  else { return completionHandler(.failure(NetworkError.badURL)) }
        
        let request = NSMutableURLRequest(url: devicesURL)
        request.httpMethod = "GET"
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error { return completionHandler(.failure(error)) }
            guard let data = data else { return completionHandler(.failure(NetworkError.noResponse)) }
            
            do {
                let deviceData = try JSONDecoder().decode(DeviceData.self, from: data)
                completionHandler(.success(deviceData))
            } catch let err {
                completionHandler(.failure(err))
            }
        }.resume()
    }
    
    
    public func deleteDevice(device: DeviceData, completionHandler: @escaping (Result<Int, Error>) -> Void) {
        guard let typeId = device.typeId else { return }
        guard let deviceId = device.deviceId else { return }
        guard let devicesURL = URL(string: "\(IBMIoTClient.endPoint)/device/types/\(typeId)/devices/\(deviceId)")  else { return completionHandler(.failure(NetworkError.badURL)) }
        
        let request = NSMutableURLRequest(url: devicesURL)
        request.httpMethod = "DELETE"
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error { return completionHandler(.failure(error)) }
            guard let res = response as? HTTPURLResponse else { return completionHandler(.failure(NetworkError.noResponse)) }
            return completionHandler(.success(res.statusCode))
        }.resume()
    }
    
    public func updateDevice(device: DeviceData, completionHandler: @escaping (Result<DeviceData, Error>) -> Void) {
        guard let typeId = device.typeId else { return }
        guard let deviceId = device.deviceId else { return }
        guard let devicesURL = URL(string: "\(IBMIoTClient.endPoint)/device/types/\(typeId)/devices/\(deviceId)")  else { return completionHandler(.failure(NetworkError.badURL)) }
        
        var updateDevice = device
        updateDevice.typeId = nil
        updateDevice.deviceId = nil
        updateDevice.clientId = nil
        
        let request = NSMutableURLRequest(url: devicesURL)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(updateDevice)
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error { return completionHandler(.failure(error)) }
            guard let data = data else { return completionHandler(.failure(NetworkError.noResponse)) }
            do {
                let deviceData = try JSONDecoder().decode(DeviceData.self, from: data)
                completionHandler(.success(deviceData))
            } catch let err {
                completionHandler(.failure(err))
            }
        }.resume()
    }
    
    public func addDevice( device: inout DeviceData, completionHandler: @escaping (Result<DeviceData, Error>) -> Void) {
        guard let typeId = device.typeId else { return }
        guard let devicesURL = URL(string: "\(IBMIoTClient.endPoint)/device/types/\(typeId)/devices")  else { return completionHandler(.failure(NetworkError.badURL)) }
        let request = NSMutableURLRequest(url: devicesURL)
        request.httpMethod = "POST"
        let jsonEncoder = JSONEncoder()
        do {
            device.typeId = nil
            let jsonData = try jsonEncoder.encode(device)
            request.httpBody = jsonData
        }
        catch let err {
            completionHandler(.failure(err))
        }
        
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error { return completionHandler(.failure(error)) }
            guard let res = response as? HTTPURLResponse else { return completionHandler(.failure(NetworkError.noResponse))}
            if res.statusCode == 200 || res.statusCode == 201 {
                guard let data = data else { return completionHandler(.failure(NetworkError.noResponse))}
                do {
                    let deviceData = try JSONDecoder().decode(DeviceData.self, from: data)
                    completionHandler(.success(deviceData))
                } catch let err {
                    completionHandler(.failure(err))
                }
            }
            else {
                completionHandler(.failure(NetworkError.devicedAlreadyExist))
            }
        }.resume()
    }
    
    
    // MARK: - Device Mesaging
    
    public func publish(device: DeviceData, eventName: String, message: Message, completionHandler: @escaping (Result<Int,Error>) -> Void) {
        guard let typeId = device.typeId else { return }
        guard let deviceId = device.deviceId else { return }
        guard let devicesURL = URL(string: "\(IBMIoTClient.msgEndPoint)/application/types/\(typeId)/devices/\(deviceId)/events/\(eventName)")  else { return completionHandler(.failure(NetworkError.badURL)) }
        let request = NSMutableURLRequest(url: devicesURL)
        request.httpMethod = "POST"
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(message)
            request.httpBody = jsonData
        }
        catch let err {
            completionHandler(.failure(err))
        }
        
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let res = response as? HTTPURLResponse else { return }
            if let error = error { return completionHandler(.failure(error)) }
            if res.statusCode == 200 {
                completionHandler(.success(res.statusCode))
            }
            else {
                completionHandler(.failure(NetworkError.badURL))
            }
        }.resume()
    }
    
    public func command(device: DeviceData, commandName: String, message: Message, completionHandler: @escaping (Result<Int, Error>) -> Void) {
        guard let typeId = device.typeId else { return }
        guard let deviceId = device.deviceId else { return }
        guard let devicesURL = URL(string: "\(IBMIoTClient.msgEndPoint)/application/types/\(typeId)/devices/\(deviceId)/commands/\(commandName)")  else { return completionHandler(.failure(NetworkError.badURL)) }
        let request = NSMutableURLRequest(url: devicesURL)
        request.httpMethod = "POST"
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(message)
            request.httpBody = jsonData
        }
        catch let err {
            return completionHandler(.failure(err))
        }
        
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let res = response as? HTTPURLResponse else { return }
            if let error = error { return completionHandler(.failure(error)) }
            if res.statusCode == 200 {
                completionHandler(.success(res.statusCode))
            }
            else {
                completionHandler(.failure(NetworkError.badURL))
            }
        }.resume()
    }
    
    // MARK :- Device Data
    
    public func getDeviceState(device: DeviceData, withStateId stateId: String, completionHandler: @escaping (Result<DeviceStateData, Error>) -> Void) {
        guard let typeId = device.typeId else { return }
        guard let deviceId = device.deviceId else { return }
        guard let devicesURL = URL(string: "\(IBMIoTClient.endPoint)/device/types/\(typeId)/devices/\(deviceId)/state/\(stateId)")  else { return completionHandler(.failure(NetworkError.badURL)) }
        let request = NSMutableURLRequest(url: devicesURL)
        request.httpMethod = "GET"
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else { return completionHandler(.failure(NetworkError.noResponse))}
            do {
                let deviceData = try JSONDecoder().decode(DeviceStateData.self, from: data)
                return completionHandler(.success(deviceData))
            } catch let err {
                return completionHandler(.failure(err))
            }
        }.resume()
    }
}




// MARK: - Device Models

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
    public var stateData: DeviceStateData?
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
    public var authenticated: Bool?
    public var armed: Bool?
    public var fire: Bool?
    public var co: Bool?
    public var pir: Bool?
    public var mic: Bool?
    public var scream: Bool?
    public var ssid: String?
}

public struct Message: Codable {
    public init() {}
    public var deviceId: String?
    public var status: Int?
}

public struct DeviceStateData: Codable {
    public var timestamp: String?
    public var updated: String?
    public var state: DeviceState?
}


public struct DeviceState: Codable {
    public var temperature: Double
    public var humidity: Double
    public var battery: Double
    
}
