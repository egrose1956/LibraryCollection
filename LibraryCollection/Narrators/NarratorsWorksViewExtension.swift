//
//  NarratorsWorksViewExtension.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/16/24.
//

import CoreData
import Foundation
import os

extension NarratorsWorksView {
    
    func GetAllTitlesByNarrator(narratorIdString: String) {
        
        guard !narratorIdString.isEmpty else { return }
        
        moc.refreshAllObjects()
        narratorTitles.removeAll()
        
        let _fetchRequest = NSFetchRequest<TitleNarrator>(entityName: "TitleNarrator")
        _fetchRequest.predicate = NSPredicate(format: "narratorId == %@", narratorIdString)
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
}
