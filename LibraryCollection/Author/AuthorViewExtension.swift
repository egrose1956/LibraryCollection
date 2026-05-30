//
//  AuthorExtension.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 1/12/23.
//
import Foundation
import CoreData
import SwiftUI
import os

extension AuthorView {
    
    func PerformValidateAndSave() {
        
        if authorFirstName.isEmpty && authorMiddleName.isEmpty && authorLastName.isEmpty {
            //go back if there isn't any author name entered
            lastNameWarning = true
            return
        }
        
        //check to see if we already have an author by this name
        guard !authorLastName.isEmpty else { return }
        
        authorLastName = authorLastName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if authorLastName.isEmpty || authorLastName.count < 2 {
            lastNameWarning = true
            return
        }
        
        if !authorIdString.isEmpty {
            SaveAuthorEdit()
        } else {
            
            if !authorFirstName.isEmpty {
                CheckForExistingAuthor(lastNameValue: authorLastName, firstNameValue: authorFirstName)
            } else {
                CheckForExistingAuthor(lastNameValue: authorLastName, firstNameValue: "")
            }
            if authorIdString == "" {
                SaveAuthor()
            }
        }
    }
    
    func SaveAuthor() {
        
        do {
            let authors = Author(context: moc)
            
            authors.authorId = UUID()
            
            authors.authorLastName = authorLastName
            
            if authorFirstName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                authors.authorFirstName = authorFirstName.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if authorMiddleName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                authors.authorMiddleName = authorMiddleName.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            authorIdString = authors.authorId.uuidString
            
            if authorIdString.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                try moc.save()
                moc.refreshAllObjects()
                saveIsComplete = true
            }
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No fetch from AddAuthorAndTitleExtension:SaveAuthor. \(error), \(error.localizedDescription)")
        }
    }
    
    func SaveAuthorEdit() {
        
        guard !authorIdString.isEmpty else { return }
        
        do {
            
            let authorId = UUID(uuidString: authorIdString)!
            
            let authorFetch = NSFetchRequest<Author>(entityName: "Author")
            authorFetch.predicate = NSPredicate(format: "authorId == %@", authorId as CVarArg)
            authorFetch.resultType = NSFetchRequestResultType.managedObjectResultType
            authorFetch.fetchLimit = 1
            
            let editAuthor = try moc.fetch(authorFetch)
            if !editAuthor.isEmpty {
                
                if authorLastName != editAuthor[0].authorLastName {
                    editAuthor[0].authorLastName = authorLastName
                }
                
                if authorFirstName != editAuthor[0].authorFirstName {
                    editAuthor[0].authorFirstName = authorFirstName
                }
                                
                editAuthor[0].authorLastName = authorLastName.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if !authorFirstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    editAuthor[0].authorFirstName = authorFirstName.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                
                if !authorMiddleName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    editAuthor[0].authorMiddleName = authorMiddleName.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                
                try moc.save()
                moc.refreshAllObjects()
            }
            
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No fetch from EditAuthorExtension:SaveAuthorEdit. \(error), \(error.localizedDescription)")
            return
        }
        return
    }
    
    func AddTitleAuthorOnly(title: String, author: String) {
        
        guard !title.isEmpty && !titleIdString.isEmpty else { return }
        guard !author.isEmpty else { return }
        
        do {
            let tA = TitleAuthor(context: moc)
            tA.titleAuthorId = UUID()
            tA.titleId = UUID(uuidString: title)!
            tA.authorId = UUID(uuidString: author)!
            
            try moc.save()
            moc.refreshAllObjects()
            //GetAllTitlesByAuthor()
            
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No save at: from AddAuthorAndTitleExtension:AddTitleAuthorOnly. \(error), \(error.localizedDescription)")
        }
    }
    
    func CheckForExistingAuthorOfThisTitle(title: String, existingAuthorLastName: String, existingAuthorFirstName: String) {
        
        var authorID: UUID
        var titleID: UUID
        
        let _fetchRequest = NSFetchRequest<Author>(entityName: "Author")
        if !existingAuthorFirstName.isEmpty {
            _fetchRequest.predicate = NSPredicate(format: "authorLastName CONTAINS[c] %@ AND authorFirstName LIKE[c] %@", existingAuthorLastName, existingAuthorFirstName)
        } else {
            _fetchRequest.predicate = NSPredicate(format: "authorLastName CONTAINS[c] %@", existingAuthorLastName)
        }
        _fetchRequest.resultType = NSFetchRequestResultType.managedObjectResultType
        
        do {
            let _authors = try moc.fetch(_fetchRequest)
            if _authors.count > 0 {
                for i in 0..<_authors.count {
                    authorID = _authors[i].authorId
                    
                    let _fetchRequestTA = NSFetchRequest<TitleAuthor>(entityName: "TitleAuthor")
                    _fetchRequestTA.predicate = NSPredicate(format: "authorId = %@", authorID as CVarArg)
                    _fetchRequestTA.resultType = NSFetchRequestResultType.managedObjectResultType
                    
                    do {
                        let _TA = try moc.fetch(_fetchRequestTA)
                        if _TA.count > 0 {
                            for j in 0..<_TA.count {
                                titleID = _TA[j].titleId
                                
                                let _fetchRequestTitle = NSFetchRequest<Title>(entityName: "Title")
                                _fetchRequestTitle.predicate = NSPredicate(format: "titleId = %@", titleID as CVarArg)
                                _fetchRequestTitle.resultType = NSFetchRequestResultType.managedObjectResultType
                                
                                do {
                                    let _title = try moc.fetch(_fetchRequestTitle)
                                    if _title.count > 0 {
                                        for k in 0..<_title.count {
                                            if _title[k].title == title {
                                                existingTitleIdString = _title[k].titleId.uuidString
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No match found: NewAuthorExtension:CheckForExistingAuthorOfThisTitle. \(error), \(error.localizedDescription)")
        }
    }
    
    func CheckForExistingAuthor(lastNameValue: String, firstNameValue: String) {
        
        let _fetchRequest = NSFetchRequest<Author>(entityName: "Author")
        
        if !firstNameValue.isEmpty {
            _fetchRequest.predicate = NSPredicate(format: "authorLastName CONTAINS[c] %@ AND authorFirstName LIKE[c] %@", lastNameValue, firstNameValue)
        } else {
            _fetchRequest.predicate = NSPredicate(format: "authorLastName CONTAINS[c] %@", lastNameValue)
        }
        _fetchRequest.resultType = NSFetchRequestResultType.managedObjectResultType
        _fetchRequest.fetchLimit = 1
        
        do {
            let _authors = try moc.fetch(_fetchRequest)
            if _authors.count > 0 {
                //author exists
                authorIdString = _authors[0].authorId.uuidString
                return
            }
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No fetch from AuthorExtension:CheckForExistingAuthor. \(error), \(error.localizedDescription)")
            return
        }
        return 
    }
    
    func AddTitleAuthorOnly(titleIdString: String, authorIdString: String) {
        
        guard !titleIdString.isEmpty else { return }
        guard !authorIdString.isEmpty else { return }
        
        do {
            let tA = TitleAuthor(context: moc)
            tA.titleAuthorId = UUID()
            tA.titleId = UUID(uuidString: titleIdString)!
            tA.authorId = UUID(uuidString: authorIdString)!
            
            try moc.save()
            moc.refreshAllObjects()
            
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No save at: from AddCoAuthorExtension:AddTitleAuthorOnly. \(error), \(error.localizedDescription)")
        }
    }
    
    func GetAllTitlesByAuthor(authorIdString: String) {
        
        guard !authorIdString.isEmpty else { return }
        
        moc.refreshAllObjects()
        authorTitles.removeAll()
        
        let _fetchRequest = NSFetchRequest<TitleAuthor>(entityName: "TitleAuthor")
        _fetchRequest.predicate = NSPredicate(format: "authorId == %@", authorIdString)
        _fetchRequest.resultType = NSFetchRequestResultType.managedObjectResultType
        
        do {
            let _ta = try moc.fetch(_fetchRequest)
            for i in (0..<_ta.count) {
                
                let titleId = _ta[i].titleId.uuidString
                
                let _fetchRequestTitle = NSFetchRequest<Title>(entityName: "Title")
                _fetchRequestTitle.predicate = NSPredicate(format: "titleId == %@", titleId as CVarArg)
                _fetchRequestTitle.resultType = NSFetchRequestResultType.managedObjectResultType
                
                let result = try moc.fetch(_fetchRequestTitle)
                for _ in (0..<result.count) {
                    let resultString = result[0].title + "*" + titleId
                    authorTitles.append(resultString)
                }
            }
            
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No fetch from AuthorViewExtension:GetAllTitlesByAuthor(a). \(error), \(error.localizedDescription)")
            
        }
    }
}

