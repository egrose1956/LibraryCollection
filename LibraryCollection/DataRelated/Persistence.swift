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
                        
        let container = NSPersistentCloudKitContainer(name: "DataModel", managedObjectModel: self.persistentContainer.managedObjectModel)
        
        // Main context for UI operations (runs on main thread)
        var viewContext: NSManagedObjectContext {
            container.viewContext
        }
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.undoManager = nil

        // Create a store description for a CloudKit-backed local store
        let cloudStoreLocation = URL(fileURLWithPath: "Bundle.main.applicationSupportDirectory")
        let cloudStoreDescription = NSPersistentStoreDescription(url: cloudStoreLocation)
        
        cloudStoreDescription.configuration = "Default"
        cloudStoreDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.RiverThree.LC")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        })

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
