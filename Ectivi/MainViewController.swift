//
//  ViewController.swift
//  Ectivi
//
//  Created by Artem Misesin on 10/16/16.
//  Copyright © 2016 Artem Misesin. All rights reserved.
//

import UIKit
import CoreData

@IBDesignable
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var model: EctiviModel = EctiviModel()
    
    var context: NSManagedObjectContext? = nil
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var mainIndicator: UILabel!
    
    @IBOutlet weak var goalLabel: UILabel!
    
    @IBOutlet weak var historyPreview: UITableView!
    @IBAction func historyButton() {
        performSegue(withIdentifier: "toHistory", sender: self)
    }

    @IBAction func addBytton(_ sender: UIButton) {
        model.addWaterEntry()
        if let tempContext = self.context {
            model.insertEntry(ammount: 200, context: tempContext)
        }
        startConfiguration()
        historyPreview.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !model.history.isEmpty {
            return model.history[section].list.count
        }
        return 0
    }
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! CustomTableViewCell
        // Configure the cell
        if model.history.count != 0 {
            
            entry.time.text = model.history[0].list[indexPath.row].time
            entry.ammount.text = String(model.history[0].list[indexPath.row].ammount) + " ml"
        }
        entry
            .backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
        return entry
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        let database = model.getEntries(context: self.context!) as! [NSManagedObject]
        for entry in database {
            let date = entry.value(forKey: "time")
            let calendar = NSCalendar.current
            let day = calendar.component(.day, from: date as! Date)
            let hour = calendar.component(.hour, from: date as! Date)
            let minutes = calendar.component(.minute, from: date as! Date)
            let string = "\(hour):\(minutes)"
            if String(day) == model.history[0].day {
                model.history[0].list.insert((string, entry.value(forKey: "ammount") as! Int), at: 0)
            } else {
            model.history.insert((String(day), []), at: 0)
                model.history[0].list.insert((string, entry.value(forKey: "ammount") as! Int), at: 0)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
        UINavigationBar.appearance().tintColor = UIColor(red: 0.49, green: 0.62, blue: 0.96, alpha: 1)
        historyPreview.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
        mainView.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
        addButton.backgroundColor = UIColor(red: 0.49, green: 0.62, blue: 0.96, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.model.history[indexPath.section].list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if self.model.history[indexPath.section].list.isEmpty {
                self.model.history.remove(at: indexPath.section)
            }
            self.startConfiguration()
        }
        
        delete.backgroundColor = UIColor(red: 0.49, green: 0.62, blue: 0.96, alpha: 1)
        
        return [delete]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        startConfiguration()
        historyPreview.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func startConfiguration() {
        var totalTemp = 0
        if model.history.count != 0 {
            for (_, entryAmmount) in model.history[0].list {
                
                totalTemp += entryAmmount
            }
        }
        model.total = totalTemp
        mainIndicator.text = "\(model.total) ml"
        if model.goal <= model.total {
            goalLabel.text = "You're good for today. \n Well done"
        } else {
            goalLabel.text = "\(model.goal - model.total) ml to go"
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHistory" {
            let history = segue.destination as? HistoryViewController
            history?.model = self.model
        }
    }


}

