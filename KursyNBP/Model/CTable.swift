//
//  CTable.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-10-29.
//

import Foundation


struct CCurrency: Codable {
    var currency: String
    var code: String
    var bid: Decimal
    var ask: Decimal
    
    private enum CodingKeys : String, CodingKey {
            case currency, code, bid, ask
        }
}


struct CTable: Codable {
    var table: String
    var no: String
    var tradingDate: String
    var effectiveDate: String
    var rates: [CCurrency]
}

extension CCurrency {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = try container.decode(String.self, forKey: .currency).string
        self.code = try container.decode(String.self, forKey: .code).string
        self.ask = try container.decode(Double.self, forKey: .ask).decimal ?? .zero
        self.bid = try container.decode(Double.self, forKey: .bid).decimal ?? .zero
    }
}
