//
//  Task.swift
//  CheckYourTask
//
//  Created by macbook on 02.05.2023.
//

import Foundation

class Task {
    var name: String
    var description: String
    var date: Date
    var time: Date?
    var reminder: Bool
    var isComplete: Bool
    
    init(name: String, description: String, date: Date, time: Date? = nil, reminder: Bool, isComplete: Bool) {
        self.name = name
        self.description = description
        self.date = date
        self.time = time
        self.reminder = reminder
        self.isComplete = isComplete
    }
    
    func complete() {
        isComplete = !isComplete
    }
}
