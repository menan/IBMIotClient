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
    
    public var orgId = ""
    public var apiKey = ""
    public var appToken = ""
    
    var endPoint: String {
        return "https://\(orgId).messaging.internetofthings.ibmcloud.com/api/v0002"
    }
    
    
    init() {
        //  uncomment this and add auth token, if your project needs.
        let config = URLSessionConfiguration.default
        let credentialData = "\(apiKey):\(appToken)".data(using: .utf8)
        guard let cred = credentialData else { return }
        let base64Credentials = cred.base64EncodedData(options: [])
        guard let base64Date = Data(base64Encoded: base64Credentials) else { return }
        config.httpAdditionalHeaders = ["Accept": "application/json", "Content-Type": "application/json", "Authorization": "Bearer \(base64Date.base64EncodedString())"]
    }
    
    public func getDevices(type: String, completionHandler: @escaping (Any?) -> Void) {
        guard let devicesURL = URL(string: "\(endPoint)/devices/\(type)/devices") else { return }
        print(devicesURL)
        
        let request = NSMutableURLRequest(url: devicesURL)
        
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else { return }
            do {
                let deviceData = try JSONDecoder().decode(DeviceInfoData.self, from: data)
                print("response data:", deviceData)
                completionHandler(deviceData)
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}


public struct DeviceData: Codable {
    var clientId: String?
    var typeId: String?
    var deviceId: String?
    var deviceInfo: DeviceInfoData?
    var metadata: Metadata?
}

public struct DeviceInfoData: Codable {
    var serialNumber: String?
    var manufacturer: String?
    var model: String?
    var deviceClass: String?
    var description : String?
    var fwVersion: String?
    var hwVersion: String?
    var descriptiveLocation: String?
}

public struct Metadata: Codable {
    var name: String?
    var armed: String?
}
