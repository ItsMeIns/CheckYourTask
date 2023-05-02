//
//  Task.swift
//  CheckYourTask
//
//  Created by macbook on 02.05.2023.
//

import Foundation

class Task {
    var name: String
    var date: Date
    var isComplete: Bool
    
    init(name: String, date: Date, isComplete: Bool) {
        self.name = name
        self.date = date
        self.isComplete = isComplete
    }
    
    func complete() {
        isComplete = !isComplete
    }
}
