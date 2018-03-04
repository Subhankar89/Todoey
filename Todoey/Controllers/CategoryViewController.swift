//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Subhankar Acharya on 03/03/18.
//  Copyright © 2018 Subhankar. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //garbbing a refernece to context in order to CRUD data and would be communitcating with persistent container
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadCategory()
    }
    
    //MARK: - Table View Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) //creates a reusable cell and adds to the table at the current indexpath that tableview is trying to loadup
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell //return the cell to be rendered on screen
    }
    //MARK:- Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //would trigger the segue once selected
        performSegue(withIdentifier: "goToItems", sender: self)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)//would be called just before the segue
    {
        let destinationVC = segue.destination as! TodoListViewViewController //grabbing a reference to destination VC which is in this case is TodoListViewViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    //MARK:- Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
        let newCategory = Category(context: self.context)
        newCategory.name = textField.text!
        self.categoryArray.append(newCategory)
        self.saveCategory()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action) //adds the action to our alert pop up
        
        present(alert, animated: true, completion: nil) //show the alert to user
        
        }
    //MARK:- Data Manipulations Methods
    func saveCategory()
    {
        do {
            try context.save()
        }catch{
            print("Error Saving Category,\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory()
    {
        let request:NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request) //fetching catergory
        }catch{
            print("Error Loading Category,\(error)")
        }
        tableView.reloadData()
    }
}
