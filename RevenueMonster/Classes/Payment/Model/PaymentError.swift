//
//  PaymentError.swift
//  RevenueMonster
//
//  Created by yussuf on 5/12/19.
//

import Foundation

public struct PaymentError: Codable {
    var code: String = ""
    var message: String = ""
    
    public init(code: String, message: String) {
        self.code = code
        self.message = message
    }
    
    public func getCode() -> String {
        return self.code
    }
    
    public func getMessage() -> String {
        return self.message
    }
}
