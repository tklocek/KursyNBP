//
//  Decimal.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-10-30.
//

import Foundation

extension Decimal {
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
    
    var formattedAmount: String? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 4
        formatter.maximumFractionDigits = 4
        return formatter.string(from: self as NSDecimalNumber)
    }
    
    
}


extension LosslessStringConvertible {
    var string: String { .init(self) }
}


extension FloatingPoint where Self: LosslessStringConvertible {
    var decimal: Decimal? { Decimal(string: string) }
}
