//
//  ViewController.swift
//  Todoey
//
//  Created by Subhankar Acharya on 25/02/18.
//  Copyright © 2018 Subhankar. All rights reserved.
//

import UIKit

class TodoListViewViewController: UITableViewController
{
    var itemArray = ["Find Mike", "Bue Eggs", "Destroy T'Challa"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [String]{ //grabing data from todo list and casting it to String
        itemArray = items
        }
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //MARK - Tableview delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (itemArray[indexPath.row])
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark  //adding accessory to the selected cell
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark  //condition to uncheck the cell when deselected
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)  //animation for cell selection
        
    }
    
    //MARK - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField() //local variable to hold the value of textfield from addbuttonPressed
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in //what would happen on clicking the 'Add Item' Button
           // print("Success!")
            self.itemArray.append(textField.text!) //appending the value to array
            self.defaults.set(self.itemArray, forKey: "ToDoListArray") // setting the userdefaults to persist the data  
            
            self.tableView.reloadData() //reloads the table view with new data in item array
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action) //adds the action to our alert pop up
        
        present(alert, animated: true, completion: nil) //show the alert to user
        
        
        
    }
}

