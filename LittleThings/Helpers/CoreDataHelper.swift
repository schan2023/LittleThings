//
//  CoreDataHelper.swift
//  LittleThings
//
//  Created by Simone Chan on 7/23/18.
//  Copyright © 2018 Simone Chan. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    //Creating event as NSObject
    static func newEvent() -> Event {
        let event = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context) as! Event
        
        return event
    }
    
    //Saving event
    static func saveEvent() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    //Retrieve events
    static func retrieveEvents() -> [Event] {
        do {
            //Retrieves core data and sorts it by date
            let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
            let results = try context.fetch(fetchRequest)
            return results
        }
        catch let error {
            print("Could not fetch results")
            return []
        }
    }

}
