//
//  ViewController.swift
//  ToDo
//
//  Created by Vasil Vasilev on 17.10.19.
//  Copyright © 2019 Vasil Vasilev. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray: [Item] = [Item]()
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        if let items = defaults.array(forKey: "storedArray") as? [Item] {
//            itemArray = items
//        }
        
        let item1 = Item()
        let item2 = Item()
        let item3 = Item()
        item1.title = "Item1"
        item2.title = "Item2"
        item3.title = "Item3"
        itemArray.append(item1)
        itemArray.append(item2)
        itemArray.append(item3)
        
    }
    
    
    
    //MARK - Tableview Datasource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: Check which Table View was selected - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        let currenctCell = tableView.cellForRow(at: indexPath)
        
        if currenctCell!.accessoryType == .none {
            currenctCell!.accessoryType = .checkmark
            itemArray[indexPath.row].done = true
        }
        else {
            currenctCell!.accessoryType = .none
            itemArray[indexPath.row].done = false
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add New Items:
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { [weak self] (action) in
            //what will happen once the user hit the Add button
            
            let newItem = Item()
            
            newItem.title = alert.textFields?.first?.text ?? ""
            self?.itemArray.append(newItem)
            self?.tableView.reloadData()
            print(self?.itemArray.map {$0.title.description.description} ?? "")
            
            self?.defaults.set(self?.itemArray, forKey: "storedArray")
    
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
    
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
}

