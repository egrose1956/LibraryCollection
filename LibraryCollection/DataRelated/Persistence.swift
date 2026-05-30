/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A class that sets up the Core Data stack.
*/
import Foundation
import CoreData

class PersistenceController {
    
    static let shared = PersistenceController()
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
                        
        let container = NSPersistentCloudKitContainer(name: "DataModel")

        // Create a store description for a CloudKit-backed local store
        let cloudStoreLocation = URL(fileURLWithPath: "Bundle.main.applicationSupportDirectory")
        let cloudStoreDescription = NSPersistentStoreDescription(url: cloudStoreLocation)
        cloudStoreDescription.configuration = "Default"
        cloudStoreDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.RiverThree.LibraryCollection")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        })

        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.undoManager = nil
        
#if DEBUG
        print(container.persistentStoreDescriptions[0].url?.absoluteURL.path.removingPercentEncoding as Any)
#endif

        return container
        
    }()
    
    func save() {
        
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
                context.refreshAllObjects()
            } catch {
                print("Error on saving the moc context in PersistenceController")
            }
        }
    }
}
