//
//  ViewController.swift
//  ToDoList
//
//  Created by Marco Astorga González on 2023-02-15.
//


// Lab 6 Student ID: 8778882

import UIKit


struct TodoItem {
    var title: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets

    @IBOutlet weak var itemTable: UITableView!

    // MARK: - Properties

    var itemslist = [TodoItem]()
    let storage = UserDefaults.standard

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the table view's data source and delegate to the view controller
        itemTable.dataSource = self
        itemTable.delegate = self

        // Load the itemslist array from user defaults
        if let items = storage.array(forKey: "itemslist") as? [String] {
            itemslist = items.map { title in
                return TodoItem(title: title)
            }
        }

    }

    // MARK: - Table View Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemslist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let item = itemslist[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the item from the itemslist array
            let deletedItem = itemslist.remove(at: indexPath.row)
            print("delete item: \(deletedItem.title)")
            // Delete the corresponding row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
            // Save the updated itemslist array to user defaults
            let itemDicts = itemslist.map { item in
                return ["title": item.title]
            }
            storage.set(itemDicts, forKey: "itemslist")
        }
    }


    // MARK: - Actions

    @IBAction func Add(_ sender: Any) {
        showAlert()
    }

    // MARK: - Helper Methods

    func showAlert() {
        let alertController = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)

        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Write an item"
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let textField = alertController.textFields?.first, let newItemTitle = textField.text {
                print("New item: \(newItemTitle)")
                // Create a new TodoItem struct with the title
                let newItem = TodoItem(title: newItemTitle)
                // Add the new item to the itemslist array
                self.itemslist.append(newItem)
                // Reload the table view data
                self.itemTable.reloadData()
                // Save the updated itemslist array to user defaults
                let itemTitles = self.itemslist.map { item in
                    return item.title
                }
                self.storage.set(itemTitles, forKey: "itemslist")
            }
        }
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }



}
