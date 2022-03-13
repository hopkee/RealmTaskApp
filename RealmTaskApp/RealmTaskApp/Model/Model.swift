//
//  Model.swift
//  RealmTaskApp
//
//  Created by Valya on 12.03.22.
//

import UIKit
import RealmSwift

class Task: Object {
    @Persisted var title: String
    @Persisted var detailText: String
    @Persisted var date = Date()
    @Persisted var done: Bool
    @Persisted var subtasks: List<Subtask>
    
    convenience init(title: String, detailedText: String) {
        self.init()
        self.title = title
        self.detailText = detailedText
        self.done = false
    }
    
}

class Subtask: Object {
    @Persisted var title: String
    @Persisted var detailText: String
    @Persisted var date = Date()
    @Persisted var done: Bool
    @Persisted(originProperty: "subtasks") var task: LinkingObjects<Task>
    
    convenience init(title: String, detailedText: String) {
        self.init()
        self.title = title
        self.detailText = detailedText
        self.done = false
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }
}

extension String {
    
    func strikeThrough() -> NSAttributedString{
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func unStrikeThrought() -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        return attributeString
    }
    
}
