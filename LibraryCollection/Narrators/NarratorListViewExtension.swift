//
//  NarratorListViewExtension.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/10/24.
//

import Foundation
import CoreData
import os

extension NarratorListView {
    
    func NarratorFilteredForTitle() {
        
        guard !titleIdString.isEmpty else { return }
        guard !narratorIdString.isEmpty else { return }
        narratorTitles.removeAll()
        
        let id = UUID(uuidString: narratorIdString)!
        
        let _fetchRequest = NSFetchRequest<TitleNarrator>(entityName: "TitleNarrator")
        _fetchRequest.predicate = NSPredicate(format: "narratorId == %@", id as CVarArg)
        _fetchRequest.resultType = NSFetchRequestResultType.managedObjectResultType
        
        do {
            let _tn = try moc.fetch(_fetchRequest)
            for i in (0..<_tn.count) {

                let titleId = _tn[i].titleId.uuidString
                
                let _fetchRequestTitle = NSFetchRequest<Title>(entityName: "Title")
                _fetchRequestTitle.predicate = NSPredicate(format: "titleId == %@", titleId as CVarArg)
                _fetchRequestTitle.resultType = NSFetchRequestResultType.managedObjectResultType
                
                let result = try moc.fetch(_fetchRequestTitle)
                for _ in (0..<result.count) {
                    let resultString = result[0].title + "*" + titleId
                    narratorTitles.append(resultString)
                }
            }
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No fetch from NarratorsWorksViewExtension:GetAllTitlesByNarrators. \(error), \(error.localizedDescription)")
        }
    }
    
    
    func deleteNarratorRecord() {
        
        /***
            still unsure if this is necessary or desirable
         ***/
//        //This begins the process and needs to have a clear array
//        if !titleIdArray.isEmpty {
//            titleIdArray.removeAll()
//        }
//        
//        //to cascade the author's deletion, the TitleAuthor table should have it's
//        //corresponding records removed
//        guard !authorIdString.isEmpty else { return }
//        
//        do {
//            
//            let authorId: UUID = UUID(uuidString: authorIdString)!
//            
//            let titleAuthorFetch = NSFetchRequest<TitleAuthor>(entityName: "TitleAuthor")
//            titleAuthorFetch.predicate = NSPredicate(format: "authorId == %@", authorId as CVarArg)
//            titleAuthorFetch.resultType = NSFetchRequestResultType.managedObjectResultType
//            
//            let titleAuthorDelete = try moc.fetch(titleAuthorFetch)
//            
//            if titleAuthorDelete.count > 0 {
//                for i in 0..<titleAuthorDelete.count {
//                    titleIdArray.append(titleAuthorDelete[i].titleId.uuidString)
//                    moc.delete(titleAuthorDelete[i])
//                }
//            }
//            
//            let authorRecordFetch = NSFetchRequest<Author>(entityName: "Author")
//            authorRecordFetch.predicate = NSPredicate(format: "authorId == %@", authorId as CVarArg)
//            authorRecordFetch.resultType = NSFetchRequestResultType.managedObjectResultType
//            authorRecordFetch.fetchLimit = 1
//            
//            let authorToDelete = try moc.fetch(authorRecordFetch)
//            if !authorToDelete.isEmpty {
//                moc.delete(authorToDelete[0])
//            }
//            
//            try moc.save()
//            moc.refreshAllObjects()
//            
//        } catch let error as NSError {
//            let logger = appLogger()
//            logger.log(level: .error, message: "TitleAuthorAndAuthorDelete error in AuthorsViewExtension. \(error), \(error.localizedDescription)")
//        }
    }
    
    /*  //may not need this functionality aas it might delete a narrator for other titles
     
        func deleteNarratorforTitle() {
            
            guard !narratorIdArray.isEmpty else { return }
            
            do {
                
                for i in 0..<narratorIdArray.count {
                    // get the narratorIds on record for all the titleIds
                    //loop through and add narratorIds to a narrator array
                    // then use that for deleting narrator in deleteNarratorforTitle()
                    
                    let narratorRecordFetch = NSFetchRequest<Narrator>(entityName: "Narrator")
                    narratorRecordFetch.predicate = NSPredicate(format: "titleId == %@", titleIdArray[i] as CVarArg)
                    narratorRecordFetch.resultType = NSFetchRequestResultType.managedObjectResultType
                    narratorRecordFetch.fetchLimit = 1
                    
                    let narratorToDelete = try moc.fetch(narratorRecordFetch)
                    if !narratorToDelete.isEmpty {
                        moc.delete(narratorToDelete[0])
                    }
                }
                
                try moc.save()
                
                
            } catch let error as NSError {
                let logger = appLogger()
                logger.log(level: .error, message: "Narrator Delete error in AuthorsViewExtension. \(error), \(error.localizedDescription)")
            }
        }
     */
}
