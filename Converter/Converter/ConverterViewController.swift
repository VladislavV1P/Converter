//
//  ConverterViewController.swift
//  Converter
//
//  Created by Владислав Патраков on 27.03.2022.
//

import UIKit

class ConverterViewController: UIViewController {
    
    private enum Constants {
        static let zero = "0"
        static let inputError = "некоректный вввод, используйте числа"
        static let invalidNumberError = "недопустимое число"
        static let maxValue = 100000000
        static let errorValue = "не содержит значения"
    }
    
    var currency: Currency?
    
    @IBOutlet private weak var nominalLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var convertLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupLabels()
    }
    
    private func setupNavigationItem() {
        guard let code = currency?.code else { return }
        navigationItem.title = code
    }
    
    private func setupLabels() {
        guard let currency = currency else { return }
        nominalLabel.text = "\(currency.nominal) \(currency.code)"
        nameLabel.text = currency.name
        codeLabel.text = currency.code
        valueLabel.text = "\(currency.value.getStringValue()) \(CurrencySymbols.rub)"
        errorLabel.isHidden = true
        convertLabel.isUserInteractionEnabled = false
    }
    
    @IBAction private func convertCurrency(_ sender: UITextField) {
        if let value = sender.text {
            if let errorValue = invalidValue(digit: value) {
                errorLabel.text = errorValue
                errorLabel.isHidden = false
                convertLabel.text = Constants.zero
            } else {
                convertLabel.text = converter(digit: value)
                errorLabel.isHidden = true
            }
        }
    }
    
    private func invalidValue(digit: String) -> String? {
        let set = CharacterSet(charactersIn: digit)
        if !CharacterSet.decimalDigits.isSuperset(of: set) {
            return Constants.inputError
        }
        if let value = Int(digit) {
            if value > Constants.maxValue {
                return Constants.invalidNumberError
            }
        }
        return nil
    }
    
    private func converter(digit: String) -> String {
        if let value = NumberFormatter().number(from: digit), let currency = currency {
            let total = value.doubleValue * currency.value
            guard let total = total.formattedWithSeparator else { return Constants.errorValue}
            return total
        }
        return Constants.zero
    }
    
}
