//
//  ViewController.swift
//  ToDo
//
//  Created by Amritanshu Dash on 07/08/23.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController{

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let items = todoItems?[indexPath.row]{
            
            cell.textLabel?.text = items.title
            cell.accessoryType = items.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No items added!"
        }
        
        return cell
    }
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write{
                    item.done = !item.done
                }
            }
            catch {
                print("Error.")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() // scope for all the function of this scope
        
        let alert = UIAlertController(title: "Add new item", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default){ (action) in
            
            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items .append(newItem)
                    }
                }
                catch{
                    print("Error.")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField // gets value from alert menu
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath){
        
        if let items = todoItems?[indexPath.row]{
            do {
                try realm.write{
                realm.delete(items)
                }
            }
            catch{
                print(error)
            }
        }
    }
        
}

//MARK: - Search Bar code extension
extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true) // specify to search or ffilter on the basis of what user has specified ..
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
            loadItems()
            //runs on main queue
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()//removes cursor and keyboard
            }
        }
    }
}
