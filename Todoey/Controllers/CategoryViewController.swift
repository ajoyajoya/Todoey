//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Aji Prastio Wibowo on 19/06/19.
//  Copyright © 2019 AJOYAJOYA. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    let defaults = UserDefaults.standard
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("Load Category View")
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategory()
        
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let categories = categoryArray?[indexPath.row]
        
        cell.textLabel?.text = categories?.name ?? "No Categories Added Yet"
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if categoryArray?[indexPath.row].name != nil{
            
            performSegue(withIdentifier: "goToItems", sender: self)
            
        } else{
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        
        //saveCategory()
        
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in


            let newCategory = Category()
            newCategory.name = textField.text!


            self.saveCategory(category: newCategory)
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }

        alert.addAction(action)

        //present(alert, animated: true, completion: nil)
        
        present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
        
        
        
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory(category : Category) {
        
        do {
            
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving Category, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadCategory (/*with request: NSFetchRequest<Category> = Category.fetchRequest()**/){
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
}
