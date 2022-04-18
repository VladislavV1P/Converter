//
//  Double+Extension.swift
//  Converter
//
//  Created by Владислав Патраков on 24.03.2022.
//

import Foundation

extension Double {
    
    private enum Constants {
        static let defaultStringFormat = "%.2f"
    }
    
    func getStringValue(with format: String = Constants.defaultStringFormat) -> String {
        return String(format: format, self)
    }
}
