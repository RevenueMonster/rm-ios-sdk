//
//  Order.swift
//  RevenueMonster
//
//  Created by yussuf on 5/11/19.
//

import Foundation

public struct Order: Codable {
    var id: String = ""
    var title: String = ""
    var detail: String = ""
    var additionalData: String = ""
    var currencyType: String = ""
    var amount: NSInteger = 0
    
    public mutating func setOrder(order: Dictionary<String, AnyObject>) {
        self.id = order["id"] as! String
        self.title = order["title"] as! String
        self.detail = order["detail"] as! String
        self.additionalData = order["additionalData"] as! String
        self.currencyType = order["currencyType"] as! String
        self.amount = order["amount"] as! NSInteger
    }
}
