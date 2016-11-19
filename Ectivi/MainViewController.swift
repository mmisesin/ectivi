//
//  ViewController.swift
//  Ectivi
//
//  Created by Artem Misesin on 10/16/16.
//  Copyright © 2016 Artem Misesin. All rights reserved.
//

import UIKit

var sections: [String] = ["Today", "Yesterday"]

var history: [[(time: String, ammount: Int)]] = [[("6.00 pm", 200), ("4.00 pm", 400), ("3.00 pm", 500)], [("8.00 pm", 200), ("6.00 pm", 400), ("12.00 pm", 500)]]

var goal = 2000

var total = 0

@IBDesignable
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        history[0].insert(("\(hour).\(minutes)", 200), at: 0)
        total += 200
        mainIndicator.text = "\(total) ml"
        goalLabel.text = "\(goal - total) ml to go"
        historyPreview.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        
        // Configure the cell
        entry.time.text = history[0][0].time
        entry.ammount.text = String(history[0][0].ammount) + " ml"
        entry
            .backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
        return entry
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            history[indexPath.section].remove(at: indexPath.row)
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
        for (_, entryAmmount) in history[0] {
            
            totalTemp += entryAmmount
        }
        total = totalTemp
        mainIndicator.text = "\(total) ml"
        goalLabel.text = "\(goal - total) ml to go"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }


}

