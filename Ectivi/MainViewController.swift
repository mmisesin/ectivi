//
//  ViewController.swift
//  Ectivi
//
//  Created by Artem Misesin on 10/16/16.
//  Copyright © 2016 Artem Misesin. All rights reserved.
//

import UIKit

@IBDesignable
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var model: EctiviModel = EctiviModel()
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var mainIndicator: UILabel!
    
    @IBOutlet weak var goalLabel: UILabel!
    
    @IBOutlet weak var historyPreview: UITableView!
    @IBAction func historyButton() {
    }
    @IBAction func addBytton(_ sender: UIButton) {
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        model.history[0].insert(("\(hour).\(minutes)", 200), at: 0)
        model.total += 200
        mainIndicator.text = "\(model.total) ml"
        goalLabel.text = "\(model.goal - model.total) ml to go"
        historyPreview.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        // Configure the cell
        entry.time.text = model.history[0][0].time
        entry.ammount.text = String(model.history[0][0].ammount) + " ml"
        entry
            .backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
        return entry
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            model.history[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.insertRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        historyPreview.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
        mainView.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
        addButton.backgroundColor = UIColor(red: 0.49, green: 0.62, blue: 0.96, alpha: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        var totalTemp = 0
        for (_, entryAmmount) in model.history[0] {
            
            totalTemp += entryAmmount
        }
        model.total = totalTemp
        mainIndicator.text = "\(model.total) ml"
        goalLabel.text = "\(model.goal - model.total) ml to go"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }


}

