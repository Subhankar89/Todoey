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
    var itemArray = [Item]() //and array of item objects
    
    let defaults = UserDefaults.standard
    
    let dataFilePath =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Find Mike"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Find Mike"
//        itemArray.append(newItem3)
        
        loadItems()
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{ //grabing data from todo list and casting it to String
        itemArray = items
        }
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none //ternary
       
        return cell
        
    }
    
    //MARK - Tableview delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (itemArray[indexPath.row])
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark  //adding accessory to the selected cell
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)  //animation for cell selection
        
//        if itemArray[indexPath.row].done == false
//        {
//            itemArray[indexPath.row].done = true
//        }
//        else
//        {
//            itemArray[indexPath.row].done = false
//        }
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark  //condition to uncheck the cell when deselected
//        {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else
//        {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
       
        //tableView.reloadData() // forces the table view to call its datasource methods again so that it reloads the data thats meant to be inside
        
        
    }
    
    //MARK - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField() //local variable to hold the value of textfield from addbuttonPressed
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in //what would happen on clicking the 'Add Item' Button
           // print("Success!")
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem) //appending the value to array
            
            
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray") // setting the userdefaults to persist the data
            
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action) //adds the action to our alert pop up
        
        present(alert, animated: true, completion: nil) //show the alert to user
        
    }
    //MARK - Model Manipulations
    func saveItems()
    {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch{
            print("Error Encoding,\(error)")
        }
        self.tableView.reloadData() //reloads the table view with new data in item array
    }
    
    func loadItems()
    {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding,\(error)")
            }
        }
    }
    
}

