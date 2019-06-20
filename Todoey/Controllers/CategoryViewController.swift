//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Aji Prastio Wibowo on 19/06/19.
//  Copyright © 2019 AJOYAJOYA. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("Load Category View")
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategory()
        
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let categories = categoryArray[indexPath.row]
        
        cell.textLabel?.text = categories.name
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        //saveCategory()
        
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)

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
    
    func saveCategory() {
        
        do {
            
            try context.save()
        } catch {
            print("Error Saving Category, \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadCategory (with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryArray = try context.fetch(request)
            
        } catch {
            print ("Error fetching data from context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    
}
