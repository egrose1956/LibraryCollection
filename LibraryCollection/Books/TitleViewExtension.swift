//
//  TitleViewExtension.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 3/27/23.
//

import Foundation
import CoreData
import os

extension TitlesView {
        
    func GetAuthorId(filter: String) -> String {
        
        var idString: String = ""
        
        let _fetchId = NSFetchRequest<TitleAuthor>(entityName: "TitleAuthor")
        _fetchId.predicate = NSPredicate(format: "titleId == %@", filter)
        _fetchId.resultType = NSFetchRequestResultType.managedObjectResultType
        _fetchId.fetchLimit = 1
        
        do {
            let id = try moc.fetch(_fetchId)
            if id.count > 0 {
                //specified return of only one record
                idString = id[0].authorId.uuidString
            }
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No fetch from TitleViewExtension:GetAuthorId. \(error), \(error.localizedDescription)")
        }
        
        return idString
    }
    
    func GetAllTitlesByTitle(searchTitle: String) {
        
        resultString.removeAll()
        var workingString: String = ""

        //get all the titles matching the search criteria
        let _fetchRequest = NSFetchRequest<Title>(entityName: "Title")
        _fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", searchTitle)
        _fetchRequest.resultType = NSFetchRequestResultType.managedObjectResultType

        do {
            let _title = try moc.fetch(_fetchRequest)
            if _title.count > 0 {
                for i in 0..<_title.count {
                                       
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
                                
                                do {
                                    let _authorName = try moc.fetch(_author)
                                    if _authorName.count > 0 {
                                        for i in 0..<_authorName.count {
                                            workingString.append("\(_authorName[i].authorLastName), \(_authorName[i].wrappedAuthorFirstName)")
                                            resultString.append(workingString)
                                            workingString.removeAll()
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
            logger.log(level: .error, message: "No fetch from SearchResultsExtension:GetAllTitlesByTitle. \(error), \(error.localizedDescription)")
        }
    }
    
    func DeleteSelectedTitle(titleId: String, authorId: String) {
        
        //includes the join tables TitleAuthor and TitleNarrator
        
        guard !authorId.isEmpty else {return}
        guard !titleId.isEmpty else {return}
        
        //get all the titles matching the search criteria
        let _fetchRequest = NSFetchRequest<TitleAuthor>(entityName: "TitleAuthor")
        _fetchRequest.predicate = NSPredicate(format: "titleId = %@ AND authorId = %@", titleId, authorId)
        _fetchRequest.resultType = NSFetchRequestResultType.managedObjectResultType

        do {
            //remove TitleAuthor records for this Title
            //takes care of Author and Co-Author connections but
            //leaves the author record intackt
            let _titleAuthor = try moc.fetch(_fetchRequest)

            if _titleAuthor.count > 0 {
                for i in (0..<_titleAuthor.count) {
                    moc.delete(_titleAuthor[i])
                }
            }
            
            //do the same thing for the TitleNarrator table
            let _fetchNarrator = NSFetchRequest<TitleNarrator>(entityName: "TitleNarrator")
            _fetchNarrator.predicate = NSPredicate(format: "titleId = %@", titleId)
            _fetchNarrator.resultType = NSFetchRequestResultType.managedObjectResultType
            
            let _narrator = try moc.fetch(_fetchNarrator)
            if _narrator.count > 0 {
                for j in (0..<_narrator.count) {
                    moc.delete(_narrator[j])
                }
            }
             
            //Finally, remove the title itself.
            
            let _fetchTitle = NSFetchRequest<Title>(entityName: "Title")
            _fetchTitle.predicate = NSPredicate(format: "titleId = %@", titleId)
            _fetchTitle.resultType = NSFetchRequestResultType.managedObjectResultType
            _fetchTitle.fetchLimit = 1
            
            let _title = try moc.fetch(_fetchTitle)
            if _title.count > 0 {
                moc.delete(_title[0])
            }
                
            try moc.save()
            
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "Delete Error in TitleViewExtension. \(error), \(error.localizedDescription)")
        }

    }
}
