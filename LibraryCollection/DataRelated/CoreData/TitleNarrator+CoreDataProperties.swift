//
//  TitleNarrator+CoreDataProperties.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/6/23.
//
//

import Foundation
import CoreData


extension TitleNarrator {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TitleNarrator> {
        return NSFetchRequest<TitleNarrator>(entityName: "TitleNarrator")
    }

    @NSManaged public var titleNarratorId: UUID
    @NSManaged public var titleId: UUID
    @NSManaged public var narratorId: UUID
    @NSManaged public var toTitle: NSSet?
    @NSManaged public var toNarrator: NSSet?

}

// MARK: Generated accessors for toTitle
extension TitleNarrator {

    @objc(addToTitleObject:)
    @NSManaged public func addToToTitle(_ value: Title)

    @objc(removeToTitleObject:)
    @NSManaged public func removeFromToTitle(_ value: Title)

    @objc(addToTitle:)
    @NSManaged public func addToToTitle(_ values: NSSet)

    @objc(removeToTitle:)
    @NSManaged public func removeFromToTitle(_ values: NSSet)

}

// MARK: Generated accessors for toNarrator
extension TitleNarrator {

    @objc(addToNarratorObject:)
    @NSManaged public func addToToNarrator(_ value: Narrator)

    @objc(removeToNarratorObject:)
    @NSManaged public func removeFromToNarrator(_ value: Narrator)

    @objc(addToNarrator:)
    @NSManaged public func addToToNarrator(_ values: NSSet)

    @objc(removeToNarrator:)
    @NSManaged public func removeFromToNarrator(_ values: NSSet)

}

extension TitleNarrator : Identifiable {

}
