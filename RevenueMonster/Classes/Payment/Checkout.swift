//
//  Checkout.swift
//  RevenueMonster
//
//  Created by yussuf on 5/8/19.
//

import Foundation
import WeChatSDK

public final class Checkout {
    var wechatAppID: String = ""
    var env: Env = Env.PRODUCTION
    var isLeaveApp: Bool = false
    var leaveTimestamp: Int64!
    
    public init(viewController: UIViewController) {
    }
    
    public func setWeChatAppID(_ wechatAppID: String) -> Checkout {
        self.wechatAppID = wechatAppID
        return self
    }
    
    public func setEnv(_ env: Env) -> Checkout {
        self.env = env
        return self
    }
    
    public func pay(method: Method, checkoutId: String, result: PaymentResult) throws {
        var body: [String: AnyObject] = [:]
        body["method"] = method.toString() as AnyObject
        body["code"] = checkoutId as AnyObject
    
        do {
            let url: String = Domain(self.env).getPaymentGatewayURL() + "/v1/transaction/mobile"
            let (statusCode, data) = try HttpClient().request(url: url, method: "POST", body: body)
            if statusCode > 204 {
                let response = try convertToDictionary(text: String(describing: String(data: data!, encoding: .utf8)!))
                let error = response!["error"] as? Dictionary<String, AnyObject>
                let paymentError = PaymentError(code: error?["code"] as! String, message: error?["message"] as! String)
                result.onPaymentFailed(error: paymentError)
                return
            }
            
            let response = try convertToDictionary(text: String(describing: String(data: data!, encoding: .utf8)!))
            let item = response!["item"] as? Dictionary<String, AnyObject>
    
            switch method {
            case .WECHATPAY_MY:
                let prepayId = item?["url"] as! String
                let isSend = try weChatPayMalaysia(prepayId)
                if isSend {
                    self.isLeaveApp = true
                    self.leaveTimestamp = Date().timestamp()
                } else {
                    throw CheckoutError.failToInitiatePayment
                }
                break
            }
        } catch {
            throw error
        }
        
        DispatchQueue.global(qos: .background).async {
            for _ in 1...600 {
                var isOrderStatusInProcess: Bool = false
                
                if !self.isLeaveApp {
                    break
                }
                let currentTimestamp = Date().timestamp()!
                let timeDifference = currentTimestamp - self.leaveTimestamp!
                if timeDifference > 4000 {
                    self.isLeaveApp = false
                }
                
                do {
                    let queryOrder = try QueryOrder(checkoutId: checkoutId, env: self.env)
                    if let error = queryOrder.error() {
                        result.onPaymentFailed(error: error)
                        return
                    }
                    
                    if queryOrder.isPaymentSuccess() {
                        result.onPaymentSuccess(transaction: queryOrder.getTransaction())
                        return
                    }
                    
                    if queryOrder.getTransactionStatus() == Status.IN_PROCESS.toString() {
                        isOrderStatusInProcess = true
                    }
                    
                    if timeDifference > 4000 && isOrderStatusInProcess {
                        result.onPaymentCancelled()
                    }
                    sleep(1)
                } catch {
                    print("error: \(error.localizedDescription).")
                }
            }
        }
    }
    
    private func weChatPayMalaysia(_ prepayID: String) throws -> Bool {
        if (!WXApi.registerApp(wechatAppID)) {
            throw CheckoutError.invalidWeChatAppID
        }
        
        if (!WXApi.isWXAppInstalled()) {
            throw CheckoutError.wechatAppNotInstalled
        }

        var dict : Dictionary = Dictionary<AnyHashable,Any>()
        dict["prepay_id"] = prepayID
        
        let i = WXOpenBusinessWebViewReq()
        i.businessType = 7
        i.queryInfoDic = dict

        return WXApi.send(i)
    }
}
