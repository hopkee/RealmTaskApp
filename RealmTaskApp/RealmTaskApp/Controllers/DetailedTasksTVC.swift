//
//  DetailedTasksTVC.swift
//  RealmTaskApp
//
//  Created by Valya on 12.03.22.
//

import UIKit

class DetailedTasksTVC: UITableViewController {

    var selectedTask: Task?
    var subtasks: [Subtask] = []
    var updateTasksTableClosure: (() -> Void)?
    
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
                self.subtasks.append(newSubtask)
                self.tableView.insertRows(at: [IndexPath(row: self.subtasks.count - 1, section: 0)], with: .automatic)
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
    
    @IBAction func editSubtasks(_ sender: UIBarButtonItem) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubtasks(selectedTask)
        setUI()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtaskCell", for: indexPath)
        cell.textLabel?.text = subtasks[indexPath.row].title
        cell.detailTextLabel?.text = subtasks[indexPath.row].detailText
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = subtasks[indexPath.row]
            subtasks.remove(at: indexPath.row)
            DataManager.deleteSubtask(taskToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateTasksTableClosure!()
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
    
    private func loadSubtasks(_ task: Task?) {
        if let task = task {
            subtasks = DataManager.getAllSubtasksFromTask(task)
        }
    }
    
    private func setUI() {
        navigationItem.title = selectedTask?.title
    }

}
