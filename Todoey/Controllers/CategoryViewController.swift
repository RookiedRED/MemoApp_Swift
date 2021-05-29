//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 林宏諭 on 2021/5/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.separatorStyle = .none
        
    }
    
    @IBAction func unwindSegueBack (segue: UIStoryboardSegue){
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        /*
         Set the colour to use here:
         */
        let theColourWeAreUsing = UIColor(hexString: "fed330")!
        
        /*
         THen we will set the colours. Using navigationController?.navigationBar.backgroundColor is not an option here because in iOS 13, the status bar at the very top does not change colour (strangely enough). After Googling this, I found a solution where they use UINavigationBarAppearance() instead.
         */
        let navBarAppearance = UINavigationBarAppearance()
        let navBar = navigationController?.navigationBar
        navBarAppearance.configureWithOpaqueBackground()
        
        /*
         We use Chameleon's ContrastColorOf() function to set the colour of the text based on the colour we use. If it is dark, the text is light, and vice versa.
         */
        let contrastColour = ContrastColorOf(theColourWeAreUsing, returnFlat: true)
        
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: contrastColour]
        navBarAppearance.backgroundColor = theColourWeAreUsing
        navBar?.tintColor = contrastColour
        navBar?.standardAppearance = navBarAppearance
        navBar?.scrollEdgeAppearance = navBarAppearance
        
        self.navigationController?.navigationBar.setNeedsLayout()
        
    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.backgroundColor ) else {fatalError()}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems"{
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
        
    }
    
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category){
        
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting category, \(error)")
            }
        }
    }
    
}


