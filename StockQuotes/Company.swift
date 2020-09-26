//
//  Company.swift
//  StockQuotes
//
//  Created by VICTOR on 21.09.2020.


struct Company: Decodable {
    
    let symbol: String?
    let name: String?
    let description: String?
    let industry: String?
    let marketCapitalization: String?
    let analystTargetPrice: String?
    
    init(companyData: [String: Any]) {
        symbol = companyData["Symbol"] as? String
        name = companyData["Name"] as? String
        marketCapitalization = companyData["MarketCapitalization"] as? String
        industry = companyData["Industry"] as? String
        description = companyData["Description"] as? String
        analystTargetPrice = companyData["AnalystTargetPrice"] as? String
    }
    
    static func getDetails(from value: Any) -> Company? {
        guard let companyData = value as? [String: Any] else { return nil }
        return Company(companyData: companyData)
    }
}

struct Stock: Decodable {
    let price: String?
    
    enum CodingKeys: String, CodingKey {
        case price = "05. price"
    }
    
    init(stockData: [String: Any]) {
        price = stockData["05. price"] as? String
    }
    
    static func getDetails(from value: Any) -> Stock? {
        guard let stocksData = value as? [String: Any] else { return nil }
        guard let stockData = stocksData["Global Quote"] as? [String: Any] else { return nil }
        return Stock(stockData: stockData)
    }
}
