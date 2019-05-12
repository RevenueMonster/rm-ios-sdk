//
//  PaymentResult.swift
//  RevenueMonster
//
//  Created by yussuf on 5/9/19.
//

import Foundation

public protocol PaymentResult {
    func onPaymentSuccess(transaction: Transaction)
    func onPaymentFailed(error: PaymentError)
    func onPaymentCancelled()
}
