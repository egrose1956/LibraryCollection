//
//  Author+CoreDataProperties.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/6/23.
//
//

import Foundation
import CoreData


extension Author {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Author> {
        return NSFetchRequest<Author>(entityName: "Author")
    }

    @NSManaged public var authorId: UUID
    @NSManaged public var authorLastName: String
    @NSManaged public var authorFirstName: String?
    @NSManaged public var authorMiddleName: String?
    @NSManaged public var toTitleAuthor: NSSet?
    
    public var wrappedAuthorFirstName: String {
        authorFirstName ?? ""
    }
    public var wrappedAuthorMiddleName: String {
        authorMiddleName ?? ""
    }

}

// MARK: Generated accessors for toTitleAuthor
extension Author {

    @objc(addToTitleAuthorObject:)
    @NSManaged public func addToToTitleAuthor(_ value: TitleAuthor)

    @objc(removeToTitleAuthorObject:)
    @NSManaged public func removeFromToTitleAuthor(_ value: TitleAuthor)

    @objc(addToTitleAuthor:)
    @NSManaged public func addToToTitleAuthor(_ values: NSSet)

    @objc(removeToTitleAuthor:)
    @NSManaged public func removeFromToTitleAuthor(_ values: NSSet)

}

extension Author : Identifiable {

}
