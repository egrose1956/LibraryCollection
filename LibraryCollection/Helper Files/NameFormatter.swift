//
//  NameFormatter.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 3/31/23.
//

import Foundation

public struct NameFormatter {
    
    init() {}

    public func ConcatenateNameFields(lastName: String, firstName: String?, middleName: String?) -> String {
        
        guard !lastName.isEmpty else { return ""}
        
        var fullNameString: String
        
        fullNameString = (lastName.trimmingCharacters(in: .whitespacesAndNewlines))
        
        if firstName != nil && firstName != "" {
            fullNameString += (", ") + (firstName!.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        if middleName != nil && middleName != "" {
            fullNameString += " " + (middleName!.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        if fullNameString.trimmingCharacters(in: .whitespaces).count < 2 {
            return ""
        }
        
        return fullNameString
    }
}
 
