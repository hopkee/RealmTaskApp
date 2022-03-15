//
//  DetailedTasksTVC.swift
//  RealmTaskApp
//
//  Created by Valya on 12.03.22.
//

import UIKit

class SubtasksTVC: UITableViewController {

    var selectedTask: Task?
    var uncompletedSubtasks: [Subtask] = []
    var updateTasksTableClosure: (() -> Void)?
    
    @IBAction func completedTasksBtn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "GoToCompletedTasks", sender: nil)
    }
    
    
    @IBAction func addNewSubtasks(_ sender: UIBarButtonItem) {
        
        guard let selectedTask = selectedTask else { return }
        
        let title = "Add new subtask"
        let message = "Create a new subtask for \(selectedTask.title) task"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionAdd = UIAlertAction(title: "Add subtask", style: .default) { [weak self] _ in
            if let titleField = alert.textFields?.first,
               let descriptionField = alert.textFields?[1],
               let title = titleField.text, title != "",
               let description = descriptionField.text, description != "",
               let self = self {
                let newSubtask = Subtask(title: title, detailedText: description)
                DataManager.addNewSubtask(newSubtask, for: selectedTask)
                self.uncompletedSubtasks.append(newSubtask)
                self.tableView.insertRows(at: [IndexPath(row: self.uncompletedSubtasks.count - 1, section: 0)], with: .automatic)
                self.updateTasksTableClosure!()
            }
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField { textField in
            textField.placeholder = "write name of new subtask"
        }
        alert.addTextField { textFieldDescription in
            textFieldDescription.placeholder = "description"
        }
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        
        self.present(alert, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeBtn = UIContextualAction(style: .normal, title: "Complete") { [weak self] _, _, _ in
            if let self = self,
              let closure = self.updateTasksTableClosure {
                let subtask = self.uncompletedSubtasks[indexPath.row]
                DataManager.changeSubtaskStatus(subtask)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                closure()
                
                let _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    self.uncompletedSubtasks.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                
            }
        }
        completeBtn.backgroundColor = UIColor.systemGreen
        
        let leftButtonsBar = UISwipeActionsConfiguration(actions: [completeBtn])
        leftButtonsBar.performsFirstActionWithFullSwipe = true
        return leftButtonsBar
    }
    
    @IBAction func editSubtasks(_ sender: UIBarButtonItem) {
        tableView.isEditing.toggle()
        sender.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(selectedTask)
        setUI()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uncompletedSubtasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtaskCell", for: indexPath)
        
        let title = uncompletedSubtasks[indexPath.row].title
        let subtitle = uncompletedSubtasks[indexPath.row].detailText
        uncompletedSubtasks[indexPath.row].done ? (cell.textLabel?.attributedText = title.strikeThrough()) : (cell.textLabel?.attributedText = title.unStrikeThrought())
        uncompletedSubtasks[indexPath.row].done ? (cell.detailTextLabel?.attributedText = subtitle.strikeThrough()) : (cell.detailTextLabel?.attributedText = subtitle.unStrikeThrought())
        
        cell.textLabel?.text = uncompletedSubtasks[indexPath.row].title
        cell.detailTextLabel?.text = uncompletedSubtasks[indexPath.row].detailText
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = uncompletedSubtasks[indexPath.row]
            uncompletedSubtasks.remove(at: indexPath.row)
            DataManager.deleteSubtask(taskToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateTasksTableClosure!()
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let completedTasks = segue.destination as? CompletedTVC,
        let task = selectedTask,
        let closure = updateTasksTableClosure {
            completedTasks.updataSubtasksTableClosure = {
                self.loadData(task)
                self.tableView.reloadData()
                closure()
            }
        }
    }
    
    private func loadData(_ task: Task?) {
        if let task = task {
            uncompletedSubtasks = DataManager.getUncompletedSubtasksFromTask(task)
        }
    }
    
    private func setUI() {
        if let subtitle = selectedTask?.detailText {
            descriptionLbl.text = "Description: \n" + subtitle
        }
        navigationItem.title = selectedTask?.title
    }

}
