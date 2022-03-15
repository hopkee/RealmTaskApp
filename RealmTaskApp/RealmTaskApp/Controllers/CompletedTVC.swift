//
//  CompletedTVC.swift
//  RealmTaskApp
//
//  Created by Valya on 13.03.22.
//

import UIKit

class CompletedTVC: UITableViewController {

    var completedTasks: [Task] = []
    var completedSubtasks: [Subtask] = []
    var updateTasksTableClosure: (() -> Void)?
    var updataSubtasksTableClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if let closureToUpdateTasks =  updateTasksTableClosure {
            closureToUpdateTasks()
        } else if let closureToUpdateSubtasks = updataSubtasksTableClosure {
            closureToUpdateSubtasks()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.completedTasks.count
        } else {
            return self.completedSubtasks.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(50)
        } else {
            return CGFloat(20)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Completed tasks"
        } else {
            return "Completed subtasks"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTaskCell", for: indexPath)

        if indexPath.section == 0 {
            cell.textLabel?.text = completedTasks[indexPath.row].title
        } else {
            cell.textLabel?.text = completedSubtasks[indexPath.row].title
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let uncompleteBtn = UIContextualAction(style: .normal, title: "Uncomplete") { [weak self] _, _, _ in
            if let self = self {
                if indexPath.section == 0 {
                    let task = self.completedTasks[indexPath.row]
                    DataManager.changeTaskStatus(task)
                    self.completedTasks.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                } else {
                    let task = self.completedSubtasks[indexPath.row]
                    DataManager.changeSubtaskStatus(task)
                    self.completedSubtasks.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
        
        let rightButtonsBar = UISwipeActionsConfiguration(actions: [uncompleteBtn])
        return rightButtonsBar
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    
    private func loadData() {
        completedTasks = DataManager.getCompletedTasks()
        completedSubtasks = DataManager.getCompletedSubtasks()
        tableView.reloadData()
    }

}
