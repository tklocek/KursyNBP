//
//  Currency.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-10-29.
//

import Foundation


struct Currency: Codable {
    var currency: String
    var code: String
    var multiplier: Int
    var value: Decimal
    
    
}
