//
//  ContentViewExtension.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 2/6/23.
//
import Foundation
import CoreData

extension String {
    func containsWhitespaceAndNewlines() -> Bool {
        return rangeOfCharacter(from: .whitespacesAndNewlines) != nil
    }
}

extension String: @retroactive Error {}
extension String: @retroactive LocalizedError {
    public var errorDescription: String? { return self} 
}
