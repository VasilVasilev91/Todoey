//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Vasil Vasilev on 21.10.19.
//  Copyright © 2019 Vasil Vasilev. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        loadItems()

    }

    // MARK: - TABLE VIEW DATA SOURCE METHODS
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.backgroundColor = UIColor.init(hexString: (categoryArray?[indexPath.row].bgColor)!)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "Categories not added yet"
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
        return cell
    }
    

    //MARK: - TABLE VIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ToDoListViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categoryArray?[indexPath.row]
            }
        }
    }
    
    
    //MARK: - DATA MANIPULATION
    func save(category: Category) {

        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error in saving data, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
//MARK: - Delete Cell
    override func updateDataModel(at indexPath: IndexPath) {
                    if let categoty = self.categoryArray?[indexPath.row]{
                        do {
                            try self.realm.write {
                                self.realm.delete(categoty)
                            }
                        } catch {
                            print("Error in saving data, \(error)")
                        }
                    }
    }
    

    
    //MARK: - Did press add category button
    @IBAction func didTapAddCategoryButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        alert.addTextField { (addedNewTextField) in
            addedNewTextField.placeholder = "Enter the new category here"
        }
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] (action) in
            let newCategory = Category()
            if alert.textFields?.first?.text != "" {
                
            }
            if !(alert.textFields?.first?.text!.trimmingCharacters(in: .whitespaces).isEmpty)!{
                if let alertTextField = alert.textFields?.first?.text{
                    newCategory.name = alertTextField
                    newCategory.bgColor = UIColor.randomFlat().hexValue()
                    self?.save(category: newCategory)
                }
            }

        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
}


