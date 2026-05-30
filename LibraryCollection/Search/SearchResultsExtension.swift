//
//  SearchResultsExtension.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 2/21/23.
//

import Foundation
import SwiftUI
import CoreData
import os

extension Search {
    
    func SearchForUserCriteria() {
        
        resultString.removeAll()
    
        GetAllTitlesByTitle(title: searchString)
        GetAllAuthorsByLastName(authorLastName: searchString)
    }
    
    func GetAllAuthorsByLastName(authorLastName: String) {

        guard !authorLastName.isEmpty else { return }
        
        var fullNameString = ""
        var duplicate: Bool = false

        let _fetchRequestAuthor = NSFetchRequest<Author>(entityName: "Author")
        _fetchRequestAuthor.predicate = NSPredicate(format: "authorLastName CONTAINS[c] %@", authorLastName)
        _fetchRequestAuthor.resultType = NSFetchRequestResultType.managedObjectResultType

        do {
            let author = try moc.fetch(_fetchRequestAuthor)
            if author.count > 0 {
            
                let nameFormatter = NameFormatter()
                for i in 0..<author.count {
                    
                    duplicate = CheckForDuplicates(stringToCheck: author[i].authorId.uuidString)
                    if !duplicate {
                        
                        fullNameString = nameFormatter.ConcatenateNameFields(lastName: author[i].authorLastName,
                                                                             firstName: author[i].wrappedAuthorFirstName,
                                                                             middleName: author[i].wrappedAuthorMiddleName)
                        
                        resultString.append(author[i].authorId.uuidString + "*" + fullNameString)
                        fullNameString = ""
                    }
                }
            }
        }
        catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No fetch from SearchResultsExtension:GetAllAuthorsByLastName. \(error), \(error.localizedDescription)")
        }
    }
    
    func GetAllTitlesByTitle(title: String) {
        
        guard !title.isEmpty else { return }

        self.title = title
        var workingStringTitle: String = ""
        var workingStringAuthor: String = ""
        var duplicate: Bool = false

        //get all the titles matching the search criteria
        let _fetchRequest = NSFetchRequest<Title>(entityName: "Title")
        _fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", title)
        _fetchRequest.resultType = NSFetchRequestResultType.managedObjectResultType

        do {
            let _title = try moc.fetch(_fetchRequest)
            if _title.count > 0 {
                for i in 0..<_title.count {

                    duplicate = CheckForDuplicates(stringToCheck: _title[i].title)
                    if !duplicate {
                        workingStringTitle.append("\(_title[i].title)" + "*" + "\(_title[i].titleId.uuidString)" + "*")
                    }
                              
                    let _fetchTAuthor = NSFetchRequest<TitleAuthor>(entityName: "TitleAuthor")
                    _fetchTAuthor.predicate = NSPredicate(format: "titleId == %@", _title[i].titleId as CVarArg)
                    _fetchTAuthor.resultType = NSFetchRequestResultType.managedObjectResultType

                    do {
                        let _TA = try moc.fetch(_fetchTAuthor)
                        if _TA.count > 0 {
                            for i in 0..<_TA.count {

                                let _author = NSFetchRequest<Author>(entityName: "Author")
                                _author.predicate = NSPredicate(format: "authorId == %@", _TA[i].authorId as CVarArg)
                                _author.resultType = NSFetchRequestResultType.managedObjectResultType
                                
                                if !resultString.contains(_TA[i].authorId.uuidString) {
                                    workingStringAuthor.append("\(_TA[i].authorId.uuidString)" + "*")
                                    
                                    do {
                                        let _authorName = try moc.fetch(_author)
                                        if _authorName.count > 0 {
                                            for i in 0..<_authorName.count {
                                                if !_authorName[i].wrappedAuthorFirstName.isEmpty {
                                                    workingStringAuthor.append("\(_authorName[i].authorLastName), \(_authorName[i].wrappedAuthorFirstName)")
                                                } else {
                                                    workingStringAuthor.append("\(_authorName[i].authorLastName)")
                                                }
                                                if !resultString.contains(workingStringTitle + workingStringAuthor) {
                                                    resultString.append(workingStringTitle + workingStringAuthor)
                                                }
                                                workingStringAuthor = ""
                                                workingStringTitle = ""
                                            }
                                        }
                                    }
                                }
                                workingStringTitle.removeAll()
                                workingStringAuthor.removeAll()
                            }
                        }
                    }
                }
            }
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No fetch from SearchResultsExtension:GetAllTitlesByTitle. \(error), \(error.localizedDescription)")
        }
    }
    
    func CheckForDuplicates(stringToCheck: String) -> Bool {
        
        guard !stringToCheck.isEmpty else { return false }
        var compareString = ""
        
        for i in 0..<resultString.count {
            
            compareString = resultString[i].components(separatedBy: "*")[0]
            
            if stringToCheck == compareString {
                return true
            }
        }
        
        return false
    }
}
