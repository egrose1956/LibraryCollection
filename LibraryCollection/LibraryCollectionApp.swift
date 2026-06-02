//
//  LibraryCollectionApp.swift
//  LibraryCollection
//
//  Created by Elizabeth Rose on 5/30/26.
//

import SwiftUI
import SwiftData

@main
struct LibraryCollectionApp: App {
    
    var sharedModelContainer: ModelContainer = {
        
        let schema = Schema([
            Item.self
        ])
        
        let storeURL = URL.applicationSupportDirectory.appending(path: "DataModel.sqlite")
        let config = ModelConfiguration(schema: schema, url: storeURL, allowsSave: true)
        
        let cloudKitContainer = ModelConfiguration("DataModel.sqlite", cloudKitDatabase: .private("DataModel"))
        
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
    
}
