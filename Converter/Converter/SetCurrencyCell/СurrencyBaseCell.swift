//
//  СurrencyBaseCell.swift
//  Converter
//
//  Created by Владислав Патраков on 11.04.2022.
//

import UIKit

class СurrencyBaseCell: UICollectionViewCell {

    @IBOutlet private weak var currencyCodeLabel: UILabel!
    @IBOutlet private weak var backgroundImage: UIImageView!
    
    func setupCell(data: Currency) {
        currencyCodeLabel.text = data.code
        backgroundImage.isHidden = data.isHidden
        currencyCodeLabel.textColor = data.isHidden ? .systemGray : .systemCyan
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currencyCodeLabel.text = nil
    }
}
