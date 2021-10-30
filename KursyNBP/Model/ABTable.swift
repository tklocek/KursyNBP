//
//  ABTable.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-10-29.
//

import Foundation


struct ABCurrency: Codable {
    let currency: String
    let code: String
    var mid: Decimal
    
    private enum CodingKeys : String, CodingKey {
            case currency, code, mid
        }
}


struct ABTable: Codable {
    let table: String
    let no: String
    let effectiveDate: String
    let rates: [ABCurrency]
}


extension ABCurrency {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = try container.decode(String.self, forKey: .currency).string
        self.code = try container.decode(String.self, forKey: .code).string
        self.mid = try container.decode(Double.self, forKey: .mid).decimal ?? .zero
    }
}


