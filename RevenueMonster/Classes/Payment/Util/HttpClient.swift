//
//  HttpClient.swift
//  Pods
//
//  Created by yussuf on 5/10/19.
//

import Foundation

internal class HttpClient {
    public init() {
        
    }
    
    
    public func request(url: String, method: String, body: [String: AnyObject]) throws -> (NSInteger, Data?) {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        var dataResponse: Data?
        var statusCode: NSInteger = 0
        let waitGroup = DispatchSemaphore(value: 0)

        request.httpMethod = method
        
        do {
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = bodyData
            print("API Request: ", String(decoding: bodyData, as: UTF8.self))
        } catch let error {
            throw error
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Unexpected error: \(error).")
            } else {
                print("API Response: \(String(describing: String(data: data!, encoding: .utf8)!))")
                if let response = response as? HTTPURLResponse {
                    statusCode = response.statusCode
                }
                dataResponse = data
                waitGroup.signal()
            }
        }
    
        task.resume()
        waitGroup.wait()
        
        
        return (statusCode, dataResponse)
    }
    
    
//    func convertToDictionary(text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
}
