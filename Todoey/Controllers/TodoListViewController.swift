//
//  ViewController.swift
//  Todoey
//
//  Created by Subhankar Acharya on 25/02/18.
//  Copyright © 2018 Subhankar. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewViewController: UITableViewController
{
    var itemArray = [Item]() //and array of item objects
    
    let defaults = UserDefaults.standard
    
    //let dataFilePath =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") not using after implementing core data
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //object of Appdelegate to access its methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) // prints the data path
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
        
          loadItems() //commented after the use of coredata
          
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{ //grabing data from todo list and casting it to String
//        itemArray = items
//        }
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
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false //setting defalut as false
            
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
        // let encoder = PropertyListEncoder() commented after using CoreData
        do {
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.dataFilePath!) //using Encoder to save
              try context.save() //using CoreData for saving our new items
        } catch{
//            print("Error Encoding,\(error)")
              print("Error saving context, \(error)")
            
        }
        self.tableView.reloadData() //reloads the table view with new data in item array
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest()) //default value is Item.fetchRequest()
    {
//        if let data = try? Data(contentsOf: dataFilePath!){  //commented after the use of CoreData
//            let decoder = PropertyListDecoder()
//            do{
//                itemArray = try decoder.decode([Item].self, from: data)
//            }catch{
//                print("Error decoding,\(error)")
//            }
//        }
//        let request : NSFetchRequest<Item> = Item.fetchRequest() //pulls back everything inside the persistent container
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error fetching data, \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK:- Search Bar Methods
extension TodoListViewViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest() //pulls back everything inside the persistent container
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //querying the DB
//
//        request.predicate = predicate // attaching it with the request
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //querying the DB
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true) //sorting the data that we get back from the DB
//
//        request.sortDescriptors = [sortDescriptor] //attching the sort to the request
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //sorting the data that we get back from the DB
        loadItems(with: request)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0
        {
            loadItems()
            DispatchQueue.main.async { //object that mangaes the execution of work items
                searchBar.resignFirstResponder()
            }
        }
    }
}
