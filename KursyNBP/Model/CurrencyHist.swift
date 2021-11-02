//
//  CurrencyHist.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-11-02.
//

import Foundation


struct CurrencyHist: Codable {
    var date: String
    var mid: Decimal
    var ask: Decimal?
    var bid: Decimal?
}
