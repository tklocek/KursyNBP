//
//  CTableHist.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-11-02.
//

import Foundation



struct CCurrencyHist: Codable {
    let no: String
    let effectiveDate: String
    var ask: Decimal
    var bid: Decimal
    
    private enum CodingKeys : String, CodingKey {
            case no,effectiveDate, ask, bid
        }
}

struct CTableHist: Codable {
    let table: String
    let currency: String
    let code: String
    let rates: [CCurrencyHist]
}


extension CCurrencyHist {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.no = try container.decode(String.self, forKey: .no).string
        self.effectiveDate = try container.decode(String.self, forKey: .effectiveDate).string
        self.ask = try container.decode(Double.self, forKey: .ask).decimal ?? .zero
        self.bid = try container.decode(Double.self, forKey: .bid).decimal ?? .zero
    }
}
