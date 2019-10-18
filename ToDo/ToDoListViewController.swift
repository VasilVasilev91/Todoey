//
//  ViewController.swift
//  ToDo
//
//  Created by Vasil Vasilev on 17.10.19.
//  Copyright © 2019 Vasil Vasilev. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggs", "Go to disco"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: Check which Table View was selected - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        let currenctCell = tableView.cellForRow(at: indexPath)
        
        if currenctCell!.accessoryType == .none {
            currenctCell!.accessoryType = .checkmark
        }
        else {
            currenctCell!.accessoryType = .none
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add New Items:
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { [weak self] (action) in
            //what will happen once the user hit the Add button
            print("Success - new Item added in the array!")
            self?.itemArray.append(alert.textFields?.first?.text ?? "")
            self?.tableView.reloadData()
            print(self?.itemArray.map {$0.description} ?? "")
    
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
    
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
}

