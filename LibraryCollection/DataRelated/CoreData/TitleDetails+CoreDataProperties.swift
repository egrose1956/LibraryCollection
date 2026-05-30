//
//  TitleDetails+CoreDataProperties.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/6/23.
//
//

import Foundation
import CoreData


extension TitleDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TitleDetails> {
        return NSFetchRequest<TitleDetails>(entityName: "TitleDetails")
    }

    @NSManaged public var titleDetailsId: UUID
    @NSManaged public var titleId: UUID
    @NSManaged public var bookType: String
    @NSManaged public var editionNumber: String?
    @NSManaged public var genre: String?
    @NSManaged public var isbn: String?
    @NSManaged public var publishingDate: String?
    @NSManaged public var publishingHouse: String?
    @NSManaged public var toTitle: Title?
    
    public var wrappedEditionNumber: String {
        editionNumber ?? ""
    }
    public var wrappedGenre: String {
        genre ?? ""
    }
    public var wrappedISBN: String {
        isbn ?? ""
    }
    public var wrappedPublishingDate: String {
        publishingDate ?? ""
    }
    public var wrappedPublishingHouse: String {
        publishingHouse ?? ""
    }

}

extension TitleDetails : Identifiable {

}
