//
//  AuthorsWorksViewExtension.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/2/23.
//

import Foundation
import CoreData
import os

extension AuthorsWorksView {
    
    func GetAllTitlesByAuthor(authorIdString: String) {
        
        guard !authorIdString.isEmpty else { return }
        
        moc.refreshAllObjects()
        filteredTitles.removeAll()
        
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
                    filteredTitles.append(resultString)
                }
            }
            
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No fetch from AuthorsWorksViewExtension:GetAllTitlesByAuthor(a). \(error), \(error.localizedDescription)")
            
        }
    }
}
