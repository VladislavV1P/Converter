//
//  CurrencyManager.swift
//  Converter
//
//  Created by Владислав Патраков on 30.03.2022.
//

import Foundation
import Alamofire
import UIKit

class CurrencyManager {
    private enum Constants {
        static let url = "https://www.cbr-xml-daily.ru"
        static let urlArchive = "archive"
        static let urlCompletion = "daily_json.js"
        static let keyCurrency = "Valute"
        static let keyValue = "Value"
        static let keyName = "Name"
    }
    
    func getCurrency(date: String, completionHandler: @escaping([Currency]) -> Void) {
        let url = self.checkingDate(date: date)
        guard let url = url else {
            return
        }
        requestData(url: url) { (currency) in
            completionHandler(currency)
        }
    }
    
    private func checkingDate(date: String) -> URL? {
        var url = URL(string: Constants.url)
        
        if date != FormattingUtils.formatDateAPI(date: Date()) {
            url?.appendPathComponent(Constants.urlArchive, isDirectory: true)
            url?.appendPathComponent(date,isDirectory: true)
            url?.appendPathComponent(Constants.urlCompletion)
            return url
        } else {
            url?.appendPathComponent(Constants.urlCompletion)
            return url
        }
    }
    
    private func currencyFromJson(json: CurrencyResponse) -> [Currency] {
        var currency = [Currency]()
        currency = json.valute.map({ (code, value) in
            Currency(code: code, name: value.name, value: value.value, nominal: value.nominal)
        })
        return currency
    }
    
    private func requestData(url: URL, completionHandler: @escaping([Currency]) -> Void) {
        var currency = [Currency]()
        AF.request(url, method: .get).response { [weak self]  response in
            guard let self = self else { return }
            switch response.result {
            case .success(let value):
                guard let value = value else {return}
                do {
                    let json = try JSONDecoder().decode(CurrencyResponse.self, from: value)
                    currency = self.currencyFromJson(json: json)
                    completionHandler(currency)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
