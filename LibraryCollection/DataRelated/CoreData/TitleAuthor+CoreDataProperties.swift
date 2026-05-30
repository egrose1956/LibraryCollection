//
//  TitleAuthor+CoreDataProperties.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/6/23.
//
//

import Foundation
import CoreData


extension TitleAuthor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TitleAuthor> {
        return NSFetchRequest<TitleAuthor>(entityName: "TitleAuthor")
    }

    @NSManaged public var titleAuthorId: UUID
    @NSManaged public var titleId: UUID
    @NSManaged public var authorId: UUID
    @NSManaged public var toAuthor: NSSet?
    @NSManaged public var toTitle: NSSet?

}

// MARK: Generated accessors for toAuthor
extension TitleAuthor {

    @objc(addToAuthorObject:)
    @NSManaged public func addToToAuthor(_ value: Author)

    @objc(removeToAuthorObject:)
    @NSManaged public func removeFromToAuthor(_ value: Author)

    @objc(addToAuthor:)
    @NSManaged public func addToToAuthor(_ values: NSSet)

    @objc(removeToAuthor:)
    @NSManaged public func removeFromToAuthor(_ values: NSSet)

}

// MARK: Generated accessors for toTitle
extension TitleAuthor {

    @objc(addToTitleObject:)
    @NSManaged public func addToToTitle(_ value: Title)

    @objc(removeToTitleObject:)
    @NSManaged public func removeFromToTitle(_ value: Title)

    @objc(addToTitle:)
    @NSManaged public func addToToTitle(_ values: NSSet)

    @objc(removeToTitle:)
    @NSManaged public func removeFromToTitle(_ values: NSSet)

}

extension TitleAuthor : Identifiable {

}
