//
//  Transaction.swift
//  RevenueMonster
//
//  Created by yussuf on 5/11/19.
//

import Foundation

public struct Transaction: Codable {
    var key: String = ""
    var id: String = ""
    var merchantKey: String = ""
    var storeKey: String = ""
    var order: Order = Order()
    var type: String = ""
    var transactionId: String = ""
    var platform: String = ""
    var method: [String] = []
    var redirectUrl: String = ""
    var notifyUrl: String = ""
    var startAt: String = ""
    var endAt: String = ""
    var referenceKey: String = ""
    var status: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    
    public mutating func setTransaction(transaction: Dictionary<String, AnyObject>) {
        self.key = transaction["key"] as! String
        self.id = transaction["id"] as! String
        self.merchantKey = transaction["merchantKey"] as! String
        self.storeKey = transaction["storeKey"] as! String
        
        let order = transaction["order"] as? Dictionary<String, AnyObject>
        self.order.setOrder(order: order!)
        
        self.type = transaction["type"] as! String
        self.transactionId = transaction["transactionId"] as! String
        self.platform = transaction["platform"] as! String
        self.method = transaction["method"] as! [String]
        self.redirectUrl = transaction["redirectUrl"] as! String
        self.notifyUrl = transaction["notifyUrl"] as! String
        self.startAt = transaction["startAt"] as! String
        self.endAt = transaction["endAt"] as! String
        self.referenceKey = transaction["referenceKey"] as! String
        self.status = transaction["status"] as! String
        self.createdAt = transaction["createdAt"] as! String
        self.updatedAt = transaction["updatedAt"] as! String
    }
    
    public func getTransactionId() -> String {
        return self.transactionId
    }
    
    public func getStatus() -> String {
        return self.status
    }
    
    public func getType() -> String {
        return self.type
    }
    
    public func getCurrencyType() -> String {
        return self.order.currencyType
    }
    
    public func getAmount() -> NSInteger {
        return self.order.amount
    }
}
