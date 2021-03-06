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
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = managedObjectContext
        
        if context.hasChanges {
            let _ = try? context.save()
        }
    }
    
    func fetchRecordsFor(entity: String) -> [NSManagedObject] {
        // Пример использования запроса созданного из кода
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        var result: [NSManagedObject] = []
        
        if let _records = try? managedObjectContext.fetch(fetchRequest), let records = _records as? [NSManagedObject] {
            result = records
        }
        
        return result
    }
    
    func removeRecordsFor(entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let _ = try? managedObjectContext.execute(deleteRequest)
        
        saveContext()
    }
    
    func createRecordFor(entity: String) -> NSManagedObject? {
        var result: NSManagedObject?
        
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: managedObjectContext)
        
        if let entityDescription = entityDescription {
            result = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
        }
        
        saveContext()
        
        return result
    }
    
    lazy var applicationDocumentsDirectory: URL? = {
        // Каталог, который приложение использует для хранения файла Core Data.
        // Этот код использует каталог Documents в каталоге Application Support.
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return urls.last
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // Модель управляемого объекта для приложения .
        // Это свойство является необязательным. Если приложение не сможет
        // найти и загрузить эту модель , то возникнет фатальная ошибка .
        
        // TODO: можно ли здесь вместое "NewsList" использовать R
        let modelURL = Bundle.main.url(forResource: "NewsList", withExtension: "momd")
        
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // Диспетчер хранилища для приложения. Эта реализация создает
        // и возвращает диспетчер при условии, что хранилище уже связано
        // с приложением. Это свойство является необязательным, поскольку существуют формальные условия , при которых создание
        // хранилища невозможно.
        // Создаем инспектор и хранилище
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = applicationDocumentsDirectory?.appendingPathComponent("SingleViewCoreData.sqlite")
        
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Сообщение об ошибке.
            var dict = [String: Any]()
            
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error as NSError
            
            let wrappedError = NSError(domain: "YOUR_ERROR DOМAIN", code: 9999, userInfo: dict)
            
            // Замените эту реализацию кодом для обработки ошибок .
            // Функция abort() вынуждает приложение создать аварийную запись
            // и прекратить работу. В реальных приложениях эту функцию
            // использовать не следует, она нужна только на период разработки.
            
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Возвращает контекст управляемого объекта для приложения,
        // который уже связан с диспетчером постоянного хранилища .
        // Это свойство является необязательным, поскольку
        // существуют формальные условия, при которых создание
        // контекста невозможно.
        let coordinator = persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = coordinator
        
        return managedObjectContext
    }()
    
    private init() {}
    
    private var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
}
