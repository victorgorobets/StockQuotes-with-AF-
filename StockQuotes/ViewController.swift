//
//  ViewController.swift
//  StockQuotes
//
//  Created by VICTOR on 21.09.2020.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var symbolPicker: UIPickerView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyIndustryLabel: UILabel!
    @IBOutlet weak var companyDescriptionLabel: UILabel!
    @IBOutlet weak var companyMarketCapLabel: UILabel!
    
    @IBOutlet weak var stockCurrenPrice: UILabel!
    @IBOutlet weak var stockAnalystTargetPrice: UILabel!
    @IBOutlet weak var recommendation: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    
    private let basicCompanyInfoURL = "https://www.alphavantage.co/query?function=OVERVIEW&symbol="
    private let basicStockInfoURL = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol="
    private let companySymbols = ["MSFT", "IBM","GOOGL","AMRN","EBAY","AMZN","NFLX","BAC","FB"]
    private let sourceAPI = "&apikey=075Q1OZQS6U1EVIW"
//    var companyInfoURL = "https://www.alphavantage.co/query?function=OVERVIEW&symbol=IBM&apikey=demo"
//    var stockInfoURL = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=IBM&apikey=demo"
    private var selectedStock = "MSFT"
    private var companyInfoURL: String {basicCompanyInfoURL + selectedStock + sourceAPI}
    private var stockInfoURL: String {basicStockInfoURL + selectedStock + sourceAPI}
    
    private var companyData: Company?
    private var stockData: Stock?
    
    private var price = 0.00
    private var targetPrice = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        symbolPicker.dataSource = self
        symbolPicker.delegate = self
        
        NetworkManager.shared.fetchCompanyData(from: companyInfoURL) { companyData in
            self.companyData = companyData
            self.showCompanyInfoLabels(companyData)
            self.view.reloadInputViews()
        }
        NetworkManager.shared.fetchStockData(from: stockInfoURL) { stockData in
            self.stockData = stockData
            self.showStockInfoLabels(stockData)
            self.view.reloadInputViews()
        }
    }
    
    // Symbol Picker settings
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        companySymbols.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return companySymbols[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStock = companySymbols[row]
        NetworkManager.shared.fetchCompanyData(from: companyInfoURL) { company in
            DispatchQueue.main.async {
                self.showCompanyInfoLabels(company)
            }
        }
        NetworkManager.shared.fetchStockData(from: stockInfoURL) { stock in
            DispatchQueue.main.async {
                self.showStockInfoLabels(stock)
            }
        }
    }
   
    
    private func showCompanyInfoLabels(_ companyData: Company) {
        companyNameLabel.text = "Company name:  \(companyData.name ?? "")"
        companyIndustryLabel.text = "Industry:  \(companyData.industry ?? "")"
        companyDescriptionLabel.text = "Description:  \(companyData.description ?? "")"
        companyMarketCapLabel.text = "Market Capitalizaion:  $\(Int(companyData.marketCapitalization ?? "0")! / 1000000) bln"
        targetPrice = Double(companyData.analystTargetPrice ?? "0") ?? 0
        stockAnalystTargetPrice.text = "Target:  $" + String(format: "%.02f", targetPrice)
    }
    
    private func showStockInfoLabels(_ stockData: Stock) {
        price = Double(stockData.price ?? "0") ?? 0
        stockCurrenPrice.text = "Price:  " + String(format: "%.02f", price)
        let difference = Int((targetPrice / price - 1) * 100)
        switch difference {
        case 5... :
            recommendation.text = "BUY"
            recommendation.textColor = .green
            comment.text = "Potential profit: \(difference) %"
            comment.textColor = .green
        case -5...5 :
            recommendation.text = "HOLD"
            recommendation.textColor = .gray
            comment.text = "No significant changes expected"
            comment.textColor = .gray
        case 5... :
            recommendation.text = "SELL"
            recommendation.textColor = .red
            comment.text = "Potential loss: \(-difference) %"
            comment.textColor = .red
        default: break
        }
    }
}
