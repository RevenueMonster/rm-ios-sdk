//
//  ErrorException.swift
//  RevenueMonster
//
//  Created by yussuf on 5/11/19.
//

import Foundation

public enum CheckoutError: Error {
    case wechatAppNotInstalled
    case invalidWeChatAppID
    case failToInitiatePayment
}

extension CheckoutError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidWeChatAppID:
            return NSLocalizedString("Invalid wechat appid", comment: "Check on wechat app id")
        case .failToInitiatePayment:
            return NSLocalizedString("Failed to initiate payment", comment: "Check the trigger payment function")
        case .wechatAppNotInstalled:
            return NSLocalizedString("Wechat app not installed", comment: "User does not have wechat app")
        }
    }
}
