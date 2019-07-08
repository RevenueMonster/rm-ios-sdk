//
//  Method.swift
//  RevenueMonster
//
//  Created by yussuf on 5/12/19.
//

import Foundation

public enum Method: String {
    case WECHATPAY_MY = "WECHATPAY_MY"
    case BOOST_MY = "BOOST_MY"
    case TNG_MY = "TNG_MY"
    case ALIPAY_CN = "ALIPAY_CN"
    case GRABPAY_MY = "GRABPAY_MY"

    public func toString() -> String {
        return self.rawValue
    }
}
