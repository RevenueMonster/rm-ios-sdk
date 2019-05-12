//
//  Status.swift
//  RevenueMonster
//
//  Created by yussuf on 5/12/19.
//

import Foundation

public enum Status: String {
    case SUCCESS = "SUCCESS"
    case FAILED = "FAILED"
    case IN_PROCESS = "IN_PROCESS"
    
    public func toString() -> String {
        return self.rawValue
    }
}
