//
//  Model.swift
//  Ectivi
//
//  Created by Artem Misesin on 11/19/16.
//  Copyright © 2016 Artem Misesin. All rights reserved.
//

import Foundation
import CoreData

class EctiviModel {
    
    var goal = 2000
    
    var context: NSManagedObjectContext? = nil
    
    var history: [(day: String, list: [(time: String, ammount: Int)])] = [("", [])]
    
    var sections: [String] = ["Today", "Yesterday"]
    
    private var counter = 0
    
    var total = 0
    
    var entryAmmount = 0
    
    func addWaterEntry() {
        total += entryAmmount
    }
    
    func insertEntry(ammount: Int, context: NSManagedObjectContext) {
        print(counter)
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: context)
        
        newEntry.setValue(NSDate(), forKey: "time")
        newEntry.setValue(ammount, forKey: "ammount")
        
        do {
            try context.save()
        } catch {
            print("Error while inserting in insertEntry")
        }
        let database = self.getEntries(context: context) as! [NSManagedObject]
        var (day, time) = ("", "")
        if database.endIndex < 1 {
            (day, time) = self.processEntry(entry: database[database.endIndex])
        } else {
            (day, time) = self.processEntry(entry: database[database.endIndex - 1])
        }
        if day == self.history[0].day {
                
            self.history[0].list.insert((time, database[database.endIndex - 1].value(forKey: "ammount") as! Int), at: 0)
                
        } else {
                
            self.history.insert((String(day), []), at: 0)
                
            self.history[0].list.insert((time, database[database.endIndex - 1].value(forKey: "ammount") as! Int), at: 0)
                
        }
        counter += 1
    }
    
    func getEntries(context: NSManagedObjectContext) -> [Any] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0{
                    return results as! [NSManagedObject]
            }
        } catch {
            print("Error while fetching in getEntries")
        }
        return []
    }
    
    func removeEntry(indexPath: IndexPath) {
        print(counter)
        if let context = self.context {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
            request.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    context.delete(results[results.endIndex - indexPath.row - 1] as! NSManagedObject)
                }
            } catch {
                print("Error while deleting in removeEntry")
            }
            do {
                try context.save()
            } catch {
                print("Error while saving the context")
            }
        }
        self.history[indexPath.section].list.remove(at: indexPath.row)
    }
    
    func processEntry(entry: NSManagedObject) -> (day: String, time: String){
        print(counter)
        let date = entry.value(forKey: "time")
        
        //let calendar = NSCalendar.current
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        let day = formatter.string(from: date as! Date)
        
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let time = formatter.string(from: date as! Date)
        
        return (day, time)
    }
    
}
