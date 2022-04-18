//
//  SettingsViewController.swift
//  Converter
//
//  Created by Владислав Патраков on 11.04.2022.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    private enum Constants {
        static let IdentifierCell = "СurrencyBaseCell"
        static let imagePadding: CGFloat = 160
        static let cellMargins: CGFloat = 80
        static let numberOfButtonsLine: CGFloat = 5
        static let cellSpacing: CGFloat = 20
        static let cellPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    var currencyBase = [Currency]()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSaveSettingsCurrency()
        setupCollectionView()
    }
    
    @IBAction private func saveButton() {
        //        print(currencyBase)
        CurrencyCoreData.shared.saveCurrency(currency: currencyBase)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction private func cancelButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func checkSaveSettingsCurrency() {
        if  !CurrencyCoreData.shared.loadSettingsCurrency(currency: currencyBase).isEmpty {
            currencyBase = CurrencyCoreData.shared.loadSettingsCurrency(currency: currencyBase)
        }
    }
    
    private func setupCollectionView() {
        self.collectionView.register(UINib(nibName: Constants.IdentifierCell, bundle: nil), forCellWithReuseIdentifier: Constants.IdentifierCell)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}

extension SettingsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencyBase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.IdentifierCell,
            for: indexPath) as? СurrencyBaseCell
        else { return UICollectionViewCell() }
        
        let data = currencyBase[indexPath.item]
        cell.setupCell(data: data)
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
        currencyBase[indexPath.row].isHidden.toggle()
        collectionView.reloadData()
    }
}
