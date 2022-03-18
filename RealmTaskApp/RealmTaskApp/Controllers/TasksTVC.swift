//
//  TasksTVC.swift
//  RealmTaskApp
//
//  Created by Valya on 12.03.22.
//

import UIKit

class TasksTVC: UITableViewController {
    
    //Variables
    var uncompletedTasks: [Task] = []
    
    @IBAction func completedTasksBtn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "GoToCompletedTasks", sender: nil)
    }
    
    @IBAction func sortingBtn(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            uncompletedTasks.sort(by: {
            $0.title.lowercased() < $1.title.lowercased()
            })
            tableView.reloadData()
        } else {
            uncompletedTasks.sort(by: {
            $0.title.lowercased() > $1.title.lowercased()
            })
            tableView.reloadData()
        }
    }
    

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
                self.uncompletedTasks.append(newTask)
                self.tableView.insertRows(at: [IndexPath(row: self.uncompletedTasks.count - 1, section: 0)], with: .automatic)
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
    
    @IBAction func editRowsBtn(_ sender: UIBarButtonItem) {
        tableView.isEditing.toggle()
        sender.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uncompletedTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = uncompletedTasks[indexPath.row]
        cell.detailTextLabel?.text = DataManager.getUncompletedSubtasksFromTask(task).count.description
        
        let title = uncompletedTasks[indexPath.row].title
        uncompletedTasks[indexPath.row].done ? (cell.textLabel?.attributedText = title.strikeThrough()) : (cell.textLabel?.attributedText = title.unStrikeThrought())
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToDetailedView", sender: indexPath.row)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let renameBtn = UIContextualAction(style: .normal, title: "Rename") { [weak self] _, _, _ in
            
            let alert = UIAlertController(title: "Rename task", message: "", preferredStyle: .alert)
            
            let actionRename = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
                if let newTitle = alert.textFields?.first?.text, newTitle != "",
                   let task = self?.uncompletedTasks[indexPath.row],
                   let self = self {
                    DataManager.renameTask(task, newTitle)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .destructive)
            
            alert.addTextField { textField in
                textField.placeholder = "New name"
            }
            alert.addAction(actionRename)
            alert.addAction(actionCancel)
            
            self!.present(alert, animated: true)
            
        }
        
        let deleteBtn = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            
            let taskToDelete = self.uncompletedTasks[indexPath.row]
            self.uncompletedTasks.remove(at: indexPath.row)
            DataManager.deleteTask(taskToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let rightButtonsBar = UISwipeActionsConfiguration(actions: [deleteBtn, renameBtn])
        return rightButtonsBar
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeBtn = UIContextualAction(style: .normal, title: "Complete") { [weak self] _, _, _ in
            if let self = self {
                let task = self.uncompletedTasks[indexPath.row]
                DataManager.changeTaskStatus(task)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                
                let _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    self.uncompletedTasks.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                
            }
        }
        completeBtn.backgroundColor = UIColor.systemGreen
        
        let leftButtonsBar = UISwipeActionsConfiguration(actions: [completeBtn])
        leftButtonsBar.performsFirstActionWithFullSwipe = true
        return leftButtonsBar
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = uncompletedTasks[indexPath.row]
            uncompletedTasks.remove(at: indexPath.row)
            DataManager.deleteTask(taskToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }
 
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailedView = segue.destination as? SubtasksTVC,
        let indexPath = sender as? Int {
            detailedView.selectedTask = uncompletedTasks[indexPath]
            detailedView.updateTasksTableClosure = {
                self.tableView.reloadData()
            }
        }
        if let completedTasks = segue.destination as? CompletedTVC {
            completedTasks.updateTasksTableClosure = {
                self.loadData()
                self.tableView.reloadData()
            }
        }
    }

    private func loadData() {
        uncompletedTasks = DataManager.getUncompletedTasks()
        tableView.reloadData()
    }

}

