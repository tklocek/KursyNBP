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
}


struct CTable: Codable {
    var table: String
    var no: String
    var tradingDate: String
    var effectiveDate: String
    var rates: [CCurrency]
}
