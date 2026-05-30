//
//  NarratorViewExtension.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 4/8/23.
//

import Foundation
import CoreData
import os

extension NarratorView {
    
    func GetAllNarratorsForTitle() {
        
        guard !titleIdString.isEmpty else { return }
        
        let nameFormatter = NameFormatter()
        filteredNarrators.removeAll()
        
        let _fetchTN = NSFetchRequest<TitleNarrator>(entityName: "TitleNarrator")
        _fetchTN.predicate = NSPredicate(format: "titleId = %@", UUID(uuidString: titleIdString)! as CVarArg)
        _fetchTN.resultType = NSFetchRequestResultType.managedObjectResultType
        
        do {
            let _TN = try moc.fetch(_fetchTN)
            if _TN.count > 0 {
                for i in 0..<_TN.count {
                    
                    let _fetchNarrator = NSFetchRequest<Narrator>(entityName: "Narrator")
                    _fetchNarrator.predicate = NSPredicate(format: "narratorId = %@", _TN[i].narratorId.uuidString)
                    _fetchNarrator.resultType = NSFetchRequestResultType.managedObjectResultType
                    
                    do{
                        var returnName: String = ""
                        
                        let _narr = try moc.fetch(_fetchNarrator)
                        if _narr.count > 0 {
                            for i in 0..<_narr.count {
                                returnName = nameFormatter.ConcatenateNameFields(lastName: _narr[i].narratorLastName,
                                                                                 firstName: _narr[i].wrappedNarratorFirstName,
                                                                                 middleName: _narr[i].wrappedNarratorMiddleName)
                                returnName = returnName + "#" + String(i)
                                filteredNarrators.append(returnName)
                            }
                        }
                    }
                }
            }
            
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No fetch from NarratorViewExtension:GetAllNarratorsForTitle. \(error), \(error.localizedDescription)")
        }
    }
    
    func CheckForExistingNarrator(narratorLastNameValue: String, narratorFirstNameValue: String) {
        
        guard !narratorLastNameValue.isEmpty else { return }
        
        let _fetchNarrator = NSFetchRequest<Narrator>(entityName: "Narrator")
        if !narratorFirstNameValue.isEmpty {
            _fetchNarrator.predicate =
            NSPredicate(format: "narratorLastName CONTAINS[c] %@ AND narratorFirstName CONTAINS[c] %@",
                        narratorLastNameValue, narratorFirstNameValue)
        } else {
            _fetchNarrator.predicate =
            NSPredicate(format: "narratorLastName CONTAINS[c] %@", narratorLastNameValue)
        }
        _fetchNarrator.resultType = NSFetchRequestResultType.managedObjectResultType
        _fetchNarrator.fetchLimit = 1
        
        do {
            let _narrator = try moc.fetch(_fetchNarrator)
            if _narrator.count > 0 {
                
                foundNarratorLastName = "\(_narrator[0].narratorLastName)"
                foundNarratorFirstName = _narrator[0].wrappedNarratorFirstName
                narratorIdString = _narrator[0].narratorId.uuidString
                
            }
            return
            
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No fetch from NarratorViewExtension:CheckForExistingNarrator. \(error), \(error.localizedDescription)")
            return
        }
    }
    
    func CheckForExistingTitleNarratorRecord(narratorIdString: String, titleIdString: String) {
        
        guard !narratorIdString.isEmpty else { return }
        guard !titleIdString.isEmpty else { return }
        
        let _fetchRecord = NSFetchRequest<TitleNarrator>(entityName: "TitleNarrator")
        
        _fetchRecord.predicate =
        NSPredicate(format: "narratorId == %@ AND titleId == %@",
                    narratorIdString, titleIdString)
        
        _fetchRecord.resultType = NSFetchRequestResultType.managedObjectResultType
        _fetchRecord.fetchLimit = 1
        
        do {
        
            let _narrator = try moc.fetch(_fetchRecord)
            if _narrator.count < 1 {
                
                //need to add a titleNarrator
                AddTitleNarratorRecord(titleIdString: titleIdString)
            }
            
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "Error in fetch from NarratorViewExtension:CheckForExistingTitleNarratorRecord. \(error), \(error.localizedDescription)")
        }
    }
    
    func ValidateNarratorAndSave() {
        
        CheckForExistingNarrator(narratorLastNameValue: narratorLastName, narratorFirstNameValue: narratorFirstName)
        
        if narratorIdString.isEmpty {
            
            //no narrator by this name and no passed in title
            //so just save the narrator
            AddNarrator()
            AddTitleNarratorRecord(titleIdString: titleIdString)
            
        } else {
            
            //check for existing title/narrator record so as not to duplicate.
            CheckForExistingTitleNarratorRecord(narratorIdString: narratorIdString, titleIdString: titleIdString)
            
            EditNarrator()
            
        }
    }
        
    func AddNarrator() {
   
        let narrator = Narrator(context: moc)
        
        narrator.narratorId = UUID()
        
        narrator.narratorLastName = narratorLastName
        
        if narratorFirstName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            narrator.narratorFirstName = narratorFirstName
        }
        if narratorMiddleName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            narrator.narratorMiddleName = narratorMiddleName
        }
        
        narratorIdString = narrator.narratorId.uuidString
        
        do {
            
            try moc.save()
            moc.refreshAllObjects()
            
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "Save Error from NarratorViewExtension:AddNarrator. \(error), \(error.localizedDescription)")
        }
    }
    
    func EditNarrator() {
        
        guard !narratorIdString.isEmpty else { return }
   
        let narratorId = UUID(uuidString: narratorIdString)!
        
        let narratorFetch = NSFetchRequest<Narrator>(entityName: "Narrator")
        narratorFetch.predicate = NSPredicate(format: "narratorId == %@", narratorId as CVarArg)
        narratorFetch.resultType = NSFetchRequestResultType.managedObjectResultType
        narratorFetch.fetchLimit = 1
        
        do {
            
            let editNarrator = try moc.fetch(narratorFetch)
            if !editNarrator.isEmpty {
                
                editNarrator[0].narratorLastName = narratorLastName.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if !narratorFirstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    editNarrator[0].narratorFirstName = narratorFirstName
                }
                if !narratorMiddleName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    editNarrator[0].narratorMiddleName = narratorMiddleName
                }
            }
            
            try moc.save()
            moc.refreshAllObjects()
            
        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "Save failed from NarratorViewExtension:EditNarrator. \(error), \(error.localizedDescription)")
        }
    }
    
    func AddTitleNarratorRecord(titleIdString: String) {
        
        guard !titleIdString.isEmpty else { return }
        guard !narratorIdString.isEmpty else {return }
        
        let titleNarrator = TitleNarrator(context: moc)
        
        let titleID: UUID = UUID(uuidString: titleIdString)!
        let narratorID: UUID = UUID(uuidString: narratorIdString)!
        
        titleNarrator.titleNarratorId = UUID()
        titleNarrator.titleId = titleID
        titleNarrator.narratorId = narratorID
        
        do {
            try moc.save()
            moc.refreshAllObjects()

        } catch let error as NSError {
            let logger = appLogger()
            logger.log(level: .error, message: "No fetch from NarratorViewExtension:AddTitleNarratorRecord. \(error), \(error.localizedDescription)")
        }
    }
}
