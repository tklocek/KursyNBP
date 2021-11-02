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
    private var historical: [CurrencyHist] = []
    
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
        default: break
        }
    }
    
    func saveTableData(rawData: CTable) {
        var tempCurrencies: [Currency] = []
        
        self.currencyDate = rawData.effectiveDate
        let currentTable = rawData.table
        let rates = rawData.rates
        
        rates.forEach { oneRate in
            let name = oneRate.currency
            let code = oneRate.code
            
            let average = (oneRate.ask + oneRate.bid) / 2
            
            let (multi, value) = self.changeDecimalPoint(value: average)
            
            let currency = Currency(currency: name, code: code, multiplier: multi, value: value)
            tempCurrencies.append(currency)
        }
        
        switch currentTable {
        case "C": self.tableC = tempCurrencies
        default: break
        }
    }
    
    func saveHistData(rawData: CTableHist) {
        var tempHist: [CurrencyHist] = []
        
        let rates = rawData.rates
        var multiplyer: Decimal = 0.0
        
        rates.forEach { oneRate in
            let date = oneRate.effectiveDate
         
            if multiplyer == 0 {
                let (multi, _) = self.changeDecimalPoint(value: oneRate.ask)
                multiplyer = Decimal(multi)
            }
            
            let bid = oneRate.bid * multiplyer
            let ask = oneRate.ask * multiplyer
            
            let average = (ask + bid) / 2
            
            let histData = CurrencyHist(date: date, mid: average, ask: ask, bid: bid)
            tempHist.append(histData)
        }
        
        
        historical = tempHist
    }
    
    func saveHistData(rawData: ABTableHist) {
        var tempHist: [CurrencyHist] = []
        
        let rates = rawData.rates
        var multiplyer: Decimal = 0.0
        
        rates.forEach { oneRate in
            let date = oneRate.effectiveDate
         
            if multiplyer == 0 {
                let (multi, _) = self.changeDecimalPoint(value: oneRate.mid)
                multiplyer = Decimal(multi)
            }
            
            let average = oneRate.mid * multiplyer / 2
            
            let histData = CurrencyHist(date: date, mid: average, ask: nil, bid: nil)
            tempHist.append(histData)
        }
        
        historical = tempHist
    }
    
    func ratesCount(for table: CurrencyTable) -> Int {
        switch table {
        case .a: return tableA.count
        case .b: return tableB.count
        case .c: return tableC.count
        }
    }
    
    func historicalDataCount() -> Int {
        return historical.count
    }
    
    func getOneHistData(at index: Int) -> CurrencyHist? {
        return index < historical.count ? historical[index] : nil
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
