//
//  Checkout.swift
//  RevenueMonster
//
//  Created by yussuf on 5/8/19.
//

import Foundation
import WeChatSDK
import WebKit

public final class Checkout {
    var wechatAppID: String = ""
    var env: Env = Env.PRODUCTION
    var isLeaveApp: Bool = false
    var inAppWebView: Bool = false
    var leaveTimestamp: Int64!
    var viewController: UIViewController!
    var openBrowserView: UIViewController!

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func setWeChatAppID(_ wechatAppID: String) -> Checkout {
        self.wechatAppID = wechatAppID
        return self
    }
    
    public func setEnv(_ env: Env) -> Checkout {
        self.env = env
        return self
    }
    
    @objc func onClose() {
        self.openBrowserView.dismiss(animated: true, completion: nil)
        self.inAppWebView = false
    }
    
    public func pay(method: Method, checkoutId: String, result: PaymentResult) throws {
        var body: [String: AnyObject] = [:]
        body["method"] = method.toString() as AnyObject
        body["code"] = checkoutId as AnyObject
    
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
                self.isLeaveApp = true
                self.leaveTimestamp = Date().timestamp()
                try weChatPayMalaysia(prepayId)
                break
            case .ALIPAY_CN, .GRABPAY_MY, .TNG_MY:
                let prepayId = item?["url"] as! String
                self.isLeaveApp = true
                self.leaveTimestamp = Date().timestamp()
                self.inAppWebView = true
                try openBrowser(prepayId)
                break
            case .BOOST_MY:
                let url = item?["url"] as! String
                self.isLeaveApp = true
                self.leaveTimestamp = Date().timestamp()
                self.openURL(scheme: url)
                break
            }
        } catch {
            throw error
        }
        
        DispatchQueue.global(qos: .background).async {
            for _ in 1...800 {
                var isOrderStatusInProcess: Bool = false

                if !self.isLeaveApp {
                    break
                }
                let currentTimestamp = Date().timestamp()!
                let timeDifference = currentTimestamp - self.leaveTimestamp!
                if timeDifference > 4000 && !self.inAppWebView {
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

                    if timeDifference > 4000 && isOrderStatusInProcess && !self.inAppWebView {
                        result.onPaymentCancelled()
                        return
                    }
                    sleep(1)
                } catch {
                    print("error: \(error.localizedDescription).")
                }
            }
        }
    }
    
    private func openBrowser(_ prepayID: String) throws -> Bool {
        openBrowserView = BrowserController(checkout: self, url: prepayID)
        self.viewController.present(openBrowserView, animated: true, completion: nil)
        return true
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
    
    private func openURL(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
