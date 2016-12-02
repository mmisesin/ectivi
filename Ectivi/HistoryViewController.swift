//
//  HistoryViewController.swift
//  Ectivi
//
//  Created by Artem Misesin on 11/12/16.
//  Copyright © 2016 Artem Misesin. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {

    @IBOutlet var table: UITableView!
    
    var model: EctiviModel = EctiviModel()
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    
    @IBAction func deleteButton(_ sender: UIButton) {
        _ = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.model.removeEntry(indexPath: indexPath)
            self.table.deleteRows(at: [indexPath], with: .fade)
            if self.model.history[indexPath.section].list.isEmpty {
                let indexSet = NSMutableIndexSet()
                indexSet.add(indexPath.section)
                self.model.history.remove(at: indexPath.section)
                self.table.deleteSections(indexSet as IndexSet, with: .fade)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.sectionHeaderHeight = 60
        self.tableView.rowHeight = 60
        self.tableView.separatorStyle = .none
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        navigationController?.navigationBar.barTintColor = UIColor.white
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if !model.history.isEmpty {
            return model.history.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if !model.history.isEmpty {
            return model.history[section].list.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Date()
        //let calendar = Calendar.current
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        
        let day = formatter.string(from: date)
        
        if model.history[section].day == day {
            return "Today"
        }

        return model.history[section].day
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // This changes the header background
        view.tintColor = UIColor.white
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = self.table.dequeueReusableCell(withIdentifier: "HistoryCell") as! CustomTableViewCell

        // Configure the cell

        entry.time.text = model.history[indexPath.section].list[indexPath.row].time
        entry.ammount.text = String(model.history[indexPath.section].list[indexPath.row].ammount) + " ml"
//        entry.deleteButton.tag = indexPath.row;
//        entry.deleteButton.addTarget(self, action: "deleteButton:", for: .touchUpInside)
        return entry
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.model.removeEntry(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if self.model.history[indexPath.section].list.isEmpty {
                let indexSet = NSMutableIndexSet()
                indexSet.add(indexPath.section)
                self.model.history.remove(at: indexPath.section)
                tableView.deleteSections(indexSet as IndexSet, with: .fade)
            }
        }
        if model.history.count == 1{
            self.table.isHidden = true;
            self.emptyLabel.isHidden = false;
        }
        
        delete.backgroundColor = UIColor(red: 0.49, green: 0.62, blue: 0.96, alpha: 1)
        
        return [delete]
    }

    override func viewWillAppear(_ animated: Bool) {
        if model.history.count > 1 {
            self.table.isHidden = false;
            self.emptyLabel.isHidden = true;
        } else {
            self.table.isHidden = true;
            self.emptyLabel.isHidden = false;
        }
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
