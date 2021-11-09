//
//  ABTableHist.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-11-02.
//

import Foundation


struct ABCurrencyHist: Codable {
    let no: String
    let effectiveDate: String
    var mid: Decimal
    
    private enum CodingKeys : String, CodingKey {
            case no,effectiveDate, mid
        }
}

struct ABTableHist: Codable {
    let table: String
    let currency: String
    let code: String
    let rates: [ABCurrencyHist]
}


extension ABCurrencyHist {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.no = try container.decode(String.self, forKey: .no).string
        self.effectiveDate = try container.decode(String.self, forKey: .effectiveDate).string
        self.mid = try container.decode(Double.self, forKey: .mid).decimal ?? .zero
    }
}


