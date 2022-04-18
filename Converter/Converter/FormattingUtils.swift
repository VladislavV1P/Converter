//
//  SettingDate.swift
//  Converter
//
//  Created by Владислав Патраков on 19.03.2022.
//

import Foundation

class FormattingUtils {
    
    private enum Constants {
        static let dateFormat = "dd.MM.YYYY"
        static let dateFormatAPI = "YYYY/MM/dd"
    }
    
    static func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = Constants.dateFormat
        return dateFormatter.string(from: date)
    }
    
    static func formatDateAPI(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = Constants.dateFormatAPI
        return dateFormatter.string(from: date)
    }
}
