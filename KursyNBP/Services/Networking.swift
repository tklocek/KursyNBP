//
//  Networking.swift
//  KursyNBP
//
//  Created by Tomasz Klocek on 2021-10-29.
//

import Foundation

enum CurrencyTable{
    case a,b,c
}


class Networking {
        
    static func fetchTable(table: CurrencyTable, completion: @escaping (Result<Data, Error>) -> ()) {
        let query = "https://api.nbp.pl/api/exchangerates/tables/\(table)"
        
        guard let url = URL(string: query) else { fatalError("Invalid string query") }
        
        
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let responseData = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(responseData))
            
        }).resume()
        
    }
    
    
    static func fetchHistory(for code: String, in table: CurrencyTable, from startDate: String, to endDate: String, completion: @escaping (Result<Data, Error>) -> ()) {
        let query = "https://api.nbp.pl/api/exchangerates/rates/\(table)/\(code)/\(startDate)/\(endDate)/"
        
        guard let url = URL(string: query) else { fatalError("Invalid string query") }
        
        
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let responseData = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(responseData))
            
        }).resume()
        
    }
    
}
