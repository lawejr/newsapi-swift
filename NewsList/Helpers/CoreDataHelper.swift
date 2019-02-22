//
//  CoreDataHelper.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 22/02/2019.
//  Copyright © 2019 Aleksandr Kalinin. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    private var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    private var context: NSManagedObjectContext {
        get {
            return appDelegate.managedObjectContext
        }
    }
    
    func saveChanges() {
        appDelegate.saveContext()
    }
    
    func fetchRecordsFor(entity: String) -> [NSManagedObject] {
        // Пример использования запроса созданного из кода
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        var result: [NSManagedObject] = []
        
        do {
            let records = try context.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
        } catch {
            print(error)
        }
        
        return result
    }
    
    func removeRecordsFor(entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
        
        appDelegate.saveContext()
    }
    
    func createRecordFor(entity: String) -> NSManagedObject? {
        var result: NSManagedObject?
        
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: context)
        
        if let entityDescription = entityDescription {
            result = NSManagedObject(entity: entityDescription, insertInto: context)
        }
        
        appDelegate.saveContext()
        
        return result
    }
    
}
