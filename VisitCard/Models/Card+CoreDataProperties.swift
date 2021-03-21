//
//  Card+CoreDataProperties.swift
//  VisitCard
//
//  Created by Damien DELES on 17/03/2021.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var society: String
    @NSManaged public var fileName: String
    @NSManaged public var id: UUID
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

    convenience init() {
        self.init()
    }
}

extension Card : Identifiable {

}
