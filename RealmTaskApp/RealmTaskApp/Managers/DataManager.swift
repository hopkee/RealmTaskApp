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
            try realm.write({
                realm.add(newTask)
            })
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
            try realm.write({
                realm.delete(taskToDelete)
            })
        } catch let Error {
            print("Error in deleting task: \(debugPrint(Error))")
        }
        
    }
    
    static func deleteAllTasks() {
        
        let realm = try! Realm()
        
        do {
            try realm.write({
                realm.deleteAll()
            })
        } catch let Error {
            print("Error in deleting data: \(debugPrint(Error))")
        }
        
    }
    
    static func renameTask(_ task: Task, _ newName: String) {
        
        let realm = try! Realm()
        
        do {
            try realm.write({
                task.title = newName
            })
        } catch let Error {
            print("Error in writing data: \(debugPrint(Error))")
        }
        
    }
    
}
