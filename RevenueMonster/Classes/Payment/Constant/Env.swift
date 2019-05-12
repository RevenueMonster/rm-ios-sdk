//
//  Env.swift
//  RevenueMonster
//
//  Created by yussuf on 5/12/19.
//

import Foundation

public enum Env: String {
    case DEVELOPMENT = "DEVELOPMENT"
    case SANDBOX = "SANDBOX"
    case PRODUCTION = "PRODUCTION"
    
    public func toString() -> String {
        return self.rawValue
    }
}
