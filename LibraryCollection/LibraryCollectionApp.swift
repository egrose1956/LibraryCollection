//
//  LibraryCollectionApp.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 5/30/26.
//

import SwiftUI
import CoreData

@main
struct LibraryCollectionApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(filter: .authors)
                .environment(\.managedObjectContext,
                              persistenceController.persistentContainer.viewContext)
        }
    }
/*
    var sharedModelContainer: ModelContainer = {
        
        let schema = Schema([
            Item.self
        ])
        
        //define the path for the local installation
        let storeURL = URL.applicationSupportDirectory.appending(path: "DataModel.sqlite")
        
        //define two configurations - one for the local store and one for the cloudKit
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, allowsSave: true)

        let cloudKitContainer = ModelConfiguration("DataModel.sqlite", cloudKitDatabase: .private("DataModel"))
        
        //now try to construct or open them here
        do {
            return try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        do {
            return try ModelContainer(for: schema, configurations: cloudKitContainer)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
 */
    
}
