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
    
    var total = 0
    
    var entryAmmount = 200
    
    func addWaterEntry() {
        let date = NSDate()
        let calendar = NSCalendar.current
        let day = calendar.component(.day, from: date as Date)
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        if history.count >= 1 {
            if String(day) != history[0].day {
                history.insert((String(day), []), at: 0)
            }
        } else {
            history.insert((String(day), []), at: 0)
        }
        history[0].list.insert(("\(hour).\(minutes)", entryAmmount), at: 0)
        total += entryAmmount
    }
    
    func insertEntry(ammount: Int, context: NSManagedObjectContext) {
        
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: context)
        
        newEntry.setValue(NSDate(), forKey: "time")
        newEntry.setValue(ammount, forKey: "ammount")
        
        do {
            try context.save()
        } catch {
            print("Error while inserting in insertEntry")
        }
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
    
    func removeEntry(index: Int) {
        if let context = self.context {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
            request.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    context.delete(results[results.endIndex - index - 1] as! NSManagedObject)
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
    }
    
    func processEntry(entry: NSManagedObject) -> (day: String, time: String){
        let date = entry.value(forKey: "time")
        
        let calendar = NSCalendar.current
        
        let day = "\(calendar.component(.month, from: date as! Date)).\(calendar.component(.day, from: date as! Date)).\(calendar.component(.year, from: date as! Date))"
        
        let time = "\(calendar.component(.hour, from: date as! Date)):\(calendar.component(.minute, from: date as! Date))"
        
        return (day, time)
    }
    
}
