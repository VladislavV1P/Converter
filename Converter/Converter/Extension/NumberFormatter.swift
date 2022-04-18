//
//  NumberFormatter.swift
//  Converter
//
//  Created by Владислав Патраков on 05.04.2022.
//

import Foundation

extension Formatter {
    private enum Constants {
        static let formatRU = "ru_RU"
    }
    
    static let currencyDisplay = Formatter()
    
    func currencyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .init(identifier: Constants.formatRU)
        return formatter
    }
}

extension Numeric {
    var formattedWithSeparator: String? {
        guard let isNumber = self as? NSNumber else { return nil }
        return Formatter.currencyDisplay.currencyFormatter().string(from: isNumber )
    }
}
