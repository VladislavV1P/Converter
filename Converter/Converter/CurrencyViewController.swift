//
//  ViewController.swift
//  Converter
//
//  Created by Владислав Патраков on 15.03.2022.
//

import UIKit
import Foundation
import Alamofire
import CoreData

class CurrencyViewController: UIViewController {
    
    private enum Constants {
        static let imagePadding: CGFloat = 160
        static let IdentifierCell = "CurrencyCell"
        static let cellMargins: CGFloat = 40
        static let numberOfButtonsLine: CGFloat = 3
        static let cellSpacing: CGFloat = 20
        static let cellPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let segueConverter = "goToConverter"
        static let segueSettings = "goToSetting"
        
        static let alertTitle = ""
        static let saveButtonTitle = "Сохранить"
        static let cancelButtonTitle = "Отмена"
        static let alertHeight: CGFloat = 400
        static let datePickerHeight: CGFloat = 270
        static let datePickerTopOffset: CGFloat = 10
    }
    
    private var currencyManager = CurrencyManager()
    private var selectedDate =  Date()
    private var currency = [Currency]()
    private var currencyDisplay = [Currency]()
    private var selectedCurrencyIndex = 0
    
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var dateButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateButton.configuration?.imagePadding = view.frame.width - Constants.imagePadding
        setupCollectionView()
        loadCurrencyOnSelectedDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLoadSettingsCurrency()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dateButton.setTitle("\(setDate())", for: .normal)
    }
    
    private func loadCurrencyOnSelectedDate() {
        currencyManager.getCurrency(date: apiDate()) { [weak self] (loadCurrency) in
            guard let self = self else { return }
            self.currency = loadCurrency.sorted(by: { $0.code < $1.code })
            self.currencyDisplay = self.currency
            self.checkLoadSettingsCurrency()
            self.collectionView.reloadData()
        }
    }
    
    @IBAction private func dateButtonPressed(_ sender: UIButton) {
        showDateAlert() { [weak self] (date) in
            guard let self = self else {return}
            self.selectedDate = date
            sender.setTitle(self.setDate(), for: .normal)
            self.loadCurrencyOnSelectedDate()
        }
    }
    
    private func checkLoadSettingsCurrency() {
        let currencyData = CurrencyCoreData.shared.loadSettingsCurrency(currency: currency)
        mergeCurrency(data: currencyData)
    }
    
    private func mergeCurrency(data: [Currency]) {
        var currencyBase = [Currency]()
        for index in data.indices {
            if !data[index].isHidden {
                let item = currency[index]
                currencyBase.append(item)
            }
        }
        currencyDisplay = currencyBase.isEmpty ? currency : currencyBase
    }
    
    private func setupCollectionView() {
        self.collectionView.register(UINib(nibName: Constants.IdentifierCell, bundle: nil), forCellWithReuseIdentifier: Constants.IdentifierCell)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func setDate() -> String {
        FormattingUtils.formatDate(date: selectedDate)
    }
    
    private func apiDate() -> String {
        return FormattingUtils.formatDateAPI(date: selectedDate)
    }
}

extension CurrencyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencyDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
                collectionView.dequeueReusableCell(withReuseIdentifier: Constants.IdentifierCell, for: indexPath) as? CurrencyCell else { return UICollectionViewCell()}
        
        let currency = currencyDisplay[indexPath.item]
        cell.setup(data: currency)
        return cell
    }
    
    // Устанавливаю размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideSize = (UIScreen.main.bounds.width - Constants.cellMargins) / Constants.numberOfButtonsLine
        let size = CGSize(width: sideSize, height: sideSize)
        return size
    }
    // Отступ между секциями
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpacing
    }
    // Отступ ячейки с каждой стороны
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.cellPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCurrencyIndex = indexPath.row
        performSegue(withIdentifier: Constants.segueConverter, sender: nil)
    }
}

extension CurrencyViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.segueConverter :
            if let converter = segue.destination as? ConverterViewController {
                converter.currency = currencyDisplay[selectedCurrencyIndex]
            }
        case Constants.segueSettings :
            if let setCurrency = segue.destination as? SettingsViewController {
                setCurrency.currencyBase = currency.map { (currency) in
                    Currency(code: currency.code, name: currency.name, value: currency.value, nominal: currency.nominal)
                }
            }
        default:
            break
        }
    }
    
    func setupDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        return datePicker
    }
    
    private func showDateAlert(completionHandler: @escaping(Date) -> Void ) {
        
        let alert = UIAlertController(title: Constants.alertTitle, message: nil, preferredStyle: .actionSheet)
        
        let datePicker = setupDatePicker()
        
        alert.view.addSubview(datePicker)
        
        let saveAction = UIAlertAction(title: Constants.saveButtonTitle, style: .default) { (Action) in
            let date = datePicker.date
            completionHandler(date)
        }
        let cancelAction = UIAlertAction(title: Constants.cancelButtonTitle, style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.view.heightAnchor.constraint(equalToConstant: Constants.alertHeight).isActive = true
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalTo: alert.view.widthAnchor).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: Constants.datePickerHeight).isActive = true
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: Constants.datePickerTopOffset).isActive = true
        
        present(alert, animated: true, completion: nil )
    }
}
