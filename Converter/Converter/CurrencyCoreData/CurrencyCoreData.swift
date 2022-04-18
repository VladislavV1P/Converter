//
//  CurrencyCoreData.swift
//  Converter
//
//  Created by Владислав Патраков on 15.04.2022.
//

import Foundation
import CoreData
import UIKit

class CurrencyCoreData {
    
    private enum Constants {
        static let entityName = "ModelCurrency"
        static let errorFetch = "Could not fetch."
        static let errorSave = "Failed to saving test data:"
    }
    
    static var shared = CurrencyCoreData()
    
    private func saveCurrencyData(data: Currency) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        guard let saveData = NSEntityDescription.entity(
            forEntityName: Constants.entityName,
            in: context) else {return}
        let currencyBase = ModelCurrency(entity: saveData, insertInto: context)
        currencyBase.code = data.code
        currencyBase.name = data.name
        currencyBase.value = data.value
        currencyBase.nominal = Int64(data.nominal)
        currencyBase.isHidden = data.isHidden
        
        do {
            try context.save()
        } catch {
            print("\(Constants.errorSave)  \(error)")
        }
    }
    
    func saveCurrency(currency: [Currency]) {
        deleteData()
        currency.forEach { item in
            saveCurrencyData(data: item)
        }
    }
    
    private func loadData(index: Int) -> Currency? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ModelCurrency> = ModelCurrency.fetchRequest()
        
        do {
            let currencyCoreData = try context.fetch(fetchRequest)
            guard !currencyCoreData.isEmpty else {return nil}
            let currency = Currency(
                code: currencyCoreData[index].code as String,
                name: currencyCoreData[index].name as String,
                value: currencyCoreData[index].value as Double,
                nominal: Int(currencyCoreData[index].nominal as Int64),
                isHidden: currencyCoreData[index].isHidden as Bool)
            return currency
        } catch {
            fatalError("\(Constants.errorFetch) \(error)")
        }
    }
    
    func loadSettingsCurrency(currency: [Currency]) -> [Currency] {
        let currencyData = currency.compactMap { currencyMap in
            loadData(index: currency.firstIndex(where: {$0.code == currencyMap.code}) ?? 0) ?? nil
        }
        return currencyData
    }
    
    private func deleteData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ModelCurrency> = ModelCurrency.fetchRequest()
        if let currencyCoreData = try? context.fetch(fetchRequest) {
            for item in currencyCoreData {
                context.delete(item)
            }
        }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
