//
//  Converter.swift
//  RevenueMonster
//
//  Created by yussuf on 5/12/19.
//

import Foundation

internal func convertToDictionary(text: String) throws -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            throw error
        }
    }
    return nil
}
