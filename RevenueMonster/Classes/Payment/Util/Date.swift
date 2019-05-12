//
//  Date.swift
//  RevenueMonster
//
//  Created by yussuf on 5/12/19.
//

import Foundation

extension Date {
    func timestamp() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
