//
//  QueryOrder.swift
//  RevenueMonster
//
//  Created by yussuf on 5/12/19.
//

import Foundation

public final class QueryOrder {
    var checkoutId: String = ""
    var env: Env = Env.PRODUCTION
    var transaction: Transaction = Transaction()
    var paymentError: PaymentError?

    public init(checkoutId: String, env: Env) throws {
        self.env = env;
        self.checkoutId = checkoutId;
        
        var body: [String: AnyObject] = [:]
        body["code"] = checkoutId as AnyObject
        
        let url: String = Domain(self.env).getPaymentGatewayURL() + "/v1/online/transaction/status"
        
        do {
            let (statusCode, data) = try HttpClient().request(url: url, method: "POST", body: body)
            if statusCode > 204 {
                let response = try convertToDictionary(text: String(describing: String(data: data!, encoding: .utf8)!))
                let error = response!["error"] as? Dictionary<String, AnyObject>
                paymentError = PaymentError(code: error?["code"] as! String, message: error?["message"] as! String)
            } else {
                let response = try convertToDictionary(text: String(describing: String(data: data!, encoding: .utf8)!))
                let item = response!["item"] as? Dictionary<String, AnyObject>
                transaction.setTransaction(transaction: item!)
            }
        } catch {
            throw error
        }
    }
    
    public func isPaymentSuccess() -> Bool {
        return self.transaction.status == Status.SUCCESS.toString()
    }
    
    public func getTransactionStatus() -> String {
        return self.transaction.status;
    }
    
    public func error() -> PaymentError? {
        return self.paymentError;
    }
    
    public func getTransaction() -> Transaction {
        return self.transaction;
    }
}
