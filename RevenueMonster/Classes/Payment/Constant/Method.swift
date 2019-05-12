//
//  Method.swift
//  RevenueMonster
//
//  Created by yussuf on 5/12/19.
//

import Foundation

public enum Method: String {
    case WECHATPAY_MY = "WECHATPAY_MY"
    
    public func toString() -> String {
        return self.rawValue
    }
}
