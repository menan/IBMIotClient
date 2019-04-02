//
//  IBMIoTClient.swift
//  IBMIoTClient
//
//  Created by Vadivelpillai, menan on 4/2/19.
//  Copyright © 2019 Tinrit Labs Inc. All rights reserved.
//

import UIKit

class IBMIoTClient {

    static let shared = IBMIoTClient()
    
    var orgId = "ax789"
    var apiKey = "sdlafj"
    var appToken = "asdkfjlkfsdlf"
    
    var endPoint: String {
        return "https://\(orgId).messaging.internetofthings.ibmcloud.com/api/v0002"
    }
    
    var headers: [String: String] {
        return ["Content-Type": "application/json", "Authentication": "Bearer token"]
    }
    
    init() {
        
        //  uncomment this and add auth token, if your project needs.
        let config = URLSessionConfiguration.default
        let authString = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMywiUGFzc3dvcmQiOiIkMmEkMTAkYVhpVm9wU3JSLjBPYmdMMUk2RU5zdU9LQzlFR0ZqNzEzay5ta1pDcENpMTI3MG1VLzR3SUsiLCJpYXQiOjE1MTczOTc5MjV9.JaSh3FvpAxFxbq8z_aZ_4OhrWO-ytBQNu6A-Fw4pZBY"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        
    }
    
    func getDevices(type: String, completionHandler: @escaping (Any?) -> Void) {
        
        guard let devicesURL = URL(string: "\(endPoint)/devices/\(type)") else { return }
        print(devicesURL)
        
        let request = NSMutableURLRequest(url: devicesURL)
        
        let session = URLSession.shared
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        _ = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else { return }
            do {
                let deviceData = try JSONDecoder().decode(DeviceData.self, from: data)
                print("response data:", deviceData)
                completionHandler(deviceData)
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
}


struct DeviceData: Codable {
    var code: Int?
    var message: String?
    var status: String?
    var token: String?
    var data: MetaData?
}
struct MetaData: Codable {
    var email : String?
    var contactNo : String?
    var firstName : String?
    var lastName: String?
    var dob : String?
    var gender : String?
    var address: String?
    var city : String?
    var state : String?
    var country : String?
    var zip : String?
    var username: String?
}
