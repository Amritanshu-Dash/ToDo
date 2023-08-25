//
//  CategoryViewControllerTableViewController.swift
//  ToDo
//
//  Created by Amritanshu Dash on 09/08/23.
//

import UIKit
import RealmSwift

class CategoryViewControllerTableViewController: SwipeTableViewController{

    let realm = try! Realm() // possibly a bad code not certainly // realm access point
    var categories: Results<Category>?// collection of results of category objects of optional type
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

// MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet!"
        return cell
    }
    
//    MARK: - Tableview Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Data manipulation methods
    
    func save(category: Category){
        
        do{
            try realm.write{
                realm.add(category)
            }
        }
        
        catch{
            print("Error")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self) //fetch all the objects that belong to the category data type
        tableView.reloadData()
    }
     // MARK: - delete data
    override func updateModel(at indexPath: IndexPath){
        
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }
            catch{
                print(error)
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField{ (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}


