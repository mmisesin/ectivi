//
//  ViewController.swift
//  Ectivi
//
//  Created by Artem Misesin on 10/16/16.
//  Copyright © 2016 Artem Misesin. All rights reserved.
//

import UIKit
import CoreData

class Glass: IDrinkable{
    var model: EctiviModel = EctiviModel()
    func changeAmmount() {
        model.entryAmmount = 400
    }
}

class Cup: IDrinkable{
    var model: EctiviModel = EctiviModel()
    func changeAmmount() {
        model.entryAmmount = 200
    }
}

class Bottle: IDrinkable{
    var model: EctiviModel = EctiviModel()
    func changeAmmount() {
        model.entryAmmount = 800
    }
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var drinkable: IDrinkable = IDrinkable()
    
    var model: EctiviModel = EctiviModel()
    
    @IBOutlet weak var circle: DiagramCircleView! {
        didSet {
            circle.ammount = model.total
        }
    }
    
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var mainIndicator: UILabel!
    @IBOutlet weak var goalDone: UILabel!
    
    @IBOutlet weak var goalLabel: UILabel!
    
    @IBOutlet weak var historyPreview: UITableView!
    
    @IBAction func entryButton() {
        model.entryAmmount = 200
        model.addWaterEntry()
        
        if let context = model.context {
            
            model.insertEntry(ammount: model.entryAmmount, context: context)
            
        }
        startConfiguration()
        historyPreview.reloadData()
        if model.history.count == 2 && model.history[0].list.count == 1 {
            slide(button: addButton, direction: "Down")
            fade(table: historyPreview, direction: "In")
        }
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
        let longpressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longpress(gestureRecognizer:)))
        
        longpressGestureRecognizer.minimumPressDuration = 1
        
    addButton.addGestureRecognizer(longpressGestureRecognizer)
        circle.ammount = model.total
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        model.context = appDelegate.persistentContainer.viewContext
        
        if let context = model.context {
            
            let database = model.getEntries(context: context) as! [NSManagedObject]
            
            for entry in database {
                
                let (day, time) = model.processEntry(entry: entry)
                
                if day == model.history[0].day {
                    
                    model.history[0].list.insert((time, entry.value(forKey: "ammount") as! Int), at: 0)
                    
                } else {
                    
                    model.history.insert((String(day), []), at: 0)
                    
                    model.history[0].list.insert((time, entry.value(forKey: "ammount") as! Int), at: 0)
                    
                }
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
        UINavigationBar.appearance().tintColor = UIColor(red: 0.49, green: 0.62, blue: 0.96, alpha: 1)
        historyPreview.backgroundColor = UIColor.white
        mainView.backgroundColor = UIColor.white
        addButton.backgroundColor = UIColor(red: 0.49, green: 0.62, blue: 0.96, alpha: 1)
        checkEmpty()
        self.historyPreview.tableFooterView = UIView()
        self.view.sendSubview(toBack: self.historyPreview)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            self.model.removeEntry(indexPath: indexPath)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if self.model.history[indexPath.section].list.isEmpty {
                
                self.model.history.remove(at: indexPath.section)
                
            }
            
            if self.model.history.count == 1 {
                self.fade(table: self.historyPreview, direction: "Out")
                self.slide(button: self.addButton, direction: "Up")
            }
            
            self.startConfiguration()
            self.checkEmpty()
            self.historyPreview.reloadData()
        }
        
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
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        _ = NSDate()
        
        //let today = formatter.string(from: currentDate as Date)
        
        var totalTemp = 0
        if model.history.count != 0 && !model.history[0].list.isEmpty {
            for (_, entryAmmount) in model.history[0].list {
            totalTemp += entryAmmount
            }
        }
        model.total = totalTemp
        mainIndicator.text = "\(model.total) ml"
        if model.goal <= model.total {
            goalLabel.isHidden = true
            mainIndicator.isHidden = true
            goalDone.isHidden = false
            self.addButton.isEnabled = false
            self.addButton.alpha = 0.5
        } else {
            self.addButton.isEnabled = true
            self.addButton.alpha = 1
            mainIndicator.isHidden = false
            goalLabel.isHidden = false
            goalLabel.text = "\(model.goal - model.total) ml to go"
            goalDone.isHidden = true
        }
        if model.history.count == 1 {
            addButton.center.y -= 159
            historyPreview.alpha = 0
            buttonConstraint.constant = 191
        } else {
            historyPreview.alpha = 1
            buttonConstraint.constant = 32
        }
        circle.ammount = model.total
        checkEmpty()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHistory" {
            let history = segue.destination as? HistoryViewController
            history?.model = self.model
        }
    }
    
    func slide(button: UIButton, direction: String) {
        switch direction {
        case "Up":
            UIView.animate(withDuration: 1, animations: {
                button.center.y -= 159
            })
            buttonConstraint.constant = 191
        case "Down":
            UIView.animate(withDuration: 1, animations: {
                button.center.y += 159
            })
            buttonConstraint.constant = 32
        default: break
        }
    }
    
    func fade(table: UITableView, direction: String) {
        switch direction {
//        case "Out":
//            table.alpha = 1
//            UIView.animate(withDuration: 0.3, animations: {
//                table.alpha = 0
//        })
        case "In":
            table.alpha = 0
            UIView.animate(withDuration: 1.5, animations: {
                table.alpha = 1
        })
        default: break
        }
    }
    
    func checkEmpty() {
        if model.history.count > 1 {
            self.historyPreview.separatorStyle = .singleLine
        } else {
            self.historyPreview.separatorStyle = .none
        }
    }
    
    func longpress(gestureRecognizer: UIGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let firstNumber = UIAlertAction(title: "Drink 400ml", style: .default) { (action) in
            self.model.entryAmmount = 400
            self.model.addWaterEntry()
            
            if let context = self.model.context {
                
                self.model.insertEntry(ammount: self.model.entryAmmount, context: context)
                
            }
            self.startConfiguration()
            self.historyPreview.reloadData()
            if self.model.history.count == 2 && self.model.history[0].list.count == 1 {
                self.slide(button: self.addButton, direction: "Down")
                self.fade(table: self.historyPreview, direction: "In")
            }
        }
        alertController.addAction(firstNumber)
        
        let secondNumber = UIAlertAction(title: "Drink 800ml", style: .default) { (action) in
            self.model.entryAmmount = 800
            self.model.addWaterEntry()
            
            if let context = self.model.context {
                
                self.model.insertEntry(ammount: self.model.entryAmmount, context: context)
                
            }
            self.startConfiguration()
            self.historyPreview.reloadData()
            if self.model.history.count == 2 && self.model.history[0].list.count == 1 {
                self.slide(button: self.addButton, direction: "Down")
                self.fade(table: self.historyPreview, direction: "In")
            }
        }
        alertController.addAction(secondNumber)
        
        self.present(alertController, animated: true)
    }
}

