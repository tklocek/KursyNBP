//
//  DataService.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-10-29.
//

import Foundation



class DataService {
    
    static let instance = DataService()
    
    private(set) var currencyDate: String = ""
    private var tableA: [Currency] = []
    private var tableB: [Currency] = []
    private var tableC: [Currency] = []
    
    
    func saveTableData(rawData: ABTable) {
        var tempCurrencies: [Currency] = []
        
        self.currencyDate = rawData.effectiveDate
        let currentTable = rawData.table
        let rates = rawData.rates
        
        rates.forEach { oneRate in
            let name = oneRate.currency
            let code = oneRate.code
            let (multi, value) = self.changeDecimalPoint(value: oneRate.mid)
            
            let currency = Currency(currency: name, code: code, multiplier: multi, value: value)
            tempCurrencies.append(currency)
        }
        
        switch currentTable {
        case "A": self.tableA = tempCurrencies
        case "B": self.tableB = tempCurrencies
        case "C": break
        default: break
        }
        
    }
    
    func ratesCount(for table: CurrencyTable) -> Int {
        switch table {
        case .a: return tableA.count
        case .b: return tableB.count
        case .c: return tableC.count
        }
    }
    
    func getOneCurrency(for table: CurrencyTable, at index: Int) -> Currency? {
        switch table {
        case .a: return index < tableA.count ? tableA[index] : nil
        case .b: return index < tableB.count ? tableB[index] : nil
        case .c: return index < tableC.count ? tableC[index] : nil
        }
    }
    
    
    
    private func changeDecimalPoint(value: Decimal) -> (Int,Decimal) {
        let currentDecimalDigits = value.significantFractionalDecimalDigits
        var multiplier: Int = 1
        var finalValue = value
        
        if currentDecimalDigits <= 4 {
            return (1,value)
        }
        
        for _ in 1...currentDecimalDigits - 4 {
            multiplier = multiplier * 10
            finalValue = finalValue * 10
        }
        
        return (multiplier, finalValue)
    }

    
    
}
