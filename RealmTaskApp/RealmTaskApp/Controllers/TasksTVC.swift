//
//  TasksTVC.swift
//  RealmTaskApp
//
//  Created by Valya on 12.03.22.
//

import UIKit
import SwiftUI

class TasksTVC: UITableViewController {
    
    //Variables
    var tasks: [Task] = []

    @IBAction func addNewTaskBtn(_ sender: UIBarButtonItem) {
        
        let title = "Add new task"
        let message = "Create a new task"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionAdd = UIAlertAction(title: "Add task", style: .default) { [weak self] _ in
            if let titleField = alert.textFields?.first,
               let descriptionField = alert.textFields?[1],
               let title = titleField.text, title != "",
               let description = descriptionField.text, description != "",
               let self = self {
                let newTask = Task(title: title, detailedText: description)
                DataManager.addNewTask(newTask)
                self.tasks.append(newTask)
                self.tableView.insertRows(at: [IndexPath(row: self.tasks.count - 1, section: 0)], with: .automatic)
            }
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField { textField in
            textField.placeholder = "write name of new task"
        }
        alert.addTextField { textFieldDescription in
            textFieldDescription.placeholder = "description"
        }
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        
        self.present(alert, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].title
        cell.detailTextLabel?.text = tasks[indexPath.row].date.description
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let renameBtn = UIContextualAction(style: .normal, title: "Rename") { [weak self] _, _, _ in
            
            let alert = UIAlertController(title: "Rename task", message: "", preferredStyle: .alert)
            
            let actionRename = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
                if let newTitle = alert.textFields?.first,
                   let text = newTitle.text, text != "",
                   let self = self {
                    
                }
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .destructive)
            
            alert.addTextField { textField in
                textField.placeholder = "new name"
            }
            alert.addAction(actionRename)
            alert.addAction(actionCancel)
            
            self!.present(alert, animated: true)
            
        }
        
        let deleteBtn = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            
            
        }
        
        let buttonsConfiguration = UISwipeActionsConfiguration(actions: [deleteBtn, renameBtn])
        return buttonsConfiguration
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.row]
            tasks.remove(at: indexPath.row)
            DataManager.deleteTask(taskToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func fetchData() {
        tasks = DataManager.getAllTasks()
        tableView.reloadData()
    }

}
