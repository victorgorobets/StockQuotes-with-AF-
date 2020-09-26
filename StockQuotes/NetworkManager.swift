////
////  NetworkManager.swift
////  StockQuotes
////
////  Created by VICTOR on 21.09.2020.
////

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchCompanyData(from dataUrl: String, with completion: @escaping (Company) -> Void) {
        
        AF.request(dataUrl)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    if let company = Company.getDetails(from: value) {
                        DispatchQueue.main.async {
                            completion(company)
                        }}
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func fetchStockData(from dataUrl: String, with completion: @escaping (Stock) -> Void) {
        
        AF.request(dataUrl)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    if let stock = Stock.getDetails(from: value) {
                        DispatchQueue.main.async {
                            completion(stock)
                        }}
                case .failure(let error):
                    print(error)
                }
            }
    }
}

