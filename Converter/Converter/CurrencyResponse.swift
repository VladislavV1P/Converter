//
//  CurrencyResponse.swift
//  Converter
//
//  Created by Владислав Патраков on 01.04.2022.
//

import Foundation

struct CurrencyResponse: Codable {
    var valute: [String: PropertyCurrency]
    
    enum CodingKeys: String, CodingKey {
        case valute = "Valute"
    }
}

struct PropertyCurrency: Codable {
    var charCode: String
    var name: String
    var value: Double
    var nominal: Int
    
    enum CodingKeys: String, CodingKey {
        case charCode = "CharCode"
        case name = "Name"
        case value = "Value"
        case nominal = "Nominal"
    }
}
