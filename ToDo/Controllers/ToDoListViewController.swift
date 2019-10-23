//
//  ViewController.swift
//  ToDo
//
//  Created by Vasil Vasilev on 17.10.19.
//  Copyright © 2019 Vasil Vasilev. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
    var itemArray: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }
    
    
    
    //MARK: - Tableview Datasource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = itemArray?[indexPath.row].title ?? "No Items"
        
        cell.accessoryType = itemArray?[indexPath.row].done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: Check which Table View was selected - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                item.done = !item.done
                }
            } catch {
                print("Error updating the data \(error)")
            }

        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - Add New Items:
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new item", message: "MESSAGE", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {  [weak self] (action) in
            //what will happen once the user hit the Add button
            
            
            
            if let currentCategory = self?.selectedCategory {
                do {
                    try self?.realm.write {
                        let newItem = Item()
                        newItem.title = (alert.textFields?.first?.text!)!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            
            self?.tableView.reloadData()
            

    
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"

        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
    
    func saveItems() {


    }
    
    func loadItems() {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        
        tableView.reloadData()
    }
    
    
//MARK: - Delete swipe gesture recognised fubction
    override func updateDataModel(at indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error in deleting the Item: \(error)")
            }
        }
    }

    
}


        //MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.loadItems()

            DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
                searchBar.resignFirstResponder()
            }
        }
    }
}
