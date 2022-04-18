//
//  CurrencyCell.swift
//  Converter
//
//  Created by Владислав Патраков on 23.03.2022.
//

import UIKit

class CurrencyCell: UICollectionViewCell {
    
    @IBOutlet private weak var currencyCodeLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    func setup(data: Currency) {
        currencyCodeLabel.text = data.code
        valueLabel.text = "\(data.value.getStringValue()) \(CurrencySymbols.rub)"
    }
    
// метод который позволяет переиспользовать ячейки с актуальной информацией
    override func prepareForReuse() {
        super.prepareForReuse()
        currencyCodeLabel.text = nil
        valueLabel.text = nil
    }
    
}
