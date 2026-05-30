//
//  Narrator+CoreDataProperties.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/6/23.
//
//

import Foundation
import CoreData


extension Narrator {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Narrator> {
        return NSFetchRequest<Narrator>(entityName: "Narrator")
    }

    @NSManaged public var narratorId: UUID
    @NSManaged public var narratorLastName: String
    @NSManaged public var narratorFirstName: String?
    @NSManaged public var narratorMiddleName: String?
    @NSManaged public var toTitleNarrator: NSSet?
    
    public var wrappedNarratorFirstName: String {
        narratorFirstName ?? ""
    }
    public var wrappedNarratorMiddleName: String {
        narratorMiddleName ?? ""
    }

}

// MARK: Generated accessors for toTitleNarrator
extension Narrator {

    @objc(addToTitleNarratorObject:)
    @NSManaged public func addToToTitleNarrator(_ value: TitleNarrator)

    @objc(removeToTitleNarratorObject:)
    @NSManaged public func removeFromToTitleNarrator(_ value: TitleNarrator)

    @objc(addToTitleNarrator:)
    @NSManaged public func addToToTitleNarrator(_ values: NSSet)

    @objc(removeToTitleNarrator:)
    @NSManaged public func removeFromToTitleNarrator(_ values: NSSet)

}

extension Narrator : Identifiable {

}
