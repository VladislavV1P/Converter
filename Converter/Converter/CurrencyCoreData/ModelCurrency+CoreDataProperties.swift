//
//  ModelCurrency+CoreDataProperties.swift
//  Converter
//
//  Created by Владислав Патраков on 13.04.2022.
//
//

import Foundation
import CoreData


extension ModelCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ModelCurrency> {
        return NSFetchRequest<ModelCurrency>(entityName: "ModelCurrency")
    }

    @NSManaged public var code: String
    @NSManaged public var name: String
    @NSManaged public var value: Double
    @NSManaged public var nominal: Int64
    @NSManaged public var isHidden: Bool
    @NSManaged public var currency: Currencies?
}

extension ModelCurrency : Identifiable {

}
