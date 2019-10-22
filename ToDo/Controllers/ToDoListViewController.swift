//
//  ViewController.swift
//  ToDo
//
//  Created by Vasil Vasilev on 17.10.19.
//  Copyright © 2019 Vasil Vasilev. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray: [Item] = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
    }
    
    
    
    //MARK: - Tableview Datasource Methods
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

        let currenctCell = tableView.cellForRow(at: indexPath)
        
        // Delete Items
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        if currenctCell!.accessoryType == .none {
            currenctCell!.accessoryType = .checkmark
            itemArray[indexPath.row].done = true
        }
        else {
            currenctCell!.accessoryType = .none
            itemArray[indexPath.row].done = false
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.saveItems()
    }
    
    //MARK: - Add New Items:
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new item", message: "MESSAGE", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {  [weak self] (action) in
            //what will happen once the user hit the Add button
            
            let newItem = Item(context: self!.context)

            newItem.title = alert.textFields?.first?.text ?? ""
            newItem.done = false
            self?.itemArray.append(newItem)
            self?.tableView.reloadData()
        
            self?.saveItems()
    
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"

        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
    
    func saveItems() {


        do {
            try self.context.save()
        } catch {
            print("Error in saving data, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
        
        tableView.reloadData()
    }
    
}


        //MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.loadItems()
            
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
            DispatchQueue.main.asyncAfter(deadline: .now()+0.01) {
                searchBar.resignFirstResponder()
            }
        }
    }
}
