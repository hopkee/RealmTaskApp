//
//  Model.swift
//  RealmTaskApp
//
//  Created by Valya on 12.03.22.
//

import Foundation
import RealmSwift

class Task: Object {
    @Persisted var title: String
    @Persisted var detailText: String
    @Persisted var date = Date()
    
    convenience init(title: String, detailedText: String) {
        self.init()
        self.title = title
        self.detailText = detailedText
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
