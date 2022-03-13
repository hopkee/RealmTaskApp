//
//  DataManager.swift
//  RealmTaskApp
//
//  Created by Valya on 12.03.22.
//

import Foundation
import RealmSwift

class DataManager {
    
    static func addNewTask(_ newTask: Task) {
        
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.add(newTask)
            }
        } catch let Error {
            print("Error in writing data: \(debugPrint(Error))")
        }
        
    }
    
    static func getAllTasks() -> [Task] {
        
        let realm = try! Realm()
        let allTasks = realm.objects(Task.self).toArray(ofType: Task.self) as [Task]
        
        return allTasks
    }
    
    static func deleteTask(_ taskToDelete: Task) {
        
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.delete(taskToDelete)
            }
        } catch let Error {
            print("Error in deleting task: \(debugPrint(Error))")
        }
        
    }
    
    static func deleteAllTasks() {
        
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch let Error {
            print("Error in deleting data: \(debugPrint(Error))")
        }
        
    }
    
    static func renameTask(_ task: Task, _ newName: String) {
        
        let realm = try! Realm()
        
        do {
            try realm.write {
                task.title = newName
            }
        } catch let Error {
            print("Error in renaming task: \(debugPrint(Error))")
        }
        
    }
    
    static func getAllSubtasksFromTask(_ task: Task) -> [Subtask] {
        
        let realm = try! Realm()
        let allSubtasks = realm.objects(Subtask.self)
        let subtasksOfTask = allSubtasks.where {
            $0.task == task
        }
        
        return (subtasksOfTask.toArray(ofType: Subtask.self))
        
    }
    
    static func addNewSubtask(_ newSabtask: Subtask, for task: Task) {
        
        let realm = try! Realm()
        
        do {
            try realm.write {
                task.subtasks.append(newSabtask)
            }
        } catch let Error {
            print("Error in adding new subtask: \(debugPrint(Error))")
        }
        
    }
    
    static func deleteSubtask(_ subtaskToDelete: Subtask) {
        
        let realm = try! Realm()
        
        do {
            try realm.write {
                realm.delete(subtaskToDelete)
            }
        } catch let Error {
            print("Error in deleting subtask: \(debugPrint(Error))")
        }
        
    }
    
    static func changeTaskStatus(_ task: Task) {
        
        let realm = try! Realm()
        
        do {
            try realm.write {
                task.done.toggle()
            }
        } catch let Error {
            print("Error in changing task status: \(debugPrint(Error))")
        }
        
    }
    
    static func changeSubtaskStatus(_ subtask: Subtask) {
        
        let realm = try! Realm()
        
        do {
            try realm.write {
                subtask.done.toggle()
            }
        } catch let Error {
            print("Error in changing subtask status: \(debugPrint(Error))")
        }
        
    }
    
    static func getCompletedTasks() -> [Task] {
        
        let realm = try! Realm()
        let allTasks = realm.objects(Task.self)
        let completedTasks = allTasks.where {
            $0.done == true
        }
        
        return (completedTasks.toArray(ofType: Task.self))
        
    }
    
    static func getCompletedSubtasks() -> [Subtask] {
        
        let realm = try! Realm()
        let allSubtasks = realm.objects(Subtask.self)
        let completedSubtasks = allSubtasks.where {
            $0.done == true
        }
        
        return (completedSubtasks.toArray(ofType: Subtask.self))
        
    }
    
    static func getUncompletedTasks() -> [Task] {
        
        let realm = try! Realm()
        let allTasks = realm.objects(Task.self)
        let unCompletedTasks = allTasks.where {
            $0.done == false
        }
        
        return (unCompletedTasks.toArray(ofType: Task.self))
        
    }
    
    static func getUncompletedSubtasks() -> [Subtask] {
        
        let realm = try! Realm()
        let allSubtasks = realm.objects(Subtask.self)
        let unCompletedSubtasks = allSubtasks.where {
            $0.done == false
        }
        
        return (unCompletedSubtasks.toArray(ofType: Subtask.self))
        
    }
    
    static func getUncompletedSubtasksFromTask(_ task: Task) -> [Subtask] {
        
        let realm = try! Realm()
        let allSubtasks = realm.objects(Subtask.self)
        let uncompletedSubtasksOfTask = allSubtasks.where {
            $0.task == task && $0.done == false
        }
        
        return (uncompletedSubtasksOfTask.toArray(ofType: Subtask.self))
        
    }
    
}
