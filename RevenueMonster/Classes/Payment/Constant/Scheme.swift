//
//  Status.swift
//  RevenueMonster
//
//  Created by yussuf on 5/12/19.
//

import Foundation

public class Scheme {
    var env: Env

    public init(_ env: Env) {
        self.env = env
    }
    
    public func isInstalled(_ method: Method) -> Bool {
        let scheme = self.getScheme(method)
        if scheme != "" {
            if let url = URL(string: scheme) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    private func getScheme(_ method: Method) -> String {
        switch method {
        case Method.ALIPAY_CN:
            return getAlipay()
 
        case Method.BOOST_MY:
            return getBoost()
            
        case Method.WECHATPAY_MY:
            return getWeChatPay()
            
        default:
            return ""
        }
    }
    
    private func getBoost() -> String {
        return "boostapp://"
    }
    
    private func getAlipay() -> String {
//        if self.env == Env.PRODUCTION {
//            return "alipay://"
//        }
        return "alipay://"
    }
    
    private func getWeChatPay() -> String {
        return "weixin://"
    }
}
