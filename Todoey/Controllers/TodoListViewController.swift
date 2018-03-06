//
//  ViewController.swift
//  Todoey
//
//  Created by Subhankar Acharya on 25/02/18.
//  Copyright © 2018 Subhankar. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewViewController: UITableViewController
{
    var itemArray : Results<Item>? //and array of item objects
    let realm = try! Realm()
    var selectedCategory : Category? { //its going to be nil until its set in CategoryVC
        didSet{
            loadItems() // this code will be excuted only when selectedCategory will have a value i.e items will be loaded up as per the selected category
        }
    }
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //object of Appdelegate to access its methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) // prints the data path
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1 //this is known as optional chaining
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row] { //optional binding check
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none //ternary
        }else{
            cell.textLabel?.text = "No Items added"
        }
      return cell
        
    }
    
    //MARK - Tableview delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let  item = itemArray?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving the data,\(error)")
            }
        }
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        saveItems()
       tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)  //animation for cell selection
        
    }
    
    //MARK - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField() //local variable to hold the value of textfield from addbuttonPressed
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in //what would happen on clicking the 'Add Item' Button
            
            
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error Saving Category,\(error)")
                }
            }
            //newItem.parentCategory = self.selectedCategory? //setting the selected category to parentCategory
            //self.itemArray.append(newItem) //appending the value to array
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action) //adds the action to our alert pop up
        
        present(alert, animated: true, completion: nil) //show the alert to user
        
    }
    //MARK - Model Manipulations
//    func saveItems()
//    {
//        do {
//              try context.save() //using CoreData for saving our new items
//        } catch{
//              print("Error saving context, \(error)")
//        }
//       tableView.reloadData() //reloads the table view with new data in item array
//    }
    
//    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil) //default value is Item.fetchRequest() and an optional predicate with default value nil
//    {
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!) // querying the DB to load specific items as per the selcted Category
//        if let  additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }else{
//            request.predicate = categoryPredicate
//        }
//
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate]) //
////
////        request.predicate = compoundPredicate//adding the predicate to the request
//
//        do{
//            itemArray = try context.fetch(request)
//        }
//        catch{
//            print("Error fetching data, \(error)")
//        }
//        tableView.reloadData()
//    }
     func loadItems()
     {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK:- Search Bar Methods
extension TodoListViewViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest() //pulls back everything inside the persistent container
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //querying the DB
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //sorting the data that we get back from the DB
//        loadItems(with: request, predicate: predicate)
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
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
