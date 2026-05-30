//
//  Title+CoreDataProperties.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/6/23.
//
//

import Foundation
import CoreData


extension Title {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Title> {
        return NSFetchRequest<Title>(entityName: "Title")
    }

    @NSManaged public var titleId: UUID
    @NSManaged public var title: String
    @NSManaged public var toTitleAuthor: NSSet?
    @NSManaged public var toTitleNarrator: NSSet?
    @NSManaged public var toDetails: TitleDetails?

}

// MARK: Generated accessors for toTitleAuthor
extension Title {

    @objc(addToTitleAuthorObject:)
    @NSManaged public func addToToTitleAuthor(_ value: TitleAuthor)

    @objc(removeToTitleAuthorObject:)
    @NSManaged public func removeFromToTitleAuthor(_ value: TitleAuthor)

    @objc(addToTitleAuthor:)
    @NSManaged public func addToToTitleAuthor(_ values: NSSet)

    @objc(removeToTitleAuthor:)
    @NSManaged public func removeFromToTitleAuthor(_ values: NSSet)

}

// MARK: Generated accessors for toTitleNarrator
extension Title {

    @objc(addToTitleNarratorObject:)
    @NSManaged public func addToToTitleNarrator(_ value: TitleNarrator)

    @objc(removeToTitleNarratorObject:)
    @NSManaged public func removeFromToTitleNarrator(_ value: TitleNarrator)

    @objc(addToTitleNarrator:)
    @NSManaged public func addToToTitleNarrator(_ values: NSSet)

    @objc(removeToTitleNarrator:)
    @NSManaged public func removeFromToTitleNarrator(_ values: NSSet)

}

extension Title : Identifiable {

}
